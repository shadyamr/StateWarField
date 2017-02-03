#include <a_mysql>

sql.inc (v1.2 BETA) - By Gammix

native SQL:sql_open(database[], host[] = "", user[] = "", pass[] = "", port = 3306, bool:autoreconnect = true, pool_size = 2, bool:debuging = false);
native sql_close(SQL:id);
native SQLResult:sql_query(SQL:id, query[], {Float, _}:...);
native sql_get_field(SQLResult:id, field, result[], maxlength = sizeof (result));
native sql_get_field_int(SQLResult:id, field);
native Float:sql_get_field_float(SQLResult:id, field);
native sql_get_field_assoc(SQLResult:id, field[], result[], maxlength = sizeof (result));
native sql_get_field_assoc_int(SQLResult:id, field[]);
native Float:sql_get_field_assoc_float(SQLResult:id, field[]);
native sql_next_row(SQLResult:id);
native sql_num_fields(SQLResult:id);
native sql_num_rows(SQLResult:id);
native sql_field_name(SQLResult:id, field, result[], maxlength = sizeof (result));
native sql_free_result(SQLResult:id);

#define MAX_SQL_FILES (10)
#define MAX_SQL_NAME (32)
enum E_SQL
{
	bool:   E_SQL_VALID,
			E_SQL_DATABASE[MAX_SQL_NAME],
	bool:   E_SQL_TYPE_DB,
    DB:		E_SQL_SQLITE_ID,
    		E_SQL_MYSQL_ID
};
static gSQL[SQL:MAX_SQL_FILES][E_SQL];

#define MAX_SQL_RESULTS (200)
enum E_SQL_RESULT
{
	bool:   	E_SQL_RESULT_VALID,
	SQL:		E_SQL_RESULT_FILE,
	DBResult:	E_SQL_RESULT_SQLITE_ID,
   	Cache:	 	E_SQL_RESULT_MYSQL_ID,
	            E_SQL_RESULT_MYSQL_ROW
};
static SQL:gSQLResult[SQLResult:MAX_SQL_RESULTS][E_SQL_RESULT];

forward _sql_fix_format();
public  _sql_fix_format()
{
    format("", 0, "");
}

stock SQL:sql_open(database[], host[] = "", user[] = "", pass[] = "", port = 3306, bool:autoreconnect = true, pool_size = 2, bool:debuging = false)
{
	new id = -1;
	for (new i; i < MAX_SQL_FILES; i++)
	{
	    if (gSQL[SQL:i][E_SQL_DATABASE][0] && ! strcmp(database, gSQL[SQL:i][E_SQL_DATABASE]))
	    {
	        return SQL:i;
	    }
	    else if (! gSQL[SQL:i][E_SQL_DATABASE][0] && id == -1)
		{
		    id = i;
		}
	}

	if (id == -1)
	{
	    return SQL:-1;
	}

	format(gSQL[SQL:id][E_SQL_DATABASE], MAX_SQL_NAME, database);

	if (host[0])
	{
	    gSQL[SQL:id][E_SQL_TYPE_DB] = false;

		if (debuging)
		{
		    mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);
		}
		gSQL[SQL:id][E_SQL_MYSQL_ID] = mysql_connect(host, user, database, pass, port, autoreconnect, pool_size);

		if (mysql_errno(gSQL[SQL:id][E_SQL_MYSQL_ID]) == 0)
		{
		    return SQL:-1;
		}
	}
	else
	{
	    gSQL[SQL:id][E_SQL_TYPE_DB] = true;

	    gSQL[SQL:id][E_SQL_SQLITE_ID] = db_open(database);

	    if (gSQL[SQL:id][E_SQL_SQLITE_ID] == DB:0)
	    {
	        return SQL:-1;
	    }
	}

	gSQL[SQL:id][E_SQL_VALID] = true;

	return SQL:id;
}

stock sql_close(SQL:id)
{
	if (id < SQL:0 || id >= SQL:MAX_SQL_FILES)
	{
	    return false;
	}

	if (! gSQL[id][E_SQL_VALID])
	{
	    return false;
	}

	if (gSQL[id][E_SQL_TYPE_DB])
	{
		db_close(gSQL[id][E_SQL_SQLITE_ID]);
	}
	else
	{
	    mysql_close(gSQL[id][E_SQL_MYSQL_ID]);
	}

	gSQL[id][E_SQL_VALID] = false;

	return true;
}

stock SQLResult:sql_query(SQL:id, query[], {Float, _}:...)
{
	if (id < SQL:0 || id >= SQL:MAX_SQL_FILES)
	{
	    return SQLResult:-1;
	}

	if (! gSQL[id][E_SQL_VALID])
	{
	    return SQLResult:-1;
	}

	const size = 4024;
	static string[size];
	string[0] = EOS;

	static args;
	args = numargs();

	if (args > 2)
	{
	    while (--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}

		#emit PUSH.S 		query
		#emit PUSH.C 		size
		#emit PUSH.C 		string

		#emit LOAD.S.pri 	8
		#emit CONST.alt 	16
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4
	}
	else
	{
	    strcat(string, query, size);
	}

	new idx = -1;
	for (new i; i < MAX_SQL_FILES; i++)
	{
		if (! gSQLResult[SQLResult:i][E_SQL_RESULT_VALID])
		{
		    idx = i;
		    break;
		}
	}

	if (idx == -1)
	{
	    return SQLResult:-1;
	}

	if (gSQL[id][E_SQL_TYPE_DB])
	{
		gSQLResult[SQLResult:idx][E_SQL_RESULT_SQLITE_ID] = db_query(gSQL[id][E_SQL_SQLITE_ID], string);
	}
	else
	{
	    mysql_tquery(gSQL[id][E_SQL_MYSQL_ID], string, "OnSQLResult", "i", idx);
	}

	gSQLResult[SQLResult:idx][E_SQL_RESULT_VALID] = true;
	gSQLResult[SQLResult:idx][E_SQL_RESULT_FILE] = id;

	return SQLResult:idx;
}

forward OnSQLResult(SQLResult:id);
public  OnSQLResult(SQLResult:id)
{
    gSQLResult[id][E_SQL_RESULT_MYSQL_ID] = cache_save(gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
    gSQLResult[id][E_SQL_RESULT_MYSQL_ROW] = 0;
}

stock sql_get_field(SQLResult:id, field, result[], maxlength = sizeof (result))
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    db_get_field(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field, result, maxlength);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		cache_get_row(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, result, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID], maxlength);
	}

	return true;
}

stock sql_get_field_int(SQLResult:id, field)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return -1;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return -1;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_get_field_int(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_row_int(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock Float:sql_get_field_float(SQLResult:id, field)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return -1000.0;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return -1000.0;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_get_field_float(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_row_float(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock sql_get_field_assoc(SQLResult:id, field[], result[], maxlength = sizeof (result))
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    db_get_field_assoc(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field, result, maxlength);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		cache_get_field_content(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, result, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID], maxlength);
	}

	return true;
}

stock sql_get_field_assoc_int(SQLResult:id, field[])
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return -1;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return -1;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_get_field_assoc_int(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_field_content_int(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock Float:sql_get_field_assoc_float(SQLResult:id, field[])
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return -1000.0;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return -1000.0;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_get_field_assoc_float(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_field_content_float(gSQLResult[id][E_SQL_RESULT_MYSQL_ROW], field, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock sql_next_row(SQLResult:id)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    if (! db_next_row(gSQLResult[id][E_SQL_RESULT_SQLITE_ID]))
	    {
	        return false;
	    }
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
	    if (gSQLResult[id][E_SQL_RESULT_MYSQL_ROW] >= cache_get_row_count(gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]))
	    {
	        return false;
	    }

        gSQLResult[id][E_SQL_RESULT_MYSQL_ROW]++;
	}

	return true;
}

stock sql_num_fields(SQLResult:id)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_num_rows(gSQLResult[id][E_SQL_RESULT_SQLITE_ID]);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_field_count(gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock sql_num_rows(SQLResult:id)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    return db_num_rows(gSQLResult[id][E_SQL_RESULT_SQLITE_ID]);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_row_count(gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}
}

stock sql_field_name(SQLResult:id, field, result[], maxlength = sizeof (result))
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    db_field_name(gSQLResult[id][E_SQL_RESULT_SQLITE_ID], field, result, maxlength);
	}
	else
	{
	    cache_set_active(gSQLResult[id][E_SQL_RESULT_MYSQL_ID]);
		return cache_get_field_name(field, result, gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID], maxlength);
	}

	return true;
}

stock sql_free_result(SQLResult:id)
{
	if (id < SQLResult:0 || id >= SQLResult:MAX_SQL_RESULTS)
	{
	    return false;
	}

	if (! gSQLResult[id][E_SQL_RESULT_VALID])
	{
	    return false;
	}

	if (gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_TYPE_DB])
	{
	    db_free_result(gSQLResult[id][E_SQL_RESULT_SQLITE_ID]);
	}
	else
	{
	    cache_delete(gSQLResult[id][E_SQL_RESULT_MYSQL_ID], gSQL[gSQLResult[id][E_SQL_RESULT_FILE]][E_SQL_MYSQL_ID]);
	}

	gSQLResult[id][E_SQL_RESULT_VALID] = false;

	return true;
}
