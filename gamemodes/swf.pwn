		/*<State War Field || created by ShadyEG, JaKe Elite, FERCOPRO>*/
///////////////////////////// Server Includes //////////////////////////////////

#include 					<a_samp>
#define 					INI_CONVERT_DINI
#include                    <gini>
#include                    <a_http>
#include                    <a_mysql>
#include                    <advertising>
#include                    <izcmd>
#include                    <nex-ac>
#include                    <streamer>
#include                    <foreach>
#include                    <sscanf2>
#include                    <crashdetect>

///////////////////////////// MySQL Config /////////////////////////////////////
#define 					mysql_host 							"localhost"
#define						mysql_user 							"root"
#define 					mysql_password 						""
#define 					mysql_database 	    				"swf"

////////////////////////////////////////////////////////////////////////////////

///////////////////////// Server Configuration /////////////////////////////////

#define                     MAX_WAR                                100

#define                     MINI_VERSION                          "v1.3"
#define                     SAMP_VERSION                        "0.3.7"

#define 					UserPath 						"Users/%s.ini"
#define strcpy(%0,%1,%2) strcat((%0[0] = '\0', %0), %1, %2)
#define function%0(%1)

////////////////////////////////////////////////////////////////////////////////

/////////////////////////////// Colors /////////////////////////////////////////
#define 						C_RED 							0xFF0000FF
#define 						C_GREY 							0xAFAFAFFF
#define 						C_BLUE							0x0000BBFF
#define 						C_WHITE 						0xFFFFFFFF
#define 						C_Yellow						0xFFFF00AA
#define 						C_LIME							0x99FF00FF

#define                         col_w                           "{FFFFFF}"
#define                         col_lb                          "{33CCFF}"
#define                         col_r                           "{FF0606}"
#define                         col_y                           "{FFFF00}"
#define                         col_g                           "{33AA33}"
#define                         col_gy                          "{AFAFAF}"
#define                         col_cr                          "{1ABC9C}"
#define                         col_up                        	"{6C7A89}"
#define                         col_cm                        	"{1E90FF}"
#define                         col_or                          "{FFC00C}"

#define 						COL_GREEN            		  	"{6EF83C}"
#define 						COL_RED                			"{F81414}"
#define 						COL_LIGHTBLUE          			"{00C0FF}"
#define 						COL_LGREEN             			"{C9FFAB}"
#define 						COL_LRED               			"{FFA1A1}"

#define 					COLOR_PM							0x33AA33AA
#define 					COLOR_CUSTOM 						0xE0FFFFAA
#define 					COLOR_PINK          				0xFF80FFAA
#define                     COLOR_WHITE                         0xFFFFFFAA
#define                     COLOR_RED                           0xFF0000AA
#define 					COLOR_GREEN 						0x33AA33AA
#define 					COLOR_GREY 							0xAFAFAFAA
#define 					COLOR_YELLOW 						0xFFFF00AA
#define 					COLOR_LIGHTBLUE 					0x33CCFFAA
#define 					COLOR_ORANGE 						0xFF8000AA
#define 					COLOR_REALRED 						0xFF0606AA
#define 					COLOR_UPDATE					    0x9C7912AA
#define 					COLOR_LIME 							0xB7FF00AA
#define 					COLOR_LIGHTGREEN 					0x9ACD32AA
#define 					COLOR_GRAD1 						0xB4B5B7FF
#define 					COLOR_BLUE              			0x60CED4FF
#define                     COLOR_DODGER                        0x1E90FFFF

////////////////////////////////////////////////////////////////////////////////

//////////////////////////////// Dialogs ///////////////////////////////////////

#define                     DIALOG_REGISTER                         0
#define                     DIALOG_LOGIN                            1
#define                     DIALOG_CLASS                            2
#define                     DIALOG_SHOW                             3
#define                     DIALOG_SHOP                             4
#define                     DIALOG_HELP                             5
#define 					DIALOG_STATS 							8530

////////////////////////////////////////////////////////////////////////////////

//////////////////////////// Server Updates ////////////////////////////////////
#define PROJECT_ID		148
#define USER_PROJECT		"Shady/SWF" // {Your username}/{Your project codename}
#define UPDATES_URL		"irresistiblegaming.com/rc_updates.php?id=" #PROJECT_ID // You can use your own!!! Check revctrl.php
#define DIALOG_CHANGES		4000
////////////////////////////////////////////////////////////////////////////////

///////////////////////////// Variables ////////////////////////////////////////
new vehicleDriver[MAX_VEHICLES] = INVALID_PLAYER_ID, playerCurVeh[MAX_PLAYERS] = INVALID_VEHICLE_ID;

new AirDamage[] =
{
	0,  // 0
	0,  // 1
	0,  // 2
	0,  // 3
	0,  // 4
	0,  // 5
	0,  // 6
	0,  // 7
	0,  // 8
	0,  // 9
	0,  // 10
	0,  // 11
	0,  // 12
	0,  // 13
	0,  // 14
	0,  // 15
	0,  // 16
	0,  // 17
	0,  // 18
	0,  // 19
	0,  // 20
	0,  // 21
	10, // 22
	16, // 23
	56, // 24
	60, // 25
	60, // 26
	48, // 27
	8,  // 28
	10, // 29
	12, // 30
	12, // 31
	8,  // 32
	30, // 33
	50, // 34
	0,  // 35
	0,  // 36
	0,  // 37
	56, // 38
	0,  // 39
};

new VehDamage[] =
{
	0,   // 0
	0,   // 1
	0,   // 2
	0,   // 3
	0,   // 4
	0,   // 5
	0,   // 6
	0,   // 7
	0,   // 8
	0,   // 9
	0,   // 10
	0,   // 11
	0,   // 12
	0,   // 13
	0,   // 14
	0,   // 15
	0,   // 16
	0,   // 17
	0,   // 18
	0,   // 19
	0,   // 20
	0,   // 21
	25,  // 22
	40,  // 23
	140, // 24
	150, // 25
	150, // 26
	120, // 27
	20,  // 28
	25,  // 29
	30,  // 30
	30,  // 31
	20,  // 32
	75,  // 33
	125, // 34
	0,   // 35
	0,   // 36
	0,   // 37
	140, // 38
	0,   // 39
};

new LastPM[MAX_PLAYERS];
new Stage[MAX_PLAYERS];
new CamTimer[MAX_PLAYERS];

new JailTimer[MAX_PLAYERS];
new Jailed[MAX_PLAYERS];
new DB:bans;
new PlayerText:Textdraw0;
new bool:HeadShot[MAX_PLAYERS];

new VehicleNames[212][] = {
{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
{"Utility Trailer"}
};

enum ZoneInfo
{
	UnderAttack,
	Captured,
	tCP,
	CP,
	Zone,
	bool:Taken,
	Text3D:zLabel,
	ZoneName[128],
	zMap,
	zAttacker,
	bool:zSpecial
}
new zInfo[MAX_WAR][ZoneInfo];

enum FlagInfo
{
	flagPickup,
	fMap,
	Text3D:fLabel,
	HasIt,
	TeamID,
	Float:flag_Pos[3],
	Float:oFlag_Pos[3],
	bool:fTaken,
	oTeam,
	bool:foldpos
};
new fInfo[MAX_WAR][FlagInfo];

new flagPlayer2[MAX_PLAYERS];
new flagPlayer[MAX_PLAYERS];

enum PlayerInfo
{
	IP[16],
    Admin,
    VIP,
    Money,
    Scores,
    Kills, 
    Deaths,
    RegisterDate[90],
    Rank,
    pCar,
    pHelmet,
    userid
};

enum pData
{
	ID,
 	PTag
};

new pInfo[MAX_PLAYERS][PlayerInfo];
new LoggedIn[MAX_PLAYERS];

new servermotdUpdate[256];

new gClass[MAX_PLAYERS];
new inClass[MAX_PLAYERS];
new gTeam[MAX_PLAYERS];
new Text:MainMenu[8];

new GZ_USA, GZ_EURASIA, GZ_AUSTRALIA, GZ_ARAB, GZ_SOVIET;

new CountVar[MAX_WAR] = 25;
new InCP[MAX_PLAYERS][MAX_WAR];
new CountTime[MAX_WAR];
new Capture[MAX_PLAYERS];
new Protection[MAX_PLAYERS];
new protect[MAX_PLAYERS];
new Text3D:Label[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
new Spawn[MAX_PLAYERS];
new TeamCapture[10];
new aDuty[MAX_PLAYERS];
new Warn[MAX_PLAYERS];
new takeZone[MAX_PLAYERS];
new specialZone = -1;
new Helping[MAX_PLAYERS][MAX_WAR];
new TempStr[255];
////////////////////////////////////////////////////////////////////////////////

#define 					SnakeFarm 								0
#define 					CiaHeadquarters 						1
#define 					PetrolStation 							2
#define 					BaitShop 								3
#define 					CluckinBell 							4
#define 					Ranch 									5
#define 					RadarBase 								6
#define 					OilDepot 								7
#define 					Quarry 									8
#define 					TheBigSpreadRanch 						9

////////////////////////////////////////////////////////////////////////////////

///////////////////////////////// Team /////////////////////////////////////////

#define                     TEAM_USA                                0
#define                     TEAM_EURASIA                             1
#define                     TEAM_ARAB                               2
#define                     TEAM_AUSTRALIA                             3
#define                     TEAM_SOVIET								4

#define                     NONE                                    9
   
#define 					NONE_COLOR 							0x000000AA
#define 					COLOR_USA		 					0x33CCFFAA
#define 					COLOR_USAS		 					0x33CCFF00
#define 					COLOR_EURASIA 						0x008000AA
#define 					COLOR_EURASIAS						0x00800000
#define 					COLOR_ARAB	 						0xFF8000AA
#define 					COLOR_ARABS							0xFF800000
#define 					COLOR_AUSTRALIA                    	0x642EFAAA
#define 					COLOR_AUSTRALIAS                   	0x642EFA00
#define 					COLOR_SOVIET                       	0xFF0000AA
#define 					COLOR_SOVIETS                      	0xFF000000

////////////////////////////////////////////////////////////////////////////////

////////////////////////////// Forward /////////////////////////////////////////

forward SpecialZone();
forward VehRes(vehicleid);
forward ForPlayer();
forward CountDown(playerid, zoneid);
forward SetCaptureZone(playerid);
forward SpawnProtection(playerid);
forward KickMe(playerid);
forward Death(playerid);
forward KickTimer(playerid);
public OnRevCTRLHTTPResponse(index, response_code, data[]);

////////////////////////////////////////////////////////////////////////////////

////////////////////////////// Stock ///////////////////////////////////////////
explode(const sSource[], aExplode[][], const sDelimiter[] = " ", iVertices = sizeof aExplode, iLength = sizeof aExplode[]) // Created by Westie
{
	new
		iNode,
		iPointer,
		iPrevious = -1,
		iDelimiter = strlen(sDelimiter);

	while(iNode < iVertices)
	{
		iPointer = strfind(sSource, sDelimiter, false, iPointer);

		if(iPointer == -1)
		{
			strmid(aExplode[iNode], sSource, iPrevious, strlen(sSource), iLength);
			break;
		}
		else
		{
			strmid(aExplode[iNode], sSource, iPrevious, iPointer, iLength);
		}

		iPrevious = (iPointer += iDelimiter);
		++iNode;
	}
	return iPrevious;
}

stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

stock GivePlayerScore(playerid, score)
{
	return SetPlayerScore(playerid, GetPlayerScore(playerid) + score);
}

stock SendMessageToAdmins(color, message[]) // to send message to online admins
{
   for(new i = 0; i < MAX_PLAYERS; i++)
   {
	  if (IsPlayerConnected(i))
	  {
			if (pInfo[i][Admin] >= 3)
			SendClientMessage(i, color, message);
	  }
   }
   return 1;
}

stock isnumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
    	if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

stock RegisterPlayer(playerid, passwordstring[])
{
    new query[600];
    
	new yearEx, monthEx, dayEx;
	getdate(yearEx, monthEx, dayEx);

	format(pInfo[playerid][RegisterDate], 90, "%02d/%02d/%d", monthEx, dayEx, yearEx);
    
    format(query, sizeof(query), "INSERT INTO `users` (`username`, `password`, `ip`, `registerdate`, `helmet`, `admin`, `vip`, `scores`, `money`, `kills`, `deaths`, `rank`) VALUES('%s', SHA1('%s'), '%s', '%s', 0, 0, 0, 30000, 0, 0, 0, 0)", nameEx(playerid), passwordstring, pInfo[playerid][IP], pInfo[playerid][RegisterDate]);
    mysql_query(query);
    print(query);
    
    pInfo[playerid][userid] = mysql_insert_id();

	GivePlayerMoney(playerid, pInfo[playerid][Money]);

    SendClientMessage(playerid, -1, "Info: "col_y"You have been registered on this server!");
    LoggedIn[playerid] = 1;
    return 1;
}

stock LoginPlayer(playerid)
{
    new query[600];
    format(query, sizeof(query), "SELECT * FROM `users` WHERE `username` = '%s'", nameEx(playerid));
    mysql_query(query); 
    mysql_store_result(); 

	new row[128];
	new field[13][91];

	mysql_fetch_row_format(row, "|");
	explode(row, field, "|");
	mysql_free_result();

	pInfo[playerid][userid] = strval(field[0]);
	format(pInfo[playerid][RegisterDate], 90, "%s", field[4]);
	pInfo[playerid][pHelmet] = strval(field[5]);
	pInfo[playerid][Admin] = strval(field[6]);
	pInfo[playerid][VIP] = strval(field[7]);
	pInfo[playerid][Money] = strval(field[8]);
	pInfo[playerid][Scores] = strval(field[9]);
	pInfo[playerid][Kills] = strval(field[10]);
	pInfo[playerid][Deaths] = strval(field[11]);
	pInfo[playerid][Rank] = strval(field[12]);

	SetPlayerScore(playerid, pInfo[playerid][Scores]);
	GivePlayerMoney(playerid, pInfo[playerid][Money]);
    SendClientMessage(playerid, -1, "Info: "col_y"You have successfully logged in to your account.");

	LoggedIn[playerid] = 1;

	new string[128];
	if(pInfo[playerid][Admin] >= 1)
	{
		format(string, sizeof(string), "* %s %s has logged into the SWF server.", GetAdminRank(playerid), nameEx(playerid));
		SendClientMessageToAll(COLOR_PINK, string);
	}
	if(pInfo[playerid][VIP] >= 1)
	{
		format(string, sizeof(string), "* Donor %s has logged into the SWF server.", nameEx(playerid));
		SendClientMessageToAll(COLOR_YELLOW, string);
	}
	return 1;
}

stock SpawnVehicle(playerid, vehicleid, color1, color2, Float:x, Float:y, Float:z, Float:a, interior, virtualworld)
{
	if(pInfo[playerid][pCar] != -1)
	EraseVeh(pInfo[playerid][pCar]);
	new VehicleID;
	VehicleID = CreateVehicle(vehicleid, x+3,y,z, a, color1, color2, -1);
	SetVehicleNumberPlate(VehicleID, "SWF");
	LinkVehicleToInterior(VehicleID, interior);
	SetVehicleVirtualWorld(VehicleID, virtualworld);
	pInfo[playerid][pCar] = VehicleID;
	return 1;
}

stock GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
		return i + 400;
	}
	return -1;
}

IsDriverAvailable(vehicleid)
{
	return (vehicleDriver[vehicleid] != INVALID_PLAYER_ID) ? (false) : (true);
}

IsAirModel(modelid)
{
    switch(modelid)
    {
        case 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593, 417, 425, 447, 469, 487, 488, 497, 548, 563:
		return 1;
    }
    return 0;
}

stock EraseVeh(vehicleid)
{
    foreach(new i : Player)
	{
        new Float:X, Float:Y, Float:Z;
    	if(IsPlayerInVehicle(i, vehicleid))
		{
	  		RemovePlayerFromVehicle(i);
	  		GetPlayerPos(i, X, Y, Z);
	 		SetPlayerPos(i, X, Y+3, Z);
	    }
	    SetVehicleParamsForPlayer(vehicleid, i, 0, 1);
	}
    SetTimerEx("VehRes", 1500, 0, "i", vehicleid);
}

stock Initialize_PTD(playerid)
{
	Textdraw0 = CreatePlayerTextDraw(playerid, 12.000000, 432.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, Textdraw0, 255);
	PlayerTextDrawFont(playerid, Textdraw0, 1);
	PlayerTextDrawLetterSize(playerid, Textdraw0, 0.410000, 1.200000);
	PlayerTextDrawColor(playerid, Textdraw0, -1);
	PlayerTextDrawSetOutline(playerid, Textdraw0, 0);
	PlayerTextDrawSetProportional(playerid, Textdraw0, 1);
	PlayerTextDrawSetShadow(playerid, Textdraw0, 1);
	return 1;
}

stock ShowDialog(playerid, type)
{
	switch(type)
	{
	    case 0: ShowPlayerDialog(playerid, DIALOG_CLASS, DIALOG_STYLE_LIST, ""col_lb"Select your team class.", "Assault\nSniper\nPilot\nEngineer\nSupporter\nDemolisher\nDonor (VIP level 3)", "Choose", "");
		case 1: ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, ""col_g"Armoury Shop.", "Health - $5,000\nArmor - $6,500\nNight Vision - $10,000\nThermal Goggles - $10,000\nBinoculars - $800\nHelmet - $7,000", "Choose", "Cancel");
		case 2: ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, ""col_g"Armoury Shop.", "Health "col_y"(FREE)\nArmor "col_y"(FREE)\nNight Vision - $10,000\nThermal Goggles - $10,000\nBinoculars - $800\nHelmet "col_y"(FREE)", "Choose", "Cancel");
	}
	return 1;
}

stock GetZoneName(id)
{
	new zone[100];
	switch(id)
	{
	    case SnakeFarm: zone = "Snake Farm";
	    case CiaHeadquarters: zone = "CIA Headquarters";
	    case CluckinBell: zone = "Cluckin' Bell (Desert)";
	    case PetrolStation: zone = "Petrol Station (Desert)";
	    case BaitShop: zone = "Bait Shop";
	    case Ranch: zone = "Ranch";
	    case RadarBase: zone = "Big Ear";
	    case OilDepot: zone = "Oil Industry";
	    case Quarry: zone = "Hunter Quarry";
	    case TheBigSpreadRanch: zone = "The Big Spread Ranch";
	}
	return zone;
}

stock GetClass(playerid)
{
	new classname[90];
	switch(gClass[playerid])
	{
	    case 1: classname = "Assault";
	    case 2: classname = "Sniper";
	    case 3: classname = "Pilot";
	    case 4: classname = "Engineer";
	    case 5: classname = "Supporter";
	    case 6: classname = "Demolisher";
	    case 7: classname = "Donor";
	    default: classname = "Roaming";
	}
	return classname;
}

stock GetAdminRank(playerid)
{
	new rank[100];
	switch(pInfo[playerid][Admin])
	{
	    case 1: rank = "Junior Admin";
	    case 2: rank = "General Admin";
	    case 3: rank = "Senior Admin";
	    case 4: rank = "Head Admin";
	    case 5: rank = "Executive Admin";
	}
	return rank;
}

stock GetVIPRank(playerid)
{
	new rank[100];
	switch(pInfo[playerid][VIP])
	{
	    case 1: rank = "Bronze VIP";
	    case 2: rank = "Silver VIP";
	    case 3: rank = "Gold VIP";
	}
	return rank;
}

stock GetPlayersCountInTeam(teamid) 
{
	new playercount = 0;
	for(new x = 0; x < MAX_PLAYERS; x ++)
	{
		if(GetPlayerState(x) == PLAYER_STATE_NONE) continue; 
		if(gTeam[x] != teamid) continue;
		playercount++; 
	}
    return playercount; 
}

stock SetPlayerTeamColor(playerid)
{
	switch(gTeam[playerid])
	{
	    case TEAM_USA: SetPlayerColor(playerid, COLOR_USA);
	    case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIA);
	    case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARAB);
	    case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIA);
	    case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIET);
	    default: SetPlayerColor(playerid, COLOR_GREY);
	}

	if(gClass[playerid] == 2 || gTeam[playerid] == 7)
	{
		switch(gTeam[playerid])
		{
	    	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
	    	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
	    	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
	    	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
	    	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
		}
	}

    if(pInfo[playerid][VIP] >= 2)
    {
		switch(gTeam[playerid])
		{
        	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
        	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
        	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
        	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
        	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
		}
    }
}

stock ClearMe(playerid, line=100)
{
	for(new i=0; i<line; i++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}

stock IsAPlane(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
	}
	return 0;
}

stock IsAHelicopter(carid)
{
	if(GetVehicleModel(carid) == 548 || GetVehicleModel(carid) == 425 || GetVehicleModel(carid) == 417 || GetVehicleModel(carid) == 487 || GetVehicleModel(carid) == 488 || GetVehicleModel(carid) == 497 || GetVehicleModel(carid) == 563 || GetVehicleModel(carid) == 447 || GetVehicleModel(carid) == 469 || GetVehicleModel(carid) == 593)
	{
		return 1;
	}
	return 0;
}

stock SetTeam(playerid, classx)
{
	switch(classx)
	{
	    case 0: gTeam[playerid] = TEAM_USA, GameTextForPlayer(playerid, "~n~~n~~n~~n~~b~~h~~h~U.S.A.", 1000, 3);
	    case 1: gTeam[playerid] = TEAM_EURASIA, GameTextForPlayer(playerid, "~n~~n~~n~~n~~b~Eurasia", 1000, 3);
	    case 2: gTeam[playerid] = TEAM_ARAB, GameTextForPlayer(playerid, "~n~~n~~n~~n~~y~~h~~h~Arab", 1000, 3);
	    case 3: gTeam[playerid] = TEAM_AUSTRALIA, GameTextForPlayer(playerid, "~n~~n~~n~~n~~p~Australia", 1000, 3);
	    case 4: gTeam[playerid] = TEAM_SOVIET, GameTextForPlayer(playerid, "~n~~n~~n~~n~~r~~h~~h~~h~Soviet", 1000, 3);
	}
	
	SetPlayerTeam(playerid, gTeam[playerid]);
	return 1;
}

stock Initialize_Spawn(playerid)
{
	new team = gTeam[playerid];
	// Armory System
	if(gClass[playerid] != 7 || pInfo[playerid][VIP] < 3)
	{
		if(TeamCapture[team] >= 1)
		{
			SendClientMessage(playerid, -1, "You received an armour containing 20 percent of it from the captured zones of your team.");
			SetPlayerArmour(playerid, 20.0);
		}
		else if(TeamCapture[team] >= 3)
		{
			SendClientMessage(playerid, -1, "You received an armour containing 25 percent of it from the captured zones of your team.");
			SetPlayerArmour(playerid, 25.0);
		}
		else if(TeamCapture[team] >= 6)
		{
			SendClientMessage(playerid, -1, "You received an armour containing 32 percent of it from the captured zones of your team.");
			SetPlayerArmour(playerid, 32.0);
		}
		else if(TeamCapture[team] >= 8)
		{
			SendClientMessage(playerid, -1, "You received an armour containing 40 percent of it from the captured zones of your team.");
			SetPlayerArmour(playerid, 40.0);
		}
		else if(TeamCapture[team] >= 10)
		{
			SendClientMessage(playerid, -1, "You received an armour containing 50 percent of it from the captured zones of your team.");
			SetPlayerArmour(playerid, 50.0);
		}
		else
		{
			SendClientMessage(playerid, -1, "Your team has not captured any zones, Therefore you only have 10 percent of armory.");
			SetPlayerArmour(playerid, 10.0);
		}
	}
	else
	{
	    SetPlayerArmour(playerid, 100.0);
	    SendClientMessage(playerid, -1, "You received a full percentage of armoury - Donor Level 3+ benefit.");
	}
	
	if(gClass[playerid] == 7 || pInfo[playerid][VIP] >= 5)
	{
	    pInfo[playerid][pHelmet] = 1;
	    SendClientMessage(playerid, -1, "You received a free helmet accessory - Donor Level 3+ benefit.");
	}
	
	// Admin On Duty
	
	if(aDuty[playerid] == 1)
	{
	    UpdateDynamic3DTextLabelText(Label[playerid], COLOR_REALRED, "* DO NOT ATTACK, ADMIN ON DUTY **");
	    SetPlayerColor(playerid, COLOR_PINK);
	    aDuty[playerid] = 1;
	    pInfo[playerid][pHelmet] = 1;
	    SetPlayerArmour(playerid, 100000);
	    SetPlayerHealth(playerid, 100000);
	}
	
	// Label on Head
	
	new string[128]; format(string, sizeof(string), "%s", GetRank(playerid));
	UpdateDynamic3DTextLabelText(Label[playerid], GetPlayerColor(playerid), string);
	
	// Weapon
	
	switch(gClass[playerid])
	{
	    case 1:
	    {
	        GivePlayerWeapon(playerid, 24, 1000);
	        GivePlayerWeapon(playerid, 27, 500);
	        GivePlayerWeapon(playerid, 31, 1000);
	        GivePlayerWeapon(playerid, 16, 5);
	    }
	    case 2:
	    {
	        GivePlayerWeapon(playerid, 4, 1);
	        GivePlayerWeapon(playerid, 29, 1000);
	        GivePlayerWeapon(playerid, 34, 150);
	        GivePlayerWeapon(playerid, 24, 1000);
	        GivePlayerWeapon(playerid, 16, 5);
	    }
		case 3:
		{
		    GivePlayerWeapon(playerid, 24, 1000);
		    GivePlayerWeapon(playerid, 29, 1000);
		    GivePlayerWeapon(playerid, 27, 500);
		    GivePlayerWeapon(playerid, 33, 150);
		}
		case 4:
		{
		    GivePlayerWeapon(playerid, 18, 7);
		    GivePlayerWeapon(playerid, 23, 1000);
		    GivePlayerWeapon(playerid, 25, 150);
		    GivePlayerWeapon(playerid, 29, 1000);
		    GivePlayerWeapon(playerid, 31, 1000);
		}
		case 5:
		{
	        GivePlayerWeapon(playerid, 24, 1000);
	        GivePlayerWeapon(playerid, 27, 500);
	        GivePlayerWeapon(playerid, 31, 1000);
	        GivePlayerWeapon(playerid, 16, 5);
		}
		case 6:
		{
	        GivePlayerWeapon(playerid, 24, 1000);
	        GivePlayerWeapon(playerid, 27, 500);
	        GivePlayerWeapon(playerid, 31, 1000);
	        GivePlayerWeapon(playerid, 16, 5);
		}
		case 7:
		{
		    // Extra Weapons
	        GivePlayerWeapon(playerid, 16, 10);
	        GivePlayerWeapon(playerid, 26, 1000);
	        GivePlayerWeapon(playerid, 24, 2000);
	        GivePlayerWeapon(playerid, 32, 2000);
	        GivePlayerWeapon(playerid, 31, 2000);
	        GivePlayerWeapon(playerid, 34, 250);
	        GivePlayerWeapon(playerid, 44, 1);
	        GivePlayerWeapon(playerid, 45, 1);
		}
	}
	SendClientMessage(playerid, -1, "Your class weapons has been received.");
	if(gClass[playerid] == 7)
	{
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, "As part of Donor Class, you have an extra ammo (5x) + extra weapon on you (Goggles, Mac10, Sniper, Sawn-Off etc.).");
	}
	return 1;
}

stock GetZoneColor(id)
{
	new intx;

	switch(id)
	{
	    case 0: intx = COLOR_USA;
	    case 1: intx = COLOR_EURASIA;
	    case 2: intx = COLOR_ARAB;
	    case 3: intx = COLOR_AUSTRALIA;
	    case 4: intx = COLOR_SOVIET;
	    default: intx = NONE_COLOR;
	}
	return intx;
}

stock Initialize_MapIcon()
{
	// Shop
	
	CreateDynamicMapIcon(1045.4778,1768.3199,10.8203, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(1045.4778,1768.3199,10.8203, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(223.4125,1864.7605,13.1406, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-936.6464,2030.7827,60.9141, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(414.0443,2536.2119,19.1484, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-252.9420,2602.9783,62.8582, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-835.1113,2755.6204,45.8439, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-369.8844,1191.4733,19.6796, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-760.9649,1606.5844,27.1172, 6, -1, -1, -1, -1, 500.0);
	CreateDynamicMapIcon(-95.6546,713.9930,24.1914, 6, -1, -1, -1, -1, 500.0);
	
	print("Initializing Dynamic MapIcons...");
	return 1;
}

stock AtShop(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1045.4778,1768.3199,10.8203) || IsPlayerInRangeOfPoint(playerid, 3.0, 223.4125,1864.7605,13.1406))
	{
	    return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, -936.6464,2030.7827,60.9141) || IsPlayerInRangeOfPoint(playerid, 3.0, 414.0443,2536.2119,19.1484))
	{
	    return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, -252.9420,2602.9783,62.8582) || IsPlayerInRangeOfPoint(playerid, 3.0, -835.1113,2755.6204,45.8439))
	{
	    return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, -369.8844,1191.4733,19.6796) || IsPlayerInRangeOfPoint(playerid, 3.0, -760.9649,1606.5844,27.1172))
	{
	    return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, -95.6546,713.9930,24.1914))
	{
	    return 1;
	}
	else
	{
	    return 0; // Not in shop.
	}
}

stock Initialize_Shop()
{
	// Shop

	Create3DTextLabel("Game Shop\n/buy\nto buy an armory and etc.", -1, 223.4125,1864.7605,13.1406, 40.0, 0, 1);
	CreatePickup(1210, 1, 223.4125,1864.7605,13.1406, -1);
	
	Create3DTextLabel("Game Shop\n/buy\nto buy an armory and etc.", -1, -936.6464,2030.7827,60.9141, 40.0, 0, 1);
	CreatePickup(1210, 1, -936.6464,2030.7827,60.9141, -1);
	
	Create3DTextLabel("Game Shop\n/buy\nto buy an armory and etc.", -1, 414.0443,2536.2119,19.1484, 40.0, 0, 1);
	CreatePickup(1210, 1, 414.0443,2536.2119,19.1484, -1);
	
	Create3DTextLabel("Game Shop\n/buy\nto buy an armory and etc.", -1, -835.1113,2755.6204,45.8439, 40.0, 0, 1);
	CreatePickup(1210, 1, -835.1113,2755.6204,45.8439, -1);
	
	Create3DTextLabel("Game Shop\n/buy\nto buy an armory and etc.", -1, -369.8844,1191.4733,19.6796, 40.0, 0, 1);
	CreatePickup(1210, 1, -369.8844,1191.4733,19.6796, -1);
	
	print("Initializing Shops...");
	return 1;
}

stock GetTeamEx(gteam)
{
	new team[100];
	switch(gteam)
	{
	    case 0: team = "USA";
	    case 1: team = "Eurasia";
	    case 2: team = "Arab";
	    case 3: team = "Australia";
	    case 4: team = "Soviet";
	    default: team = "Mercenary";
	}
	return team;
}

stock GetTeam(playerid)
{
	new team[100];
	switch(gTeam[playerid])
	{
	    case 0: team = "USA";
	    case 1: team = "Eurasia";
	    case 2: team = "Arab";
	    case 3: team = "Australia";
	    case 4: team = "Soviet";
	}
	return team;
}

stock Initialize_WarFieldShow(playerid)
{
	for(new x=0; x<MAX_WAR; x++)
	{
	    if(zInfo[x][Taken] == true)
	    {
	        GangZoneShowForPlayer(playerid, zInfo[x][Zone], GetZoneColor(zInfo[x][tCP]));
	    }
	}
	return 1;
}

stock nameEx(playerid)
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	return playerName;
}

stock Path(playerid)
{
    new string[128+50];
    format(string, sizeof(string), UserPath, nameEx(playerid));
    return string;
}

stock Initialize_Settings()
{
	print("Initializing Server Settings...");

	if(!fexist("motd.cfg"))
	{
		dini_Create("motd.cfg");

		format(servermotdUpdate, 256, "Version 1.3 of SWF is out.");

	    dini_Set("motd.cfg", "SMOTDUpdate", servermotdUpdate);
	}
	else
	{
		format(servermotdUpdate, 256, "%s", dini_Get("motd.cfg", "SMOTDUpdate"));
	}
	
	printf("Server MOTD: %s", servermotdUpdate);
	return 1;
}

stock Update_Settings()
{
    dini_Set("motd.cfg", "SMOTDUpdate", servermotdUpdate);
    
    print("Settings has been saved via a calling function...");
	return 1;
}

stock Initialize_TD()
{
	print("Initializing Server Textdraws...");

	MainMenu[1] = TextDrawCreate(643.000000, 0.000000, "New Area");
	TextDrawBackgroundColor(MainMenu[1], 255);
	TextDrawFont(MainMenu[1], 1);
	TextDrawLetterSize(MainMenu[1], 0.500000, 7.600000);
	TextDrawColor(MainMenu[1], -1);
	TextDrawSetOutline(MainMenu[1], 0);
	TextDrawSetProportional(MainMenu[1], 1);
	TextDrawSetShadow(MainMenu[1], 1);
	TextDrawUseBox(MainMenu[1], 1);
	TextDrawBoxColor(MainMenu[1], 117);
	TextDrawTextSize(MainMenu[1], -20.000000, -5.000000);

	// Top Colored Bar
	MainMenu[2] = TextDrawCreate(643.000000, 310.000000, "New Area");
	TextDrawBackgroundColor(MainMenu[2], 255);
	TextDrawFont(MainMenu[2], 1);
	TextDrawLetterSize(MainMenu[2], 0.500000, 8.299999);
	TextDrawColor(MainMenu[2], -1);
	TextDrawSetOutline(MainMenu[2], 0);
	TextDrawSetProportional(MainMenu[2], 1);
	TextDrawSetShadow(MainMenu[2], 1);
	TextDrawUseBox(MainMenu[2], 1);
	TextDrawBoxColor(MainMenu[2], 117);
	TextDrawTextSize(MainMenu[2], -19.000000, -6.000000);

	/// Bottom Colored Bar
	MainMenu[3] = TextDrawCreate(653.000000, 142.000000, "New Area");
	TextDrawBackgroundColor(MainMenu[3], 255);
	TextDrawFont(MainMenu[3], 1);
	TextDrawLetterSize(MainMenu[3], 0.500000, -0.200000);
	TextDrawColor(MainMenu[3], -1);
	TextDrawSetOutline(MainMenu[3], 0);
	TextDrawSetProportional(MainMenu[3], 1);
	TextDrawSetShadow(MainMenu[3], 1);
	TextDrawUseBox(MainMenu[3], 1);
	TextDrawBoxColor(MainMenu[3], 255);
	TextDrawTextSize(MainMenu[3], -9.000000, -4.000000);

	MainMenu[4] = TextDrawCreate(653.000000, 309.000000, "New Area");
	TextDrawBackgroundColor(MainMenu[4], 255);
	TextDrawFont(MainMenu[4], 1);
	TextDrawLetterSize(MainMenu[4], 0.500000, -0.200000);
	TextDrawColor(MainMenu[4], -1);
	TextDrawSetOutline(MainMenu[4], 0);
	TextDrawSetProportional(MainMenu[4], 1);
	TextDrawSetShadow(MainMenu[4], 1);
	TextDrawUseBox(MainMenu[4], 1);
	TextDrawBoxColor(MainMenu[4], 255);
	TextDrawTextSize(MainMenu[4], -9.000000, -4.000000);

	MainMenu[5] = TextDrawCreate(182.000000, 62.000000, "---- State War Field -----");
	TextDrawBackgroundColor(MainMenu[5], 255);
	TextDrawFont(MainMenu[5], 1);
	TextDrawLetterSize(MainMenu[5], 0.770000, 3.500000);
	TextDrawColor(MainMenu[5], -1);
	TextDrawSetOutline(MainMenu[5], 0);
	TextDrawSetProportional(MainMenu[5], 1);
	TextDrawSetShadow(MainMenu[5], 1);

	MainMenu[6] = TextDrawCreate(250.000000, 343.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawAlignment(MainMenu[6], 2);
	TextDrawBackgroundColor(MainMenu[6], 255);
	TextDrawFont(MainMenu[6], 1);
	TextDrawLetterSize(MainMenu[6], 1.000000, 2.000000);
	TextDrawColor(MainMenu[6], -16776961);
	TextDrawSetOutline(MainMenu[6], 1);
	TextDrawSetProportional(MainMenu[6], 1);
	TextDrawUseBox(MainMenu[6], 1);
	TextDrawBoxColor(MainMenu[6], 255);
	TextDrawTextSize(MainMenu[6], 90.000000, 803.000000);

	MainMenu[7] = TextDrawCreate(260.000000, 95.000000, "Server Version 1.0.0");
	TextDrawBackgroundColor(MainMenu[7], 255);
	TextDrawFont(MainMenu[7], 1);
	TextDrawLetterSize(MainMenu[7], 0.440000, 1.200000);
	TextDrawColor(MainMenu[7], -1);
	TextDrawSetOutline(MainMenu[7], 0);
	TextDrawSetProportional(MainMenu[7], 1);
	TextDrawSetShadow(MainMenu[7], 1);
	return 1;
}

stock Initialize_Object()
{
	print("Initializing Dynamic Objects...");
	
	// USARMY BASE
	CreateObject(3268,306.5000000,2050.1001000,16.5000000,0.0000000,0.0000000,90.0000000); //object(mil_hangar1_) (1)
	CreateObject(3115,87.0000000,1876.3000500,24.5000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (1)
	CreateObject(3115,87.0000000,1857.5999800,24.5000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (2)
	CreateObject(3115,87.0000000,1838.8000500,24.5000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (3)
	CreateObject(3115,87.0000000,1820.0000000,24.5000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (4)
	CreateObject(3115,121.0000000,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (5)
	CreateObject(3115,139.7000000,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (6)
	CreateObject(3115,158.3999900,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (7)
	CreateObject(3115,177.2000000,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (8)
	CreateObject(3115,196.0000000,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (9)
	CreateObject(3115,214.7000000,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (10)
	CreateObject(3115,233.3999900,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (11)
	CreateObject(3115,252.1000100,1789.0000000,24.5000000,0.0000000,0.0000000,90.0000000); //object(carrier_lift1_sfse) (12)
	CreateObject(3115,103.1000000,1951.0000000,25.5000000,0.0000000,0.0000000,270.0000000); //object(carrier_lift1_sfse) (13)
	CreateObject(3115,121.8000000,1951.0000000,25.5000000,0.0000000,0.0000000,270.0000000); //object(carrier_lift1_sfse) (14)
	CreateObject(3115,140.5000000,1951.0000000,25.5000000,0.0000000,0.0000000,270.0000000); //object(carrier_lift1_sfse) (15)
	CreateObject(3115,159.3000000,1951.0000000,25.5000000,0.0000000,0.0000000,270.0000000); //object(carrier_lift1_sfse) (16)
	CreateObject(3115,178.0000000,1951.0000000,25.5000000,0.0000000,0.0000000,270.0000000); //object(carrier_lift1_sfse) (17)
	CreateObject(13749,128.0000000,1809.1992200,18.2000000,0.0000000,0.0000000,233.9980000); //object(cunte_curvesteps1) (1)
	CreateObject(13749,240.5000000,1809.1992200,18.2000000,0.0000000,0.0000000,233.9980000); //object(cunte_curvesteps1) (2)
	CreateObject(13749,184.5000000,1809.1992200,18.2000000,0.0000000,0.0000000,234.0000000); //object(cunte_curvesteps1) (3)
	CreateObject(13749,107.2998000,1831.3994100,18.2000000,0.0000000,0.0000000,141.9980000); //object(cunte_curvesteps1) (4)
	CreateObject(13749,107.3000000,1887.5000000,18.2000000,0.0000000,0.0000000,142.0000000); //object(cunte_curvesteps1) (5)
	CreateObject(13749,152.0000000,1930.5000000,19.2000000,0.0000000,0.0000000,52.0000000); //object(cunte_curvesteps1) (6)
	CreateObject(2774,186.0000000,1960.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (1)
	CreateObject(2774,186.0000000,1942.3000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (2)
	CreateObject(2774,95.0000000,1942.3000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (3)
	CreateObject(2774,95.0000000,1960.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (4)
	CreateObject(2774,78.0000000,1884.0000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (5)
	CreateObject(2774,95.7000000,1884.0000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (6)
	CreateObject(2774,95.7000000,1811.5000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (7)
	CreateObject(2774,79.0000000,1811.5000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (8)
	CreateObject(2774,113.0000000,1780.0000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (9)
	CreateObject(2774,113.0000000,1797.8000500,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (10)
	CreateObject(2774,260.0000000,1797.8000500,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (11)
	CreateObject(2774,260.0000000,1780.0000000,11.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (12)
	CreateObject(3268,214.0000000,1883.4000200,16.5000000,0.0000000,0.0000000,270.0000000); //object(mil_hangar1_) (2)
	CreateObject(3268,370.0000000,1945.0000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(mil_hangar1_) (5)
	CreateObject(3268,370.0000000,1910.0000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(mil_hangar1_) (6)
	CreateObject(13749,291.0000000,1865.0000000,18.0000000,0.0000000,0.0000000,52.0000000); //object(cunte_curvesteps1) (7)
	CreateObject(13749,280.3999900,1888.0000000,18.0000000,0.0000000,0.0000000,230.0000000); //object(cunte_curvesteps1) (8)
	CreateObject(3113,269.7999900,1877.1999500,15.9000000,0.0000000,285.0000000,0.0000000); //object(carrier_door_sfse) (1)
	CreateObject(3884,226.0000000,1895.0000000,16.2000000,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	CreateObject(3884,202.0000000,1895.0000000,16.2000000,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (2)
	CreateObject(2985,190.3999900,1925.0000000,22.5000000,0.0000000,0.0000000,214.0000000); //object(minigun_base) (1)
	CreateObject(2985,223.3000000,1925.0000000,22.5000000,0.0000000,0.0000000,326.0000000); //object(minigun_base) (2)
	CreateObject(2985,206.8999900,1925.0000000,22.5000000,0.0000000,0.0000000,270.0000000); //object(minigun_base) (3)
	CreateObject(2921,199.0000000,1893.0000000,22.6000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (1)
	CreateObject(2921,138.2000000,1840.5999800,21.8000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (2)
	CreateObject(2921,360.0000000,1895.5999800,22.3000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (3)
	CreateObject(2921,360.0000000,1930.6999500,22.4000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (4)
	CreateObject(2921,360.0000000,1965.6999500,22.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (5)
	CreateObject(2978,208.3000000,1874.3000500,12.1000000,0.0000000,0.0000000,0.0000000); //object(kmilitary_base) (1)
	CreateObject(3787,204.3000000,1872.6999500,12.7000000,0.0000000,0.0000000,0.0000000); //object(missile_02_sfxr) (1)
	CreateObject(3787,186.3999900,1933.9000200,17.3000000,0.0000000,0.0000000,0.0000000); //object(missile_02_sfxr) (2)
	CreateObject(3787,140.0000000,1830.5999800,17.2000000,0.0000000,0.0000000,0.0000000); //object(missile_02_sfxr) (3)
	CreateObject(3787,324.2999900,2055.8999000,17.2000000,0.0000000,0.0000000,0.0000000); //object(missile_02_sfxr) (4)
	CreateObject(3633,324.3999900,2058.1001000,17.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (1)
	CreateObject(3633,287.7999900,2003.4000200,17.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (2)
	CreateObject(3633,358.7000100,1899.6999500,17.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (3)
	CreateObject(3633,227.6000100,1922.1999500,17.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (4)
	CreateObject(3633,112.0000000,1902.6999500,18.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (5)
	CreateObject(3633,112.0000000,1834.1999500,17.1000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (6)
	CreateObject(12861,170.5000000,1813.5999800,16.6000000,0.0000000,0.0000000,90.0000000); //object(sw_cont05) (1)
	CreateObject(12861,216.0000000,1952.0000000,16.0000000,0.0000000,0.0000000,0.0000000); //object(sw_cont05) (2)
	CreateObject(12861,204.0000000,2022.0000000,16.0000000,0.0000000,0.0000000,180.0000000); //object(sw_cont05) (3)
	CreateObject(17020,340.0000000,1850.0000000,20.0000000,0.0000000,0.0000000,0.0000000); //object(cuntfrates02) (1)
	CreateObject(1337,149.3037100,1829.6494100,17.1480600,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (9)
	CreateObject(3630,265.3999900,1918.6999500,18.1000000,0.0000000,0.0000000,324.0000000); //object(crdboxes2_las) (1)
	CreateObject(3630,169.6000100,1932.1999500,18.9000000,0.0000000,0.0000000,0.0000000); //object(crdboxes2_las) (2)
	CreateObject(3630,288.2999900,1972.4000200,18.1000000,0.0000000,0.0000000,90.0000000); //object(crdboxes2_las) (3)
	CreateObject(3761,287.7999900,1907.0000000,18.6000000,0.0000000,0.0000000,0.0000000); //object(industshelves) (1)
	CreateObject(3796,225.3000000,1883.4000200,16.6000000,0.0000000,0.0000000,0.0000000); //object(acbox1_sfs) (1)
	CreateObject(10814,242.0000000,1966.0000000,20.7000000,0.0000000,0.0000000,0.0000000); //object(apfuel2_sfse) (1)
	CreateObject(3255,239.8000000,1996.6999500,16.6000000,0.0000000,0.0000000,0.0000000); //object(ref_oiltank01) (1)
	CreateObject(3214,245.3999900,2012.5000000,25.6000000,0.0000000,0.0000000,0.0000000); //object(quarry_crusher) (1)
	CreateObject(3287,284.7999900,2051.3000500,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (1)
	CreateObject(3287,276.8999900,2051.1999500,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (2)
	CreateObject(3287,324.6000100,2049.3999000,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (3)
	CreateObject(3287,385.5000000,1983.4000200,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (4)
	CreateObject(3287,385.1000100,1951.4000200,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (5)
	CreateObject(3287,385.2000100,1940.0000000,21.4000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (6)
	CreateObject(3287,105.2000000,1932.6999500,22.2000000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (7)
	CreateObject(3268,370.0000000,1980.0000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(mil_hangar1_) (4)
	
	/// EURASIA BASE
	
	CreateObject(3115,-920.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (18)
	CreateObject(3115,-899.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (19)
	CreateObject(3115,-878.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (21)
	CreateObject(3115,-857.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (22)
	CreateObject(3115,-836.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (23)
	CreateObject(3115,-815.0000000,2100.0000000,55.8000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (24)
	CreateObject(900,-928.0000000,2095.0000000,38.0000000,0.0000000,0.0000000,80.0000000); //object(searock04) (1)
	CreateObject(900,-930.0000000,2100.0000000,38.0000000,0.0000000,0.0000000,248.0000000); //object(searock04) (2)
	CreateObject(900,-802.7000100,2095.0000000,38.0000000,0.0000000,0.0000000,80.0000000); //object(searock04) (3)
	CreateObject(900,-800.5000000,2108.8999000,38.0000000,0.0000000,0.0000000,280.0000000); //object(searock04) (4)
	CreateObject(12990,-888.0000000,2017.0000000,56.0000000,0.0000000,0.0000000,0.0000000); //object(sw_jetty) (1)
	CreateObject(12990,-888.0000000,2047.0000000,56.0000000,0.0000000,0.0000000,180.0000000); //object(sw_jetty) (2)
	CreateObject(12990,-888.0000000,2077.0000000,56.0000000,0.0000000,0.0000000,0.0000000); //object(sw_jetty) (3)
	CreateObject(2774,-929.0000000,2092.0000000,43.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (13)
	CreateObject(2774,-929.0000000,2108.0000000,43.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (14)
	CreateObject(2774,-806.0000000,2108.0000000,43.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (15)
	CreateObject(2774,-806.0000000,2092.0000000,43.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (16)
	
	// AUSTRALIA BASE
	
	CreateObject(3115,-1030.0000000,2780.0000000,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (25)
	CreateObject(3115,-1009.0000000,2781.8501000,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (26)
	CreateObject(3115,-988.0000000,2783.6999500,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (27)
	CreateObject(3115,-967.0000000,2785.5500500,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (28)
	CreateObject(3115,-946.0000000,2787.3999000,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (29)
	CreateObject(3115,-925.0000000,2789.2500000,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (30)
	CreateObject(3115,-904.0000000,2791.1001000,59.5000000,0.0000000,0.0000000,5.0000000); //object(carrier_lift1_sfse) (31)
	CreateObject(2774,-894.0000000,2784.0000000,46.5000000,0.0000000,0.0000000,5.0000000); //object(cj_airp_pillars) (17)
	CreateObject(2774,-895.0000000,2800.0000000,46.5000000,0.0000000,0.0000000,5.0000000); //object(cj_airp_pillars) (18)
	CreateObject(2774,-1039.0000000,2771.0000000,46.5000000,0.0000000,0.0000000,5.0000000); //object(cj_airp_pillars) (19)
	CreateObject(2774,-1039.0000000,2787.0000000,46.5000000,0.0000000,0.0000000,5.0000000); //object(cj_airp_pillars) (20)
	CreateObject(13749,-887.4000200,2789.0000000,53.0000000,0.0000000,0.0000000,60.0000000); //object(cunte_curvesteps1) (10)
	
	// ARAB BASE
	
	CreateObject(3115,452.0000000,2434.0000000,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (40)
	CreateObject(13749,431.6000100,2516.0000000,22.0000000,0.0000000,0.0000000,324.0000000); //object(cunte_curvesteps1) (14)
	CreateObject(3115,452.0000000,2452.8000500,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (41)
	CreateObject(3115,452.0000000,2471.6001000,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (42)
	CreateObject(3115,452.0000000,2490.3999000,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (43)
	CreateObject(3115,452.0000000,2509.1001000,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (44)
	CreateObject(3115,452.0000000,2527.8999000,28.4500000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (45)
	CreateObject(2774,461.0000000,2426.0000000,15.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (29)
	CreateObject(2774,443.0000000,2426.0000000,15.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (30)
	CreateObject(2774,443.0000000,2536.0000000,15.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (31)
	CreateObject(2774,461.0000000,2536.0000000,15.5000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (32)
	CreateObject(3884,336.0000000,2530.0000000,15.2000000,0.0000000,0.0000000,180.0000000); //object(samsite_sfxrf) (5)
	CreateObject(3884,280.0000000,2530.0000000,15.2000000,0.0000000,0.0000000,180.0000000); //object(samsite_sfxrf) (6)
	CreateObject(2985,301.5000000,2530.0000000,15.8000000,0.0000000,0.0000000,270.0000000); //object(minigun_base) (6)
	CreateObject(2985,314.0000000,2530.0000000,15.8000000,0.0000000,0.0000000,270.0000000); //object(minigun_base) (7)
	
	// Soviet BASE
	
	CreateObject(3115,-360.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (20)
	CreateObject(3115,-339.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (58)
	CreateObject(3115,-318.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (59)
	CreateObject(3115,-297.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (60)
	CreateObject(3115,-276.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (61)
	CreateObject(3115,-255.0000000,1215.0000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (62)
	CreateObject(2774,-369.0000000,1207.0000000,17.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (41)
	CreateObject(2774,-369.0000000,1223.0000000,17.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (42)
	CreateObject(2774,-246.0000000,1207.0000000,17.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (43)
	CreateObject(2774,-246.0000000,1223.0000000,17.0000000,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (44)
	CreateObject(13749,-341.8999900,1199.9000200,23.7000000,0.0000000,0.0000000,324.0000000); //object(cunte_curvesteps1) (11)

	return 1;
}

stock Initialize_Cars()
{
	// USARMY BASE
	CreateVehicle(520,87.0000000,1820.0000000,29.0000000,90.0000000,152,1,15); //Hydra
	CreateVehicle(520,87.0000000,1838.8000500,29.0000000,90.0000000,152,1,15); //Hydra
	CreateVehicle(520,87.0000000,1857.5999800,29.0000000,90.0000000,152,1,15); //Hydra
	CreateVehicle(520,87.0000000,1876.3000500,29.0000000,90.0000000,152,1,15); //Hydra
	CreateVehicle(425,178.0000000,1951.0000000,30.0000000,0.0000000,152,1,15); //Hunter
	CreateVehicle(425,159.3000000,1951.0000000,30.0000000,0.0000000,152,1,15); //Hunter
	CreateVehicle(425,140.5000000,1951.0000000,30.0000000,0.0000000,152,1,15); //Hunter
	CreateVehicle(425,121.8000000,1951.0000000,30.0000000,0.0000000,152,1,15); //Hunter
	CreateVehicle(425,103.1000000,1951.0000000,30.0000000,0.0000000,152,1,15); //Hunter
	CreateVehicle(447,252.1000100,1789.0000000,28.0000000,180.0000000,152,1,15); //Seasparrow
	CreateVehicle(447,233.3999900,1789.0000000,28.0000000,180.0000000,152,1,15); //Seasparrow
	CreateVehicle(487,214.7000000,1789.0000000,28.0000000,180.0000000,152,1,15); //Maverick
	CreateVehicle(487,196.0000000,1789.0000000,28.0000000,180.0000000,152,1,15); //Maverick
	CreateVehicle(563,177.2000000,1789.0000000,28.0000000,180.0000000,152,1,15); //Raindance
	CreateVehicle(563,158.3999900,1789.0000000,28.0000000,180.0000000,152,1,15); //Raindance
	CreateVehicle(548,139.7000000,1789.0000000,30.0000000,180.0000000,152,1,15); //Cargobob
	CreateVehicle(431,285.0000000,1798.0000000,17.9000000,270.0000000,152,1,15); //Bus
	CreateVehicle(437,285.0000000,1793.0000000,17.9000000,270.0000000,152,1,15); //Coach
	CreateVehicle(514,285.0000000,1787.0000000,18.3000000,270.0000000,152,1,15); //Tanker
	CreateVehicle(432,370.0000000,1985.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(432,370.0000000,1975.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(432,370.0000000,1950.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(432,370.0000000,1940.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(432,370.0000000,1915.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(432,370.0000000,1905.0000000,17.7000000,90.0000000,152,1,15); //Rhino
	CreateVehicle(444,291.0000000,1812.0000000,18.0000000,270.0000000,152,1,15); //Monster
	CreateVehicle(444,291.0000000,1805.0000000,18.0000000,270.0000000,152,1,15); //Monster
	CreateVehicle(522,224.0000000,1920.0000000,17.3000000,180.0000000,152,1,15); //NRG-500
	CreateVehicle(522,220.0000000,1920.0000000,17.3000000,180.0000000,152,1,15); //NRG-500
	CreateVehicle(522,216.0000000,1920.0000000,17.3000000,180.0000000,152,1,15); //NRG-500
	CreateVehicle(468,212.0000000,1920.0000000,17.4000000,180.0000000,152,1,15); //Sanchez
	CreateVehicle(468,208.0000000,1920.0000000,17.4000000,180.0000000,152,1,15); //Sanchez
	CreateVehicle(468,204.0000000,1920.0000000,17.4000000,180.0000000,152,1,15); //Sanchez
	CreateVehicle(471,200.0000000,1920.0000000,17.2000000,180.0000000,152,1,15); //Quad
	CreateVehicle(471,196.0000000,1920.0000000,17.2000000,180.0000000,152,1,15); //Quad
	CreateVehicle(471,192.0000000,1920.0000000,17.2000000,180.0000000,152,1,15); //Quad
	CreateVehicle(451,115.0000000,1864.0000000,17.5000000,270.0000000,152,1,15); //Turismo
	CreateVehicle(415,115.0000000,1860.0000000,17.6000000,270.0000000,152,1,15); //Cheetah
	CreateVehicle(411,115.0000000,1856.0000000,17.5000000,270.0000000,152,1,15); //Infernus
	CreateVehicle(541,115.0000000,1852.0000000,17.4000000,270.0000000,152,1,15); //Bullet
	CreateVehicle(433,132.0000000,1834.0000000,18.2000000,90.0000000,152,1,15); //Barracks
	CreateVehicle(433,132.0000000,1840.0000000,18.2000000,90.0000000,152,1,15); //Barracks
	CreateVehicle(470,132.0000000,1846.0000000,17.8000000,90.0000000,152,1,15); //Patriot
	CreateVehicle(470,132.0000000,1851.0000000,17.8000000,90.0000000,152,1,15); //Patriot
	CreateVehicle(470,132.0000000,1856.0000000,17.8000000,90.0000000,152,1,15); //Patriot
	CreateVehicle(601,122.0000000,1818.0000000,17.6000000,0.0000000,152,1,15); //S.W.A.T. Van
	CreateVehicle(476,277.0000000,1949.0000000,20.0000000,318.0000000,152,1,15); //Rustler
	CreateVehicle(476,277.0000000,1963.0000000,20.0000000,230.0000000,152,1,15); //Rustler
	CreateVehicle(476,277.0000000,1982.5999800,20.0000000,318.0000000,152,1,15); //Rustler
	CreateVehicle(476,277.0000000,2017.0000000,20.0000000,318.0000000,152,1,15); //Rustler
	CreateVehicle(476,277.0000000,2031.0000000,20.0000000,230.0000000,152,1,15); //Rustler
	CreateVehicle(476,277.0000000,1997.4000200,20.0000000,230.0000000,152,1,15); //Rustler
	CreateVehicle(476,300.0000000,2049.0000000,20.0000000,212.0000000,152,1,15); //Rustler
	CreateVehicle(476,312.7000100,2049.0000000,20.0000000,166.0000000,152,1,15); //Rustler
	CreateVehicle(548,121.0000000,1789.0000000,30.0000000,180.0000000,152,1,15); //Cargobob

 	// EURASIA BASE
	CreateVehicle(520,-920.0000000,2100.0000000,58.0000000,0.0000000,201,1,15); //Hydra
	CreateVehicle(425,-899.0000000,2100.0000000,58.0000000,0.0000000,201,1,15); //Hunter
	CreateVehicle(447,-878.0000000,2100.0000000,57.2000000,0.0000000,201,1,15); //Seasparrow
	CreateVehicle(447,-857.0000000,2100.0000000,57.2000000,0.0000000,201,1,15); //Seasparrow
	CreateVehicle(487,-836.0000000,2100.0000000,57.4000000,0.0000000,201,1,15); //Maverick
	CreateVehicle(487,-815.0000000,2100.0000000,57.4000000,0.0000000,201,1,15); //Maverick
	CreateVehicle(493,-825.0000000,2100.0000000,43.0000000,0.0000000,201,1,15); //Jetmax
	CreateVehicle(452,-835.0000000,2100.0000000,43.0000000,0.0000000,201,1,15); //Speeder
	CreateVehicle(446,-845.0000000,2100.0000000,43.0000000,0.0000000,201,1,15); //Squalo
	CreateVehicle(473,-855.0000000,2100.0000000,43.0000000,0.0000000,201,1,15); //Dinghy
	CreateVehicle(473,-865.0000000,2100.0000000,43.0000000,0.0000000,201,1,15); //Dinghy
	CreateVehicle(432,-903.0000000,1985.0000000,61.0000000,315.0000000,201,1,15); //Rhino
	CreateVehicle(432,-908.0000000,1990.0000000,61.0000000,315.0000000,201,1,15); //Rhino
	CreateVehicle(433,-911.5999800,1995.5999800,61.5000000,311.0000000,201,1,15); //Barracks
	CreateVehicle(433,-916.0000000,2000.5999800,61.5000000,311.0000000,201,1,15); //Barracks
	CreateVehicle(470,-921.4000200,2004.5999800,61.0000000,311.0000000,201,1,15); //Patriot
	CreateVehicle(470,-923.5999800,2007.3000500,61.0000000,311.0000000,201,1,15); //Patriot
	CreateVehicle(470,-925.7999900,2010.0999800,61.0000000,311.0000000,201,1,15); //Patriot
	CreateVehicle(522,-929.0000000,2015.0000000,60.6000000,315.0000000,201,1,15); //NRG-500
	CreateVehicle(522,-930.0999800,2016.1999500,60.6000000,315.0000000,201,1,15); //NRG-500
	CreateVehicle(468,-933.2999900,2020.1999500,60.7000000,315.0000000,201,1,15); //Sanchez
	CreateVehicle(468,-934.4000200,2021.5000000,60.7000000,315.0000000,201,1,15); //Sanchez
	CreateVehicle(471,-937.2999900,2025.8000500,60.5000000,315.0000000,201,1,15); //Quad
	CreateVehicle(471,-938.5999800,2027.0000000,60.5000000,315.0000000,201,1,15); //Quad
	CreateVehicle(444,-927.5999800,2040.5000000,62.0000000,134.0000000,201,1,15); //Monster
	CreateVehicle(451,-922.9000200,2035.9000200,60.7000000,134.0000000,201,1,15); //Turismo
	CreateVehicle(415,-918.0999800,2030.9000200,60.8000000,134.0000000,201,1,15); //Cheetah
	CreateVehicle(411,-913.5999800,2025.5999800,60.7000000,134.0000000,201,1,15); //Infernus
	CreateVehicle(402,-909.2000100,2020.3000500,60.9000000,134.0000000,201,1,15); //Buffalo
	CreateVehicle(407,-905.4000200,2014.4000200,61.3000000,134.0000000,201,1,15); //Firetruck
	CreateVehicle(406,-898.5999800,2006.0000000,63.0000000,220.0000000,201,1,15); //Dumper

	// AUSTRALIA BASE
	CreateVehicle(520,-1030.0000000,2780.0000000,61.7000000,185.0000000,147,1,15); //Hydra
	CreateVehicle(425,-1009.0000000,2781.8501000,61.7000000,185.0000000,147,1,15); //Hunter
	CreateVehicle(425,-988.0000000,2783.5000000,61.7000000,185.0000000,147,1,15); //Hunter
	CreateVehicle(447,-967.0000000,2785.5500500,60.9000000,185.0000000,147,1,15); //Seasparrow
	CreateVehicle(447,-946.0000000,2787.3999000,60.9000000,185.0000000,147,1,15); //Seasparrow
	CreateVehicle(487,-925.0000000,2789.2500000,61.1000000,185.0000000,147,1,15); //Maverick
	CreateVehicle(487,-904.0000000,2791.1001000,61.1000000,185.0000000,147,1,15); //Maverick
	CreateVehicle(432,-892.0000000,2756.0000000,46.1000000,185.0000000,147,1,15); //Rhino
	CreateVehicle(432,-900.0000000,2755.0000000,46.2000000,185.0000000,147,1,15); //Rhino
	CreateVehicle(433,-961.5999800,2750.1001000,46.8000000,185.0000000,147,1,15); //Barracks
	CreateVehicle(433,-954.7000100,2750.5000000,46.8000000,185.0000000,147,1,15); //Barracks
	CreateVehicle(433,-946.9000200,2750.8999000,46.8000000,185.0000000,147,1,15); //Barracks
	CreateVehicle(470,-970.7000100,2729.8000500,46.0000000,275.0000000,147,1,15); //Patriot
	CreateVehicle(470,-971.0999800,2734.0000000,46.0000000,275.0000000,147,1,15); //Patriot
	CreateVehicle(470,-971.2999900,2738.6001000,46.0000000,275.0000000,147,1,15); //Patriot
	CreateVehicle(451,-874.0000000,2789.1001000,46.8000000,185.0000000,147,1,15); //Turismo
	CreateVehicle(415,-869.4000200,2789.6999500,46.9000000,185.0000000,147,1,15); //Cheetah
	CreateVehicle(402,-864.5999800,2790.3000500,46.8000000,185.0000000,147,1,15); //Buffalo
	CreateVehicle(411,-860.0000000,2791.0000000,46.4000000,185.0000000,147,1,15); //Infernus
	CreateVehicle(541,-855.0999800,2791.1001000,46.1000000,185.0000000,147,1,15); //Bullet
	CreateVehicle(522,-850.7999900,2790.5000000,46.0000000,185.0000000,147,1,15); //NRG-500
	CreateVehicle(522,-848.7000100,2790.6999500,46.0000000,185.0000000,147,1,15); //NRG-500
	CreateVehicle(468,-846.5999800,2791.1001000,46.0000000,185.0000000,147,1,15); //Sanchez
	CreateVehicle(468,-845.0000000,2791.3000500,46.0000000,185.0000000,147,1,15); //Sanchez
	CreateVehicle(471,-842.4000200,2791.3999000,45.7000000,185.0000000,147,1,15); //Quad
	CreateVehicle(471,-840.4000200,2791.6001000,45.7000000,185.0000000,147,1,15); //Quad
	CreateVehicle(444,-832.5999800,2783.3999000,47.0000000,91.0000000,147,1,15); //Monster
	CreateVehicle(444,-832.5999800,2776.3999000,47.0000000,91.0000000,147,1,15); //Monster
	CreateVehicle(493,-927.0999800,2663.0000000,44.0000000,132.0000000,147,1,15); //Jetmax
	CreateVehicle(493,-919.0000000,2656.0000000,44.0000000,132.0000000,147,1,15); //Jetmax
	CreateVehicle(431,-931.2000100,2753.5000000,46.5000000,185.0000000,147,1,15); //Bus
	CreateVehicle(437,-925.4000200,2753.6001000,46.5000000,185.0000000,147,1,15); //Coach

	// ARAB BASE
	CreateVehicle(520,452.0000000,2434.0000000,30.7000000,90.0000000,183,1,15); //Hydra
	CreateVehicle(425,452.0000000,2452.8000500,30.6000000,90.0000000,183,1,15); //Hunter
	CreateVehicle(447,452.0000000,2471.6001000,29.9000000,90.0000000,183,1,15); //Seasparrow
	CreateVehicle(447,452.0000000,2490.3999000,29.9000000,90.0000000,183,1,15); //Seasparrow
	CreateVehicle(487,452.0000000,2509.1001000,30.0000000,90.0000000,183,1,15); //Maverick
	CreateVehicle(487,452.0000000,2527.8999000,30.0000000,90.0000000,183,1,15); //Maverick
	CreateVehicle(476,270.0000000,2476.0000000,17.7000000,30.0000000,183,1,15); //Rustler
	CreateVehicle(476,250.0000000,2476.0000000,17.7000000,30.0000000,183,1,15); //Rustler
	CreateVehicle(476,230.0000000,2476.0000000,17.7000000,30.0000000,183,1,15); //Rustler
	CreateVehicle(476,270.0000000,2530.0000000,18.0000000,150.0000000,183,1,15); //Rustler
	CreateVehicle(476,250.0000000,2530.0000000,18.0000000,150.0000000,183,1,15); //Rustler
	CreateVehicle(476,230.0000000,2530.0000000,18.0000000,150.0000000,183,1,15); //Rustler
	CreateVehicle(433,425.0000000,2484.0000000,17.1000000,90.0000000,183,1,15); //Barracks
	CreateVehicle(433,425.0000000,2490.0000000,17.1000000,90.0000000,183,1,15); //Barracks
	CreateVehicle(470,425.0000000,2496.0000000,16.6000000,90.0000000,183,1,15); //Patriot
	CreateVehicle(470,425.0000000,2501.0000000,16.6000000,90.0000000,183,1,15); //Patriot
	CreateVehicle(470,425.0000000,2506.0000000,16.6000000,90.0000000,183,1,15); //Patriot
	CreateVehicle(432,390.0000000,2535.0000000,16.6000000,180.0000000,183,1,15); //Rhino
	CreateVehicle(432,382.0000000,2535.0000000,16.6000000,180.0000000,183,1,15); //Rhino
	CreateVehicle(444,380.0000000,2481.0000000,17.0000000,0.0000000,183,1,15); //Monster
	CreateVehicle(444,386.0000000,2481.0000000,17.0000000,0.0000000,183,1,15); //Monster
	CreateVehicle(451,340.0000000,2544.0000000,16.5000000,180.0000000,183,1,15); //Turismo
	CreateVehicle(429,344.0000000,2544.0000000,16.5000000,180.0000000,183,1,15); //Banshee
	CreateVehicle(415,348.0000000,2544.0000000,16.6000000,180.0000000,183,1,15); //Cheetah
	CreateVehicle(411,352.0000000,2544.0000000,16.5000000,180.0000000,183,1,15); //Infernus
	CreateVehicle(402,356.0000000,2544.0000000,16.6000000,180.0000000,183,1,15); //Buffalo
	CreateVehicle(522,361.0000000,2544.0000000,16.3000000,180.0000000,183,1,15); //NRG-500
	CreateVehicle(522,363.0000000,2544.0000000,16.3000000,180.0000000,183,1,15); //NRG-500
	CreateVehicle(468,366.0000000,2544.0000000,16.3000000,180.0000000,183,1,15); //Sanchez
	CreateVehicle(468,368.0000000,2544.0000000,16.3000000,180.0000000,183,1,15); //Sanchez
	CreateVehicle(471,371.0000000,2544.0000000,16.1000000,180.0000000,183,1,15); //Quad
	CreateVehicle(471,374.0000000,2544.0000000,16.1000000,180.0000000,183,1,15); //Quad
	CreateVehicle(431,372.0000000,2471.0000000,16.7000000,0.0000000,183,1,15); //Bus
	CreateVehicle(437,366.0000000,2471.0000000,16.7000000,0.0000000,183,1,15); //Coach
	CreateVehicle(513,290.0000000,2540.0000000,17.6000000,180.0000000,183,1,15); //Stunt
	CreateVehicle(593,325.0000000,2540.0000000,17.4000000,180.0000000,183,1,15); //Dodo
	
    // Soviet BASE
	CreateVehicle(520,-360.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Hydra
	CreateVehicle(425,-339.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Hunter
	CreateVehicle(447,-318.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Seasparrow
	CreateVehicle(447,-297.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Seasparrow
	CreateVehicle(487,-276.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Maverick
	CreateVehicle(487,-255.0000000,1215.0000000,34.0000000,0.0000000,175,1,15); //Maverick
	CreateVehicle(432,-269.0000000,1215.0000000,19.8000000,180.0000000,175,1,15); //Rhino
	CreateVehicle(432,-276.0000000,1215.0000000,19.8000000,180.0000000,175,1,15); //Rhino
	CreateVehicle(433,-286.0000000,1215.0000000,20.3000000,180.0000000,175,1,15); //Barracks
	CreateVehicle(433,-291.0000000,1215.0000000,20.3000000,180.0000000,175,1,15); //Barracks
	CreateVehicle(470,-296.0000000,1215.0000000,19.9000000,180.0000000,175,1,15); //Patriot
	CreateVehicle(470,-300.0000000,1215.0000000,19.9000000,180.0000000,175,1,15); //Patriot
	CreateVehicle(470,-304.0000000,1215.0000000,19.9000000,180.0000000,175,1,15); //Patriot
	CreateVehicle(451,-342.0000000,1187.0000000,19.5000000,0.0000000,175,1,15); //Turismo
	CreateVehicle(429,-338.0000000,1187.0000000,19.5000000,0.0000000,175,1,15); //Banshee
	CreateVehicle(415,-334.0000000,1187.0000000,19.6000000,0.0000000,175,1,15); //Cheetah
	CreateVehicle(411,-330.0000000,1187.0000000,19.5000000,0.0000000,175,1,15); //Infernus
	CreateVehicle(402,-326.0000000,1187.0000000,19.7000000,0.0000000,175,1,15); //Buffalo
	CreateVehicle(522,-288.0000000,1186.0000000,19.4000000,0.0000000,175,1,15); //NRG-500
	CreateVehicle(522,-290.0000000,1186.0000000,19.4000000,0.0000000,175,1,15); //NRG-500
	CreateVehicle(468,-292.0000000,1186.0000000,19.5000000,0.0000000,175,1,15); //Sanchez
	CreateVehicle(468,-294.0000000,1186.0999800,19.5000000,0.0000000,175,1,15); //Sanchez
	CreateVehicle(471,-296.0000000,1186.0000000,19.3000000,0.0000000,175,1,15); //Quad
	CreateVehicle(471,-298.0000000,1186.0000000,19.3000000,0.0000000,175,1,15); //Quad
	CreateVehicle(444,-348.0000000,1178.0000000,21.0000000,90.0000000,175,1,15); //Monster
	CreateVehicle(444,-348.0000000,1172.0000000,21.0000000,90.0000000,175,1,15); //Monster
	CreateVehicle(431,-339.5000000,1170.0000000,20.0000000,180.0000000,175,1,15); //Bus
	CreateVehicle(437,-297.2999900,1162.5999800,20.0000000,270.0000000,175,1,15); //Coach
	CreateVehicle(406,-314.7000100,1175.5000000,22.0000000,0.0000000,175,1,15); //Dumper
	print("Initializing Team's Vehicle...");
	return 1;
}

stock SendTeamChat(teamid, color, string[])
{
	foreach(new i : Player)
	{
	    if(gTeam[i] == teamid)
	    {
	        SendClientMessage(i, color, string);
	    }
	}
}

stock Initialize_Gangzone()
{
	print("Initializing GaneZone turfs...");

	GZ_USA = GangZoneCreate(-70.06725, 1669.936, 373.692, 2160.407);
	GZ_EURASIA = GangZoneCreate(-969.2637, 1985.239, -817.4513, 2125.373);
	GZ_AUSTRALIA = GangZoneCreate(-1121.076, 2720.945, -502.1487, 2896.113);
	GZ_ARAB = GangZoneCreate(70.06725, 2358.931, 490.4708, 2685.911);
	GZ_SOVIET = GangZoneCreate(-402.34375,1101.5625,-273.4375,1218.75);
	return 1;
}

stock Initialize_Timer()
{
	SetTimer("ForPlayer", 1000, true);
	SetTimer("SpecialZone", 1000*60*5, true);
	SetTimer("PlaceFlag", 1000*60*6, true);
	print("Initializing Global Server Timers...");
	return 1;
}

stock ChatLog(playerid, text[])
{
	new
	 File:lFile = fopen("chatlogs.txt", io_append),
	 logData[178],
		fyear, fmonth, fday,
		fhour, fminute, fsecond;

 	getdate(fyear, fmonth, fday);
	gettime(fhour, fminute, fsecond);

	format(logData, sizeof(logData),"[%02d/%02d/%04d %02d:%02d:%02d] %s: %s \r\n", fday, fmonth, fyear, fhour, fminute, fsecond, GetName(playerid), text);
	fwrite(lFile, logData);

	fclose(lFile);
	return 1;
}

Initialize_Disables()
{
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
   	print("Intializing Disables...");
    return 1;
}

stock Initialize_Labels()
{
	// US
	CreateDynamic3DTextLabel("Place your stolen flags here! (/placeflag)", -1, 214.3562, 1860.3756, 13.1406, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	// Arab
	CreateDynamic3DTextLabel("Place your stolen flags here! (/placeflag)", -1, 415.4375, 2532.1145, 16.5871, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	//Eurasia
	CreateDynamic3DTextLabel("Place your stolen flags here! (/placeflag)", -1, -933.7457, 2033.5874, 60.9205, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	//Australia
	CreateDynamic3DTextLabel("Place your stolen flags here! (/placeflag)", -1, -842.6653, 2751.7773, 45.8516, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	//Soviet
	CreateDynamic3DTextLabel("Place your stolen flags here! (/placeflag)", -1, -369.5273, 1184.1678, 19.7422, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	
	print("Intializing 3DText Labels...");
	return 1;
}

stock IsAtFlag(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 214.3562, 1860.3756, 13.1406)) // USA
	{
	    return 1;
	}
 	else if(IsPlayerInRangeOfPoint(playerid, 3.0, 415.4375, 2532.1145, 16.5871)) // Arab
 	{
 	    return 2;
 	}
	return 0;
}

stock CreateZone(id, string[], Float:cp_x, Float:cp_y, Float:cp_z, Float:cp_size, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	if(zInfo[id][Taken] == true)
	{
	    return 0;
	}

	format(zInfo[id][ZoneName], 128, "%s", string);
	new string2[128];
	format(string2, sizeof(string2), "%s (%d)\nCapturable Zone", string, id);
	zInfo[id][zLabel] = CreateDynamic3DTextLabel(string2, -1, cp_x, cp_y, cp_z, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 40.0);
	zInfo[id][CP] = CreateDynamicCP(cp_x, cp_y, cp_z, cp_size);
	zInfo[id][Zone] = GangZoneCreate(minx, miny, maxx, maxy);
	zInfo[id][UnderAttack] = -1;
	zInfo[id][Captured] = -1;
	zInfo[id][tCP] = NONE;
	zInfo[id][Taken] = true;
	zInfo[id][zSpecial] = false;
	zInfo[id][zAttacker] = INVALID_PLAYER_ID;
	zInfo[id][zMap] = CreateDynamicMapIcon(cp_x, cp_y, cp_z, 19, -1, -1, -1, -1, 500.0);
	CountVar[id] = 25;
	return 1;
}

stock DestroyZone(id)
{
	if(zInfo[id][Taken] == false)
	{
	    return 0;
	}
	
	format(zInfo[id][ZoneName], 128, "N-A");
	DestroyDynamicCP(zInfo[id][CP]);
	DestroyDynamic3DTextLabel(zInfo[id][zLabel]);
	zInfo[id][zSpecial] = false;
	GangZoneDestroy(zInfo[id][Zone]);
	zInfo[id][UnderAttack] = -1;
	zInfo[id][Captured] = -1;
	zInfo[id][tCP] = NONE;
	zInfo[id][zAttacker] = INVALID_PLAYER_ID;
	zInfo[id][Taken] = false;
	CountVar[id] = 25;
	DestroyDynamicMapIcon(zInfo[id][zMap]);
	return 1;
}

stock CreateFlag(id, teamid, Float:flag_x, Float:flag_y, Float:flag_z)
{
	if(fInfo[id][fTaken] == true)
	{
	    return 0;
	}

	new string[128];
	format(string, sizeof(string), "%s (%d) 's flag\nPick it up and bring it to your team base!", GetTeamEx(teamid), teamid);
	fInfo[id][fLabel] = CreateDynamic3DTextLabel(string, -1, flag_x, flag_y, flag_z, 60.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 60.0);
	fInfo[id][fMap] = CreateDynamicMapIcon(flag_x, flag_y, flag_z, 0, GetZoneColor(teamid), -1, -1, -1, 500.0);
	fInfo[id][flagPickup] = CreateDynamicPickup(2914, 1, flag_x, flag_y, flag_z, -1, -1, -1, 60.0);
	fInfo[id][HasIt] = INVALID_PLAYER_ID;
	fInfo[id][TeamID] = teamid;
	fInfo[id][fTaken] = true;
	fInfo[id][flag_Pos][0] = flag_x, fInfo[id][flag_Pos][1] = flag_y, fInfo[id][flag_Pos][2] = flag_z;
	return 1;
}

stock DestroyFlag(id)
{
	if(fInfo[id][fTaken] == false)
	{
	    return 0;
	}
	DestroyDynamic3DTextLabel(fInfo[id][fLabel]);
	DestroyDynamicMapIcon(fInfo[id][fMap]);
	DestroyDynamicPickup(fInfo[id][flagPickup]);
	fInfo[id][HasIt] = INVALID_PLAYER_ID;
	fInfo[id][TeamID] = NONE;
	fInfo[id][fTaken] = false;
	return 1;
}

stock Initialize_WarField()
{
	CreateZone(SnakeFarm, "Snake Farm", -37.4375, 2346.6733, 24.1406, 3.0, -80.0781250000005, 2281.25, 23.4375, 2408.203125);
	CreateZone(CiaHeadquarters, "CIA Headquarters", -551.1266, 2593.3501, 53.9348, 3.0, -636.71875, 2527.34375, -496.09375, 2658.203125);
	CreateZone(PetrolStation, "Petrol Station (Desert)", -1318.2217, 2694.1321, 50.0625, 3.0, -1390.625, 2630.859375, -1236.328125, 2738.28125);
	CreateZone(BaitShop, "Bait Shop", -1350.1863, 2057.0811, 52.6337, 3.0, -1400.390625, 2023.4375, -1298.828125, 2099.609375);
	CreateZone(CluckinBell, "Cluckin' Bell (Desert)", -1212.6385, 1824.0710, 41.7188, 3.0, -1259.765625, 1767.578125, -1140.625, 1867.1875);
	CreateZone(Ranch, "Ranch", -310.7553, 1767.5319, 43.6406, 3.0, -376.953125, 1714.84375, -240.234375, 1832.03125);
	CreateZone(RadarBase, "Big Ear", -350.0478, 1570.0309, 75.9279, 3.0, -432.0814, 1459.734, -233.5575, 1634.903);
	CreateZone(OilDepot, "Oil Industry", 220.8755, 1422.7489, 10.5859, 3.0, 95.703125, 1341.796875, 283.203125, 1486.328125);
	CreateZone(Quarry, "Hunter Quarry", 596.3820, 870.3969, -43.1531, 3.0, 478.515625, 804.6875, 773.4375, 947.265625);
	CreateZone(TheBigSpreadRanch, "The Big Spread Ranch", 694.6575, 1945.5857, 5.5391, 3.0, 638.671875, 1904.296875, 759.765625, 2013.671875);

	print("Initializing WarField turfs...");
	return 1;
}

stock SetPlayerSpawn(playerid)
{
	SetCameraBehindPlayer(playerid);

	switch(gTeam[playerid])
	{
		case TEAM_USA:
		{
			new x = random(3);
			
			switch(x)
			{
			    case 0: SetPlayerPos(playerid, 214.0399,1860.9777,13.1406), SetPlayerFacingAngle(playerid, 0.0099), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			    case 1: SetPlayerPos(playerid, 172.9609,1844.7208,17.6406), SetPlayerFacingAngle(playerid, 94.6375), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			    case 2: SetPlayerPos(playerid, 279.8692,1972.9128,17.6406), SetPlayerFacingAngle(playerid, 90.8774), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case TEAM_EURASIA:
		{
			SetPlayerPos(playerid, -934.7462,2031.8127,60.9205);
			SetPlayerFacingAngle(playerid, 222.7920);
		}
		case TEAM_AUSTRALIA:
		{
			new x = random(2);

			switch(x)
			{
			    case 0: SetPlayerPos(playerid, -828.9584,2770.0325,46.0000), SetPlayerFacingAngle(playerid, 92.7576), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			    case 1: SetPlayerPos(playerid, -902.2765,2687.3130,42.3703), SetPlayerFacingAngle(playerid, 41.9970), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case TEAM_ARAB:
		{
			new x = random(2);

			switch(x)
			{
			    case 0: SetPlayerPos(playerid, 413.2424,2534.1440,19.1484), SetPlayerFacingAngle(playerid, 86.8041), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			    case 1: SetPlayerPos(playerid, 308.7215,2543.4314,16.8158), SetPlayerFacingAngle(playerid, 176.4416), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case TEAM_SOVIET:
		{
			new x = random(2);

			switch(x)
			{
			    case 0: SetPlayerPos(playerid, -367.5388,1188.3090,19.7422), SetPlayerFacingAngle(playerid, 266.0325), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			    case 1: SetPlayerPos(playerid, -301.5997,1180.7157,20.2422), SetPlayerFacingAngle(playerid, 0.9734), SetPlayerInterior(playerid, 0), SetPlayerVirtualWorld(playerid, 0);
			}
		}
	}
}

stock SendAdminMessage(color, string[])
{
	foreach(new i : Player)
	{
	    if(LoggedIn[i] == 1)
	    {
	        if(pInfo[i][Admin] >= 1)
	        {
	            SendClientMessage(i, color, string);
	        }
	    }
	}
}

stock KickDelay(playerid)
{
	return SetTimerEx("KickMe", 1000, false, "d", playerid);
}

stock DB_Escape(text[])
{
    new
        ret[80 * 2],
        ch,
        i,
        j
	;
    while ((ch = text[i++]) && j < sizeof (ret))
    {
        if (ch == '\'')
        {
            if (j < sizeof (ret) - 2)
            {
                ret[j++] = '\'';
                ret[j++] = '\'';
            }
        }
        else if (j < sizeof (ret))
        {
            ret[j++] = ch;
        }
        else
        {
            j++;
        }
    }
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}
stock GetName(playerid)
{
	new pnameid[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pnameid, MAX_PLAYER_NAME);
	return pnameid;
}
stock PlayerIP(playerid)
{
	new str[16];
	GetPlayerIp(playerid, str, sizeof(str));
	return str;
}

stock BanWithReason(playerid = INVALID_PLAYER_ID, targetid, reason[])
{
	new Query[240], string[112], DBResult:result, day, month, year, second, minute, hour, datestring[24], timestring[24];
	getdate(day, month, year);
	gettime(hour, minute, second);

	format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year);
	format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

	if(playerid != INVALID_PLAYER_ID)
	{
		format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", DB_Escape(GetName(targetid)), DB_Escape(PlayerIP(targetid)), reason, DB_Escape(GetName(playerid)), datestring, timestring);
		result = db_query(bans, Query);
		if(result)
		{
			format(string, sizeof(string), "SERVER: %s (%d) has been banned by %s (%d), reason: %s", GetName(targetid), targetid, GetName(playerid), playerid, reason);
			SendClientMessageToAll(COLOR_RED, string), string = "\0";
			printf("[ban] [%s]: successfully added %s's ban info", GetName(playerid), GetName(targetid));
		}
		else
		{
		    format(string, sizeof(string), "SERVER: Server failed to ban '%s'", GetName(targetid));
			SendClientMessageToAll(-1, string), string = "\0";
			printf("[ban] [%s]: failed to add %s's ban info", GetName(playerid), GetName(targetid));
		}
	}
	Query = "\0", db_free_result(result);
	SetTimerEx("KickTimer", 100, false, "i", targetid);
}



stock GetRank(playerid)
{
	new rank[100];
	switch(pInfo[playerid][Rank])
	{
	    case 0: rank = "Private";
	    case 1: rank = "Corporal";
	    case 2: rank = "Lieutenant";
	    case 3: rank = "Major";
	    case 4: rank = "Captain";
	    case 5: rank = "Commander";
	    case 6: rank = "General";
	    case 7: rank = "Brigadier";
	    case 8: rank = "Field Marshall";
	    case 9: rank = "Master of the War";
	    case 10: rank = "General of the Army";
	    case 11: rank = "Prestige I";
	    case 12: rank = "Prestige II";
	}
	return rank;
}

stock RankUp(playerid)
{
    new string[128];

    if(GetPlayerScore(playerid) >= 50 && GetPlayerScore(playerid) < 100 && pInfo[playerid][Rank] < 1)
    {
        pInfo[playerid][Rank] = 1;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a 10 score+, 5000$ and an armoury.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 10);
        GivePlayerMoney(playerid, 5000);
        SetPlayerArmour(playerid, 100);
    }
    else if(GetPlayerScore(playerid) >= 100 && GetPlayerScore(playerid) < 300 && pInfo[playerid][Rank] < 2)
    {
        pInfo[playerid][Rank] = 2;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a 5 score+, 3500$ and a M4 package.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 5);
        GivePlayerMoney(playerid, 3500);
        GivePlayerWeapon(playerid, 31, 1000);
    }
    else if(GetPlayerScore(playerid) >= 300 && GetPlayerScore(playerid) < 500 && pInfo[playerid][Rank] < 3)
    {
        pInfo[playerid][Rank] = 3;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a boosting score of 30+.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 30);
    }
    else if(GetPlayerScore(playerid) >= 500 && GetPlayerScore(playerid) < 1000 && pInfo[playerid][Rank] < 4)
    {
        pInfo[playerid][Rank] = 4;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a cash of $30,000 and a score boost of 20.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 20);
        GivePlayerMoney(playerid, 30000);
    }
    else if(GetPlayerScore(playerid) >= 1000 && GetPlayerScore(playerid) < 1500 && pInfo[playerid][Rank] < 5)
    {
        pInfo[playerid][Rank] = 5;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a boosting score of 30+.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 30);
    }
    else if(GetPlayerScore(playerid) >= 1500 && GetPlayerScore(playerid) < 2500 && pInfo[playerid][Rank] < 6)
    {
        pInfo[playerid][Rank] = 6;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a boosting score of 20+, $10000 - A weapon package (Set A).", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 20);
        GivePlayerMoney(playerid, 10000);

        GivePlayerWeapon(playerid, 31, 1000);
        GivePlayerWeapon(playerid, 29, 1000);
    }
    else if(GetPlayerScore(playerid) >= 2500 && GetPlayerScore(playerid) < 4500 && pInfo[playerid][Rank] < 7)
    {
        pInfo[playerid][Rank] = 7;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a cash of $5000.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        GivePlayerMoney(playerid, 5000);
    }
    else if(GetPlayerScore(playerid) >= 4500 && GetPlayerScore(playerid) < 6000 && pInfo[playerid][Rank] < 8)
    {
        pInfo[playerid][Rank] = 8;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a weapon package (Set B).", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        GivePlayerWeapon(playerid, 30, 1000);
        GivePlayerWeapon(playerid, 32, 1000);
    }
    else if(GetPlayerScore(playerid) >= 6000 && GetPlayerScore(playerid) < 7500)
    {
        pInfo[playerid][Rank] = 9;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received nothing.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);
    }
    else if(GetPlayerScore(playerid) >= 6000 && GetPlayerScore(playerid) < 7500 && pInfo[playerid][Rank] < 9)
    {
        pInfo[playerid][Rank] = 10;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a boosting score of 350.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 350);
    }
    else if(GetPlayerScore(playerid) >= 7500 && GetPlayerScore(playerid) < 10000 && pInfo[playerid][Rank] < 10)
    {
        pInfo[playerid][Rank] = 11;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a cash of $50,000 + boosting score of 250.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 250);
        GivePlayerMoney(playerid, 50000);
    }
    else if(GetPlayerScore(playerid) >= 10000 && GetPlayerScore(playerid) < 13500 && pInfo[playerid][Rank] < 11)
    {
        pInfo[playerid][Rank] = 12;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a boosting score of 1000.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        SetPlayerScore(playerid, GetPlayerScore(playerid) + 1000);
    }
    else if(GetPlayerScore(playerid) >= 15000 && pInfo[playerid][Rank] < 12)
    {
        pInfo[playerid][Rank] = 13;

        format(string, sizeof(string), "You have rank up to %s (%d) - Congratulations, You received a cash of $2,500,000", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_LIME, string);
        format(string, sizeof(string), "Warning:{FFFFFF} Remember that this is the last rank in the server and you will be no longer ranking up.", GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessage(playerid, COLOR_YELLOW, string);
        format(string, sizeof(string), "* %s has ranked up to %s (%d).", nameEx(playerid), GetRank(playerid), pInfo[playerid][Rank]);
        SendClientMessageToAll(COLOR_YELLOW, string);

        GivePlayerMoney(playerid, 2500000);
    }
    new string2[128]; format(string2, sizeof(string2), "%s", GetRank(playerid));
    UpdateDynamic3DTextLabelText(Label[playerid], GetPlayerColor(playerid), string2);
}

stock IsPlayerInInvalidNosVehicle( playerid )
{
	switch(GetVehicleModel(GetPlayerVehicleID(playerid))) {
		case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449: return 1;
	}
	return 0;
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////// Commands ////////////////////////////////////

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success) SendClientMessage(playerid, COLOR_RED, "Error:{FFFFFF} Unknown command, Type /cmds or /help for more informations.");
	return 1;
}

// Player Commands

CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, ""col_lb"Help", "How to earn score/rank/money?\nHow to capture zones?\nHow to become a staff member?\nHow to use the restricted vehicles?\nHow to buy stuffs?\nWhat are flags?", "Choose", "Cancel");
	return 1;
}

CMD:ostats(playerid, params[])
{
	new username[24];
	if(sscanf(params, "s[24]", username)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /ostats [username]");
	if(strlen(username) < 3 || strlen(username) > 24) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /ostats [username]");
	
    new query[200], string[128];
    format(query, sizeof(query), "SELECT `userid`, `registerdate` FROM `users` WHERE `username` = '%s' LIMIT 2", username);
    mysql_query(query);
    mysql_store_result();
    new rows = mysql_num_rows();

	new row[128];
	new field[2][91];

	mysql_fetch_row_format(row, "|");
	explode(row, field, "|");

    if(rows)
    {
		format(string, sizeof(string), "%s (UserID: %d) - RegisterDate: %s", username, strval(field[0]), field[1]);
		SendClientMessage(playerid, COLOR_ORANGE, string);
    }
    else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "Player isn't found in the database.");
  	}
  	mysql_free_result();
	return 1;
}

CMD:pm(playerid,params[])
{
	new player, msg[128], finmsg[192];
	if(sscanf(params,"rs[128]", player, msg))
	{
		SendClientMessage(playerid, COLOR_WHITE,"{3399FF}Usage:{FFFFFF} /pm [playerid/part of nick] [message]");
		return 1;
	}
	if(!IsPlayerConnected(player))
	{
		SendClientMessage(playerid, COLOR_RED,"Error:{FFFFFF} Player isn't connected.");
		return 1;
	}
	if(player == playerid)
	{
	    SendClientMessage(playerid, COLOR_RED, "Error:{FFFFFF} You can´t message yourself");
	    return 1;
	}
	format(finmsg,sizeof(finmsg),"**[PM] from %s(%d): %s", GetName(playerid), playerid, msg);
    SendClientMessage(player, COLOR_YELLOW, finmsg);
	format(finmsg,sizeof(finmsg),"** [PM] to %s(%d): %s", GetName(player), player, msg);
	SendClientMessage(playerid, COLOR_YELLOW, finmsg);
	return 1;
}

CMD:creators(playerid, params[]) return cmd_credits(playerid, params);
CMD:credits(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_w"");
	strcat(string, "State War Field would like to take the time to mention the following members\n");
	strcat(string, "and behalf of that, giving them some credit for their appreciated contribution\n");
	strcat(string, "to our wonderful server.\n\n");
	strcat(string, "{1ABC9C}JaKe{FFFFFF} - Ex. Lead Developer and Server Creator\n");
	strcat(string, "{1ABC9C}Shady{FFFFFF} - Developer and Server Owner\n");
	strcat(string, "{1ABC9C}Amy{FFFFFF} - Ex. Developer and Server Owner\n");
	strcat(string, "{1ABC9C}Ranveer{FFFFFF} - Ex. Mapper and Server Administrator\n");

	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_cr"Server Credits | 1 of 1", string, "Close", "");
	return 1;
}

CMD:cmds(playerid, params[]) return cmd_commands(playerid, params);
CMD:commands(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_cm"");
	strcat(string, "Player Commands:\n");
	strcat(string, ""col_w"");
	strcat(string, "/help, /stats, /ostats, /pm, /kill, /pay, /time /s(witch)t(eam), /ranks, /classes, /vips\n");
	strcat(string, "/credits, /updates, /rules, /report, /admins, /placeflag, /buy, /changename, /changepass\n");
	strcat(string, "/plant, /def, /heal, /armor\n\n");
	strcat(string, "{FF2400}Note:{FFFFFF} If you are an very important player, please type /vcmds for the VIP commands");
	
	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, "Server Commands | 1 of 1", string, "Close", "");
	return 1;
}

CMD:changes(playerid, params[]) return cmd_updates(playerid, params);
CMD:updates(playerid, params[]) {
	HTTP(playerid, HTTP_GET, UPDATES_URL, "", "OnRevCTRLHTTPResponse");
	return SendClientMessage(playerid, -1, "Reading latest changes from {C0C0C0}www.revctrl.com/" #USER_PROJECT "/latest{FFFFFF}, please wait!");
}

CMD:rules(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_w"");
	strcat(string, "Down below you will find our server rules.\n\n");
	strcat(string, "{FFC00C}-{FFFFFF} No Blocking.\n");
	strcat(string, "{FFC00C}-{FFFFFF} No unnecessary flaming, swearing, racism and flooding.\n");
	strcat(string, "{FFC00C}-{FFFFFF} No Hacking, Cheating & Bug Abusing/Expoliting (C-Bug and 2 shots are allowed ONLY).\n");
	strcat(string, "{FFC00C}-{FFFFFF} No teamjacking and teamkilling\n");
	strcat(string, "{FFC00C}-{FFFFFF} Do not pause on checkpoints or base rape.\n");
	strcat(string, "{FFC00C}-{FFFFFF} Do not car park or heliblade.\n");
	strcat(string, "{FFC00C}-{FFFFFF} Do not server advertise or it will lead to a {FF0000}permantley ban.\n\n");
	strcat(string, "{FFFFFF}The most important rule is; {FFC00C}Use your common sense.\n\n");
	strcat(string, "{FFFFFF}Failing in following our rules may result in a warning, or in the worst you will recieve a ban.\n\n");
	strcat(string, "{FFFFFF}You must report people who abuses bug, cheat or are hacking by using our {FFC00C}/report{FFFFFF} command.\n");
	strcat(string, "{FFFFFF}If there are no admins online, head over to our forums where you can report them. {FFC00C}(Make sure you get some evidence).");

	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_or"Server Rules | 1 of 1", string, "Close", "");
	return 1;
}

CMD:kill(playerid, params[])
{
  SetPlayerHealth(playerid, 0);
  return 1;
}

// VIP-Admin Commands

CMD:hyd(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1 || pInfo[playerid][VIP] >= 2)
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
            if(!IsPlayerInInvalidNosVehicle(playerid))
			{
                PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
                AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
                
                SendClientMessage(playerid, COLOR_YELLOW, "Hydraulics added to your vehicle.");
            }
            else
			{
                SendClientMessage(playerid, COLOR_WHITE, "Hydraulics cannot be installed in this vehicle.");
            }
        }
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "You are not on a vehicle to use this command.");
		}
    }
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "You do not have the permission to access this command.");
	}
    return 1;
}

CMD:weather(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1 || pInfo[playerid][VIP] >= 3)
	{
	    new string[128], time;
	    if(sscanf(params, "i", time)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /weather [weather(0-45)]");
	    if(time < 0 || time > 45) return SendClientMessage(playerid, COLOR_WHITE, "Invalid weather!");

	    format(string, sizeof(string), "You have changed your weatherID to %d (Only you).", time);
	    SendClientMessage(playerid, COLOR_YELLOW, string);

	    SetPlayerWeather(playerid, time);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:vpack(playerid, params[])
{
	if(pInfo[playerid][VIP] >= 3)
	{
 	    if((GetTickCount() - GetPVarInt(playerid, "AntiVIP")) > 1000*60*2)
	    {
	        SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 100.0);

	        GivePlayerWeapon(playerid, 16, 10);
	        GivePlayerWeapon(playerid, 26, 1000);
	        GivePlayerWeapon(playerid, 24, 2000);
	        GivePlayerWeapon(playerid, 32, 2000);
	        GivePlayerWeapon(playerid, 31, 2000);
	        GivePlayerWeapon(playerid, 34, 250);
	        GivePlayerWeapon(playerid, 44, 1);
	        GivePlayerWeapon(playerid, 45, 1);
	        
	        SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have used your Donor Package, You received a full percentage of HP/Armoury + Donor Class weapon.");
			
			SetPVarInt(playerid, "AntiVIP", GetTickCount());
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You have to wait for 2 minutes before using the Donor Package again.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:time(playerid, params[])
{
 	new string[128], time;
 	if(sscanf(params, "i", time)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /time [hour(0-23)]");
 	if(time < 0 || time > 23) return SendClientMessage(playerid, COLOR_WHITE, "Invalid time!");
	    
 	format(string, sizeof(string), "You have changed your time to %d:00 (Only you).", time);
 	SendClientMessage(playerid, COLOR_YELLOW, string);
	    
 	SetPlayerTime(playerid, time, 0);
	return 1;
}

CMD:skin(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1 || pInfo[playerid][VIP] >= 2)
	{
	    new string[128], id;
	    if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /skin [skinid(0-299)]");
	    if(id < 0 || id == 74 || id > 299) return SendClientMessage(playerid, COLOR_PINK, "Invalid SkinID.");
	    
	    format(string, sizeof(string), "You have changed your skin to %d.", id);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
	    
	    SetPlayerSkin(playerid, id);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:nos(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1 || pInfo[playerid][VIP] >= 2)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new VehicleID = GetPlayerVehicleID(playerid), Model = GetVehicleModel(VehicleID);
			switch(Model)
			{
				case 448,461,462,463,468,471,509,510,521,522,523,581,586,449: return
				SendClientMessage(playerid, COLOR_PINK, "You cannot place a NOS on this vehicle!");
			}
			AddVehicleComponent(VehicleID, 1010); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			SendClientMessage(playerid, COLOR_YELLOW, " Successfully added nos to your vehicle.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_PINK, "You are not on a vehicle to use this command.");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

// Admin Commands

CMD:get(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
	    new
			id,
			string[130],
			Float:x,
			Float:y,
			Float:z
		;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /get [playerid]");

		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		GetPlayerPos(playerid, x, y, z);
		SetPlayerInterior(id, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));

		if(GetPlayerState(id) == 2)
		{
			new VehicleID = GetPlayerVehicleID(id);
			SetVehiclePos(VehicleID, x+3, y, z);
			LinkVehicleToInterior(VehicleID, GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(GetPlayerVehicleID(id), GetPlayerVirtualWorld(playerid));
		}
		else SetPlayerPos(id, x+2, y, z);

		format(string, sizeof(string), "You have been teleported to Admin %s (%d) location.", nameEx(playerid), playerid);
		SendClientMessage(id, COLOR_YELLOW, string);
		format(string, sizeof(string), "You have teleported %s (%d) to your location.", nameEx(id), id);
		SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
		new Float: pos[3], int;
		if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

		SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have been teleported to the coordinates specified.");
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerInterior(playerid, int);
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
		new
			id,
			string[130],
			Float:x,
			Float:y,
			Float:z
		;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /goto [playerid]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
		GetPlayerPos(id, x, y, z);
		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		if(GetPlayerState(playerid) == 2)
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), x+3, y, z);
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(id));
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(id));
		}
		else SetPlayerPos(playerid, x+2, y, z);
		format(string, sizeof(string), "You have teleported to %s (%d).", nameEx(id), id);
		SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:givehelmet(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
		new
			id,
			string[130]
		;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /givehelmet [playerid]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
		
		if(pInfo[id][pHelmet] == 1) return SendClientMessage(playerid, COLOR_PINK, "Player already have a helmet.");

		pInfo[id][pHelmet] = 1;

		format(string, sizeof(string), "You have given %s (%d) a helmet.", nameEx(id), id);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "%s %s has given you a helmet.", GetAdminRank(playerid), nameEx(playerid));
		SendClientMessage(id, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:removehelmet(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
		new
			id,
			string[130]
		;
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /removehelmet [playerid]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

		if(pInfo[id][pHelmet] == 0) return SendClientMessage(playerid, COLOR_PINK, "Player has no helmet.");

		pInfo[id][pHelmet] = 0;

		format(string, sizeof(string), "You have removed %s (%d) helmet.", nameEx(id), id);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "%s %s has removed your helmet.", GetAdminRank(playerid), nameEx(playerid));
		SendClientMessage(id, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:slap(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
	    new
			Float:x,
			Float:y,
			Float:z,
			Float:health,
			string[128],
			id,
			reason[128]
		;

	    if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /slap [playerid] [reason]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");
		GetPlayerPos(id, x, y, z);
	    GetPlayerHealth(id, health);
	    SetPlayerHealth(id, health-25);
		SetPlayerPos(id, x, y, z+5);
	    PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
	    PlayerPlaySound(id, 1190, 0.0, 0.0, 0.0);
	    
		format(string, sizeof(string), "Admin %s (%d) has slapped %s (%d) for %s", nameEx(playerid), playerid, nameEx(id), id, reason);
		SendClientMessageToAll(COLOR_CUSTOM, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:acmds(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_lb"");
	
	if(pInfo[playerid][Admin] == 0)
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	    return 1;
	}
	
	if(pInfo[playerid][Admin] >= 1)
	{
	    strcat(string, "{00FF00}Junior Admin+: "col_w"/a, /asay, /adminduty, /skin, /nos, /hyd, /time, /weather, /nrg, /kick, /warn\n");
	    strcat(string, ""col_lb"");
	    strcat(string, "{00FF00}Junior Admin+: "col_w"/spawn, /explode, /goto, /slap, /ban, /cc (/clearchat), /jail, /unjail\n");
	}
	if(pInfo[playerid][Admin] >= 2)
	{
	    strcat(string, ""col_lb"");
	    strcat(string, "{068011}General Admin+: "col_w"/car, /hunter, /disarm, /get, /givehelmet, /announce, /gotoco, /searchban\n");
	}
	if(pInfo[playerid][Admin] >= 3)
	{
	    strcat(string, ""col_lb"");
	    strcat(string, "{F4A460}Senior Admin+: "col_w"/giveallscore, /giveallmoney, /removehelmet, /aheal, /aarmor\n");
	}
	if(pInfo[playerid][Admin] >= 4)
	{
	    strcat(string, ""col_lb"");
	    strcat(string, "{FF0000}Head Admin+: "col_w"/setscore, /setmoney, /unban, /givemoney, /givescore, /healall, /armourall\n");
 	    strcat(string, "{FF0000}Head Admin+: "col_w"/oban\n");
	}
	if(pInfo[playerid][Admin] >= 5)
	{
	    strcat(string, ""col_lb"");
	    strcat(string, "{298EFF}Executive Admin+: "col_w"/makeadmin, /makedonor, /gmx, /updatemotd");
	}
	if(pInfo[playerid][Admin] >= 1)
	{
	    ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"Administrative Commands", string, "Close", "");
	}
	return 1;
}

CMD:announce(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 3)
	{
	new
 	announce[16];

	if(sscanf(params, "s[16]", announce))
	{
		SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /announce <message>");
		SendClientMessage(playerid, COLOR_WHITE, "This will send text message on center of screen to all players on server.");
	    return 1;
	}

	if(strlen(announce) > 16)
	{
		SendClientMessage(playerid, COLOR_RED, "* Your message can't be longer then 16 characters.");
	    return 1;
	}

    format(TempStr, sizeof(TempStr), "%s", announce);
    GameTextForAll(TempStr, 3000, 3);
    }
	return 1;
}

CMD:healall(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
 	{

 	// Create variable
	new
		pname[24];

	// Get player name
	GetPlayerName(playerid,pname,sizeof(pname));

	// Send message to all players
	format(TempStr, sizeof (TempStr), "{FFDD00}Admin %s has healed everyone!", pname);
    SendClientMessageToAll(COLOR_WHITE, TempStr);

	// Loop
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    // Set of all players health to 100 units
	    SetPlayerHealth(i, 100);
	}
	// Exit
	}
	return 1;
}

CMD:aarmor(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 3)
	{
		new
		id,
		string[130];

    	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /aarmor [playerid]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, "Player isn't connected.");
		SetPlayerArmour(id, 100.0);
		format(string, sizeof(string), "You have given %s an armour.", nameEx(id));
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "Administrator %s has given you a full armour.", nameEx(playerid));
		SendClientMessage(id, COLOR_YELLOW, string);
	}
	return 1;
}

CMD:aheal(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 3)
	{
		new
		id,
		string[130];

    	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /aheal [playerid]");
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, "Player isn't connected.");

   		SetPlayerHealth(id, 100.0);
		format(string, sizeof(string), "You have given Player %s a full pack of health.", nameEx(id));
    	SendClientMessage(playerid, COLOR_YELLOW, string);
   		format(string, sizeof(string), "Administrator %s has given you a full pack of health.", nameEx(playerid));
   		SendClientMessage(id, COLOR_YELLOW, string);
   	}
	return 1;
}

CMD:armorall(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{

 	// Create variable
	new
		pname[24];

	// Get player name
	GetPlayerName(playerid,pname,sizeof(pname));

	// Send message to all players
	format(TempStr, sizeof (TempStr), "{FFDD00}Admin %s has given armour to everyone!", pname);
    SendClientMessageToAll(COLOR_WHITE, TempStr);

	// Loop
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    // Set of all players armour to 100 units
	    SetPlayerArmour(i, 100);
	}
	}
 // Exit
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	    new string[135], id, money;
	    if(sscanf(params, "ui", id, money)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /givemoney [playerid] [cash]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

		GivePlayerMoney(id, money);

		format(string, sizeof(string), "* %s %s has given you a money of $%d.", GetAdminRank(playerid), nameEx(playerid), money);
		SendClientMessage(id, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You given Player %s a money of $%d.", nameEx(id), money);
		SendClientMessage(playerid, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	new target, amount;
	if( !sscanf(params, "ui", target, amount) )
	{
		if( amount < 5 ) return SendClientMessage(playerid, -1, "Min: 1 - Max: 9999999");
		if( amount > 9999999 ) return SendClientMessage(playerid, -1, "Min: 1 - Max: 9999999");
		if( target == INVALID_PLAYER_ID ) return SendClientMessage(playerid, -1, "Invalid player ID.");
		if( target == playerid ) return SendClientMessage(playerid, COLOR_RED, "Error: You can't pay yourself.");
		if( GetPlayerMoney(playerid) < amount ) return SendClientMessage(playerid, COLOR_RED, "Error: You don't have that amount of cash.");
		GivePlayerMoney(playerid, -amount); // removing the money from you
		GivePlayerMoney(target, amount); // adding the money to you

	} else return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /pay [playerid] [amount of the money]");
	return 1;
}

CMD:giveallmoney(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 3)
	{
	    new string[135], score;
	    if(sscanf(params, "i", score)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /giveallmoney [money]");

		foreach(new i : Player)
		{
		    if(i != playerid)
		    {
				GivePlayerMoney(i, score);
			}
		}

		format(string, sizeof(string), "Admin %s has given everyone a money of $%d.", nameEx(playerid), score);
		SendClientMessageToAll(COLOR_LIGHTBLUE, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:giveallscore(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 3)
	{
	    new string[135], score;
	    if(sscanf(params, "i", score)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /giveallscore [score]");

		foreach(new i : Player)
		{
		    if(i != playerid)
		    {
				SetPlayerScore(i, GetPlayerScore(i) + score);
				RankUp(i);
			}
		}
		
		format(string, sizeof(string), "Admin %s has given everyone a score of %d.", nameEx(playerid), score);
		SendClientMessageToAll(COLOR_LIGHTBLUE, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:givescore(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	    new string[135], id, score;
	    if(sscanf(params, "ui", id, score)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /givescore [playerid] [score]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

		SetPlayerScore(id, GetPlayerScore(id) + score);
		RankUp(id);

		format(string, sizeof(string), "* %s %s has given you a score of %d.", GetAdminRank(playerid), nameEx(playerid), score);
		SendClientMessage(id, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You given Player %s a score of %d.", nameEx(id), score);
		SendClientMessage(playerid, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:setscore(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	    new string[135], id, score;
	    if(sscanf(params, "ui", id, score)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /setscore [playerid] [score]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		SetPlayerScore(id, score);
		RankUp(id);
		
		format(string, sizeof(string), "* %s %s has set your score to %d.", GetAdminRank(playerid), nameEx(playerid), score);
		SendClientMessage(id, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You set Player %s score to %d.", nameEx(id), score);
		SendClientMessage(playerid, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	    new string[135], id, score;
	    if(sscanf(params, "ui", id, score)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /setmoney [playerid] [money]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		ResetPlayerMoney(id);
		GivePlayerMoney(id, score);

		format(string, sizeof(string), "* %s %s has set your money to $%d.", GetAdminRank(playerid), nameEx(playerid), score);
		SendClientMessage(id, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You set Player %s money to $%d.", nameEx(id), score);
		SendClientMessage(playerid, -1, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:warn(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
	    new string[135], id, reason[100];
	    if(sscanf(params, "us[100]", id, reason)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /warn [playerid] [reason]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		Warn[id] += 1;

		format(string, sizeof(string), "Admin %s (%d) has warned %s (%d), reason: %s (Warnings %d/5)", nameEx(playerid), playerid, nameEx(id), id, reason, Warn[id]);
		SendClientMessageToAll(COLOR_REALRED, string);

		format(string, sizeof(string), "You have been warned by Admin %s (%d), reason: %s (Warnings %d/5)", nameEx(playerid), playerid, reason, Warn[id]);
		SendClientMessage(id, -1, string);

		if(Warn[id] == 5)
		{
		    ClearMe(id);
		    format(string, sizeof(string), "Player %s (%d) has been kicked for exceeding the maximum warning limit.", nameEx(id), id);
		    SendClientMessageToAll(COLOR_REALRED, string);
		    
		    SendClientMessage(id, -1, "You have been kicked for exceeding the maximum warning limit.");
		    
		    KickDelay(id);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:explode(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
		new string[128],
			id,
			Float:x,
			Float:y,
			Float:z,
			reason[100]
		;
		
	    if(sscanf(params, "us[100]", id, reason)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /explode [playerid] [reason]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		GetPlayerPos(id, x, y, z);

		format(string, sizeof(string), "Admin %s (%d) has exploded %s (%d) for %s", nameEx(playerid), playerid, nameEx(id), id, reason);
		SendClientMessageToAll(COLOR_REALRED, string);

		format(string, sizeof(string), "You have been exploded by Admin %s (%d) for %s", nameEx(playerid), playerid, reason);
		SendClientMessage(id, -1, string);

		CreateExplosionForPlayer(id, x, y, z, 7, 1.00);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:spawn(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
	    new string[135], id;
	    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /spawn [playerid]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		format(string, sizeof(string), "Admin %s has respawned you.", nameEx(playerid));
		SendClientMessage(id, COLOR_LIGHTBLUE, string);

		format(string, sizeof(string), "You have respawned %s.", nameEx(id));
		SendClientMessage(playerid, -1, string);

		SpawnPlayer(id);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:disarm(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
	    new string[135], id;
	    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /disarm [playerid]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		format(string, sizeof(string), "Admin %s has removed your weapons.", nameEx(playerid));
		SendClientMessage(id, COLOR_LIGHTBLUE, string);

		format(string, sizeof(string), "You have removed %s's weapons.", nameEx(id));
		SendClientMessage(playerid, -1, string);

		ResetPlayerWeapons(id);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
	    new string[135], id, reason[100];
	    if(sscanf(params, "us[100]", id, reason)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /kick [playerid] [reason]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(pInfo[playerid][Admin] < pInfo[id][Admin]) return SendClientMessage(playerid, COLOR_PINK, "You cannot use this command on higher admin.");

		ClearMe(id);

		format(string, sizeof(string), "Admin %s (%d) has kicked %s (%d) for %s", nameEx(playerid), playerid, nameEx(id), id, reason);
		SendClientMessageToAll(COLOR_REALRED, string);
		
		format(string, sizeof(string), "You have been kicked by Admin %s (%d) for %s", nameEx(playerid), playerid, reason);
		SendClientMessage(id, -1, string);
		
		KickDelay(id);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:jail(playerid,params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
		new id, szString[135], time, reason[100], PlayerNameTwo[MAX_PLAYER_NAME], GPlayerName[MAX_PLAYER_NAME];
		if(sscanf(params,"dds",id,time,reason)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /jail [playerid] [time/minutes] [reason]");
		if (!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "Error: Player isn't connected, make sure if he is connected or not.");
		if(Jailed[id] == 1) return SendClientMessage(playerid, COLOR_RED, "Error: Player is already jailed.");
		GetPlayerName(id, PlayerNameTwo, sizeof(PlayerNameTwo));
	 	GetPlayerName(playerid, GPlayerName, sizeof(GPlayerName));
	 	format(szString, sizeof(szString), "%s (ID:%d) has been jailed for %d minutes, Reason: %s", nameEx(id), id, time, reason);
		SendClientMessageToAll(COLOR_RED, szString);
		SetPlayerInterior(id, 6);
		SetPlayerVirtualWorld(id, 1);
		SetPlayerFacingAngle(id, 360.0);
		SetPlayerPos(id, 264.0814, 77.6404, 1001.0391);
		SetPlayerHealth(id, 9999999999.0);
		ResetPlayerWeapons(id);
		JailTimer[id] = SetTimerEx("Unjail",time*60000, false, "i", id);
	}
	else {
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:unjail(playerid,params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
    	new id;
        if(sscanf(params,"d",id)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /unjail [playerid]");
        if (!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "Error: Player isn't connected, make sure if he is connected or not.");
        if(Jailed[id] == 0) return SendClientMessage(playerid, COLOR_RED, "Error: Player isn't jailed, Try again.");
        Jailed[id] = 0;
		SetPlayerInterior(id, 0);
		SetPlayerVirtualWorld(id, 0);
		SpawnPlayer(id);
		SetPlayerHealth(id, 100);
		KillTimer(JailTimer[id]);
    }
    else {
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
    }
    return 1;
}

CMD:ban(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
		new id, reason[48];
		if(sscanf(params, "us[48]", id, reason)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /ban [playerid] [reason]");
		if(id == INVALID_PLAYER_ID || !IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "Invalid ID");
		BanWithReason(playerid, id, reason);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:oban(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	new Query[240], string[112], pName[24], reason[48], DBResult:result, day, month, year, second, minute, hour, datestring[24], timestring[24];
	if(sscanf(params, "s[24]s[48]", pName, reason)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /oban [playername] [reason]");

	format(Query, sizeof(Query), "SELECT `NAME` FROM `BANNED` WHERE `NAME` = '%s'", pName);
	result = db_query(bans, Query);
	if(!db_num_rows(result))
	{
	    getdate(day, month, year), gettime(hour, minute, second);
		format(datestring, sizeof(datestring), "%i-%i-%i", day, month, year), format(timestring, sizeof(timestring), "%i:%i:%i", hour, minute, second);

		format(Query, sizeof(Query), "INSERT INTO `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`) VALUES ('%s', '0', '%s', '%s', '%s', '%s')", DB_Escape(pName), reason, DB_Escape(GetName(playerid)), datestring, timestring);
		result = db_query(bans, Query);
		if(result)
		{
			format(string, sizeof(string), "SERVER: %s has been offline banned by %s(%d), reason: %s", pName, GetName(playerid), playerid, reason);
			SendClientMessageToAll(COLOR_RED, string), string = "\0";

			printf("[ban] [%s]: offlinebanned %s due to %s", GetName(playerid), pName, reason);
		}
		else
		{
  			format(string, sizeof(string), "SERVER: Failed to ban '%s'..", pName), SendClientMessage(playerid, -1, string);
  			printf("[ban] [%s]: failed to offlineban %s due to %s", GetName(playerid), pName, reason);
		}
	}
	else return SendClientMessage(playerid, -1, "INFO: That username is already banned!");
    db_free_result(result);
   	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:searchban(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 2)
	{
    if(isnull(params)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /searchban [playername/ip]");
    else
	{
        new Query[240], string[180];
        format(Query, sizeof(Query), "SELECT * FROM `BANNED` WHERE `NAME` LIKE '%%%s%%' OR `IP` LIKE '%%%s%%' ORDER BY `DATE` DESC LIMIT 6", params, params);
        new DBResult:Result = db_query(bans, Query);
        if(db_num_rows(Result))
        {
            new BannedBy[MAX_PLAYER_NAME], BannedName[MAX_PLAYER_NAME], BannedIP[MAX_PLAYER_NAME], BannedReason[MAX_PLAYER_NAME*2];
            do
            {
                db_get_field_assoc(Result, "NAME", BannedName, sizeof(BannedName));
                db_get_field_assoc(Result, "IP", BannedIP, sizeof(BannedIP));
                db_get_field_assoc(Result, "ADMIN", BannedBy, sizeof(BannedBy));
                db_get_field_assoc(Result, "REASON", BannedReason, sizeof(BannedReason));

                format(string, sizeof(string), "- {FC4949}%s(IP: %s) {FFFFFF}- {FC4949}banned by %s {FFFFFF}- due to %s", BannedName, BannedIP, BannedBy, BannedReason);
                SendClientMessage(playerid, -1, string);
            }
            while(db_next_row(Result));
        }
        else SendClientMessage(playerid, COLOR_ORANGE, "NOTE: No bans found!");
        db_free_result(Result);
        string = "\0", Query = "\0";
    	}
   	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
    return 1;
}
CMD:unban(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 4)
	{
	new pName[24], Query[132], DBResult:Result;
	new stringz[92];
    if(sscanf(params, "s[24]s[50]", pName)) return SendClientMessage(playerid, -1, "{3399FF}Usage:{FFFFFF} /unban [playername]");


    format(Query, sizeof(Query), "SELECT * FROM `BANNED` WHERE `NAME` = '%s'", pName);
    Result = db_query(bans, Query);
    if(db_num_rows(Result))
	{
	    format(Query, sizeof(Query), "DELETE FROM `BANNED` WHERE `NAME` = '%s'", pName);
	    Result = db_query(bans, Query);
	    format(stringz, sizeof(stringz), "Success: {FFFFFF}Player %s has been un-banned from the server", pName);
	    SendClientMessage(playerid, COLOR_GREEN, stringz), stringz = "\0";
	}
	else SendClientMessage(playerid, -1, "SERVER: No bans found on that user-name!");
	stringz = "\0", Query = "\0";
	db_free_result(Result);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
    return 1;
}

CMD:adminduty(playerid, params[])
{
	new string[135], skinid;

	if(pInfo[playerid][Admin] >= 1)
	{
	    if(aDuty[playerid] == 0)
	    {
	        if(sscanf(params, "i", skinid)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /adminduty [skinid]");
	        if(skinid < 0 || skinid == 74 || skinid > 299) return SendClientMessage(playerid, COLOR_PINK, "Invalid SkinID.");
	    
	        UpdateDynamic3DTextLabelText(Label[playerid], COLOR_REALRED, "* DO NOT ATTACK, ADMIN ON DUTY **");
	        SetPlayerColor(playerid, COLOR_PINK);
	        aDuty[playerid] = 1;
	        SetPlayerArmour(playerid, 100000);
	        SetPlayerHealth(playerid, 100000);
	        
	        KillTimer(Protection[playerid]);
	        
	        SetPlayerSkin(playerid, skinid);
	        
	        format(string, sizeof(string), "%s %s is now on admin-duty (Color Pink Marker - Admin Duty Label)", GetAdminRank(playerid), nameEx(playerid));
	        SendClientMessageToAll(COLOR_PINK, string);
	    }
	    else if(aDuty[playerid] == 1)
	    {
	        format(string, sizeof(string), "%s", GetRank(playerid));
	        UpdateDynamic3DTextLabelText(Label[playerid], GetPlayerColor(playerid), string);
	        aDuty[playerid] = 0;
			SpawnPlayer(playerid);

	        format(string, sizeof(string), "%s %s is now off admin-duty.", GetAdminRank(playerid), nameEx(playerid));
	        SendClientMessageToAll(COLOR_PINK, string);
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:asay(playerid, params[])
{
	new string[135];

	if(pInfo[playerid][Admin] >= 1)
	{
	    if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /asay [message]");

	    format(string, sizeof string, "%s %s: %s", GetAdminRank(playerid), nameEx(playerid), params);
	    SendClientMessageToAll(COLOR_PINK, string);

	    print(string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:updatemotd(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 5)
	{
	    new string[128];
	    if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /updatemotd [message of the day]");

	    format(string, sizeof(string), "%s %s has updated the message of the day on spawn.", GetAdminRank(playerid), nameEx(playerid));
	    SendClientMessageToAll(COLOR_LIME, string);

		format(servermotdUpdate, sizeof servermotdUpdate, "%s", params);

		Update_Settings();
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:makedonor(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 5 || IsPlayerAdmin(playerid))
	{
	    new id, string[128], level;
	    if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /makedonor [playerid] [level(0-5)]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(level < 0 || level > 3) return SendClientMessage(playerid, COLOR_PINK, "Invalid donor level.");
		if(LoggedIn[id] == 0) return SendClientMessage(playerid, COLOR_PINK, "Player not logged/registered.");
		if(pInfo[id][VIP] == level) return SendClientMessage(playerid, COLOR_PINK, "Player already have that donor rank.");

	    format(string, sizeof(string), "%s %s has set your donor level statistics to %d.", GetAdminRank(playerid), nameEx(playerid), level);
	    SendClientMessage(id, COLOR_LIME, string);
	    format(string, sizeof(string), "You have set %s's donor level statistics to %d.", nameEx(id), level);
	    SendClientMessage(playerid, -1, string);

	    pInfo[id][VIP] = level;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:makeadmin(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 5 || IsPlayerAdmin(playerid))
	{
	    new id, string[128], level;
	    if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /makeadmin [playerid] [level(0-5)]");
	    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
	    if(level < 0 || level > 5) return SendClientMessage(playerid, COLOR_PINK, "Invalid administrative level.");
		if(LoggedIn[id] == 0) return SendClientMessage(playerid, COLOR_PINK, "Player not logged/registered.");
	    if(pInfo[id][Admin] == level) return SendClientMessage(playerid, COLOR_PINK, "Player already have that administrative rank.");

	    format(string, sizeof(string), "Executive Admin %s has set your administrative level statistics to %d.", nameEx(playerid), level);
	    SendClientMessage(id, COLOR_LIME, string);
	    format(string, sizeof(string), "You have set %s's administrative level statistics to %d.", nameEx(id), level);
	    SendClientMessage(playerid, -1, string);

	    pInfo[id][Admin] = level;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:gmx(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 5 || IsPlayerAdmin(playerid))
	{
		new
		pname[24];
		GetPlayerName(playerid,pname,sizeof(pname));
		format(TempStr, sizeof (TempStr), "{FFFFFF}Server:{FFDD00} Executive Admin %s (ID: %d) is restarting the server, please re-join!", pname, playerid);
	    SendClientMessageToAll(COLOR_LIGHTBLUE, TempStr);

		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			GameTextForAll("~r~SERVER IS RESTARTING", 3000, 5);
		    Kick(i);
		}
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		    SetPlayerHealth(i, 100);
		}
	    SendRconCommand("gmx");
	}
	else
	{
		SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:a(playerid, params[])
{
	new string[135];

	if(pInfo[playerid][Admin] >= 1)
	{
	    if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /a [chat]");
	    
	    format(string, sizeof string, "[%s %s: %s]", GetAdminRank(playerid), nameEx(playerid), params);
	    SendAdminMessage(0x6699FF00, string);
	    
	    print(string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

// Player Commands

CMD:abilities(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_w"Class Abilities will be listed below...\n\n");
	strcat(string, ""col_lb"Assault\n"col_w"- Ability to heal himself with /heal with a waiting period of 4 mins.\n\n");
	strcat(string, ""col_lb"Sniper\n"col_w"- Hidden marker on the map.\n\n");
	strcat(string, ""col_lb"Pilot\n"col_w"- Ability to drive/fly planes.\n\n");
	strcat(string, ""col_lb"Engineer\n"col_w"- Ability to drive Rhino/Heavy Vehicle & Fix vehicles.\n\n");
	strcat(string, ""col_lb"Supporter\n"col_w"- Same like /heal, but this time armour.\n\n");
	strcat(string, ""col_lb"Demolisher\n"col_w"- Ability to plant/defuse bombs.\n\n");
	strcat(string, ""col_y"* SPECIAL * Donor\n"col_w"- Many special capabilities that other class can't have! (Seek the forum for more info).");

	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"Abilities", string, "Close", "");
	return 1;
}

CMD:switchteam(playerid, params[])
{
	if(inClass[playerid] == 0)
	{
	    ClearMe(playerid);

	    SendClientMessage(playerid, COLOR_LIME, "Select your team.");

	    KillTimer(Protection[playerid]);

	    ForceClassSelection(playerid);
	    TogglePlayerSpectating(playerid, true);
	    TogglePlayerSpectating(playerid, false);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_REALRED, "You may not use this command whilist on team selection.");
	}
	return 1;
}

CMD:st(playerid, params[]) return cmd_switchteam(playerid, params);

CMD:ranks(playerid, params[])
{
	new string[1000];

	strcat(string, ""col_w"Ranks helps you to achieve alot of things in the server like weapons, armor & etc\n\n");
	strcat(string, ""col_lb"");
	strcat(string, "0 - Private:{FFFFFF} 0\n");
	strcat(string, "{33CCFF}1 - Corporal:{FFFFFF} 50-100\n");
	strcat(string, "{33CCFF}2 - Lieutenant:{FFFFFF} 100-300\n");
	strcat(string, "{33CCFF}3 - Major:{FFFFFF} 300-500\n");
	strcat(string, "{33CCFF}4 - Captain:{FFFFFF} 500-1000\n");
	strcat(string, "{33CCFF}5 - Commander:{FFFFFF} 1000-1500\n");
	strcat(string, "{33CCFF}6 - General:{FFFFFF} 1500-2500\n");
	strcat(string, "{33CCFF}7 - Brigadier:{FFFFFF} 2500-4500\n");
	strcat(string, "{33CCFF}8 - Field Marshall:{FFFFFF} 4500-6000\n");
	strcat(string, "{33CCFF}9 - Master of War:{FFFFFF} 6000-7500\n");
	strcat(string, "{33CCFF}10 - General of the Army:{FFFFFF} 7500-10000\n");
	strcat(string, "{33CCFF}11 - Prestige I:{FFFFFF} 10000-13500\n");
	strcat(string, "{33CCFF}12 - Prestige II:{FFFFFF} 13500-15000\n\n");
	strcat(string, "{FF2400}Note:{FFFFFF} After Rank 12, You will be no longer receiving rewards or rank ups from your rank.");

	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"Ranks | 1 of 1", string, "Close", "");
	return 1;
}

CMD:classes(playerid, params[])
{
	new string[1000];

	strcat(string, ""col_w"Classes helps you to do alot of things in the server like flying with planes, driving heavy vehicles, etc\n\n");
	strcat(string, "{33CCFF}0 - Assault:{FFFFFF} No rank is required - Ability to /heal with a limit of 4 minutes waiting period.\n");
	strcat(string, "{33CCFF}1 - Sniper:{FFFFFF} You must have the Corporal rank - Hidden in the map and have the ability to use Sniper Rifle\n");
	strcat(string, "{33CCFF}2 - Engineer:{FFFFFF} You must have the General rank - Driving the Rhino/Heavy vehicles and have the ability to use heavy weapons\n");
	strcat(string, "{33CCFF}3 - Pilot:{FFFFFF} You must have the Brigadier rank - Flying with the heavy planes like Hydra, Seasparrow and Hunter\n");
	strcat(string, "{33CCFF}4 - Supporter:{FFFFFF} You must have the Field Marshall rank - Ability to /armor and /heal with a limit of 4 minutes waiting period\n");
	strcat(string, "{33CCFF}5 - Demolisher:{FFFFFF} You must have the Master of the War rank - Ability to /plant and /def with a limit of 4 minutes waiting period.\n");
	strcat(string, "{33CCFF}6 - Donor:{FFFFFF} You must have the VIP rank, level 3 - Capability of all the combined classes/free armoury/no payments in /buy\n\n");
	strcat(string, "{FF2400}Note:{FFFFFF} After Donor class, There will be no longer classes after it, if you want a new class, feel free to suggest it.");

	ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"Classes | 1 of 1", string, "Close", "");
	return 1;
}

CMD:stats(playerid, params[])
{
	new string[1197], admin[30], vip[30], holder[1197], id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /stats [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

    if(pInfo[id][Admin]) format(admin, sizeof(admin), "Yes - (%s)", GetAdminRank(playerid));
	else if(!pInfo[id][Admin]) format(admin, sizeof(admin), "No");
	
 	if(pInfo[id][VIP]) format(vip, sizeof(vip), "Yes - (%s)", GetVIPRank(playerid));
	else if(!pInfo[id][VIP]) format(vip, sizeof(vip), "No");

	new Float:ratio = (float(pInfo[id][Kills])/float(pInfo[id][Deaths]));

	format(string, sizeof(string), "{007BD0}[Account]{D8D8D8} Account ID: [%d] | Name: [%s] | Score: [%d] | Rank: [%s (%d)] | Registration Date: [%s]\n", pInfo[id][userid], nameEx(id), GetPlayerScore(id), GetRank(id), pInfo[id][Rank], pInfo[id][RegisterDate]);
	strcat(holder, string, sizeof(holder));
	format(string, sizeof(string), "{007BD0}[Details]{D8D8D8} Team: [%s] | Class: [%s] | Money: [%d] | Kills: [%d] | Deaths: [%d] | Ratio: [%.3f]\n", GetTeam(id), GetClass(id), GetPlayerMoney(id), pInfo[id][Kills], pInfo[id][Deaths], ratio);
	strcat(holder, string, sizeof(holder));
	format(string, sizeof(string), "{007BD0}[Status]{D8D8D8} Administrator: [%s] | Very Important Player: [%s]\n", admin, vip);
	strcat(holder, string, sizeof(holder));
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{007BD0}Account Details", holder, "Print", "Close");
	return 1;
}

CMD:vips(playerid, params[])
{
	new string[135], count = 0;

	SendClientMessage(playerid, COLOR_YELLOW, "Current Online VIPs:");

	foreach(new i : Player)
	{
	    if(LoggedIn[i] == 1)
	    {
	        if(pInfo[i][VIP] >= 1)
	        {
	            format(string, 135, "(%d) %s - Donor Level %d", i, nameEx(i), pInfo[i][VIP]);
	            SendClientMessage(playerid, -1, string);
	            count++;
	        }
	    }
	}

	if(count == 0) return SendClientMessage(playerid, -1, "There are no admins online in the server at the moment.");
	return 1;
}

CMD:admins(playerid, params[])
{
	new string[135], count = 0;
	
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Current Online Admins:");
	
	foreach(new i : Player)
	{
	    if(LoggedIn[i] == 1)
	    {
	        if(pInfo[i][Admin] >= 1)
	        {
	            if(aDuty[i] == 0)
	            {
		            format(string, 135, "{FF0000}(Off-Duty){FFFFFF} %s - %s", nameEx(i), GetAdminRank(i));
		            SendClientMessage(playerid, -1, string);
				}
				else
				{
		            format(string, 135, "{008000}(On-Duty){FFFFFF} %s - %s", nameEx(i), GetAdminRank(i));
		            SendClientMessage(playerid, -1, string);
				}
	            count++;
	        }
	    }
	}
	
	if(count == 0) return SendClientMessage(playerid, -1, "There are no admins online in the server at the moment.");
	return 1;
}

CMD:placeflag(playerid, params[])
{
	new string[500];

	new id = flagPlayer2[playerid];

	if(IsAtFlag(playerid) == 1)
	{
	    if(gTeam[playerid] != TEAM_USA) return SendClientMessage(playerid, COLOR_PINK, "You have to be in team USA to place a flag here.");
	    if(flagPlayer2[playerid] == -1) return SendClientMessage(playerid, COLOR_PINK, "You do not have a flag on you.");

		if(flagPlayer[playerid] == TEAM_USA)
		{
			format(string, sizeof(string), "* %s (%s) has successfully returned the stolen flag back to their base.", nameEx(playerid), GetTeam(playerid));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "Your team-mate has returned your team's stolen flag, How lucky you guys are!");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;
			
			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			SendClientMessageToAll(COLOR_LIME, "You won +4 score and $4000 for returning your team's flag to your base.");

			GivePlayerMoney(playerid, 4000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 4);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
		else
		{
			format(string, sizeof(string), "* %s (%s) has successfully take the flag of %s back to their base.", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "You have lost -3 score and $1000 due to the lost of flag, The flag will eventually spawn anytime.");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			foreach(new i : Player)
			{
			    if(flagPlayer[playerid] == gTeam[i])
			    {
			        GivePlayerMoney(i, -1000);
			        SetPlayerScore(i, GetPlayerScore(i) - 3);
			    }
			}

			SendClientMessageToAll(COLOR_LIME, "You won +6 score and $6000.");

			GivePlayerMoney(playerid, 6000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 6);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
	}
	else if(IsAtFlag(playerid) == 2)
	{
	    if(gTeam[playerid] != TEAM_ARAB) return SendClientMessage(playerid, COLOR_PINK, "You have to be in team Arab to place a flag here.");
	    if(flagPlayer2[playerid] == -1) return SendClientMessage(playerid, COLOR_PINK, "You do not have a flag on you.");

		if(flagPlayer[playerid] == TEAM_ARAB)
		{
			format(string, sizeof(string), "* %s (%s) has successfully returned the stolen flag back to their base.", nameEx(playerid), GetTeam(playerid));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "Your team-mate has returned your team's stolen flag, How lucky you guys are!");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			SendClientMessageToAll(COLOR_LIME, "You won +4 score and $4000 for returning your team's flag to your base.");

			GivePlayerMoney(playerid, 4000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 4);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
		else
		{
			format(string, sizeof(string), "* %s (%s) has successfully take the flag of %s back to their base.", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "You have lost -3 score and $1000 due to the lost of flag, The flag will eventually spawn anytime.");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			foreach(new i : Player)
			{
			    if(flagPlayer[playerid] == gTeam[i])
			    {
			        GivePlayerMoney(i, -1000);
			        SetPlayerScore(i, GetPlayerScore(i) - 3);
			    }
			}

			SendClientMessageToAll(COLOR_LIME, "You won +6 score and $6000.");

			GivePlayerMoney(playerid, 6000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 6);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
	}
	else if(IsAtFlag(playerid) == 3)
	{
	    if(gTeam[playerid] != TEAM_EURASIA) return SendClientMessage(playerid, COLOR_PINK, "You have to be in team Eurasia to place a flag here.");
	    if(flagPlayer2[playerid] == -1) return SendClientMessage(playerid, COLOR_PINK, "You do not have a flag on you.");

		if(flagPlayer[playerid] == TEAM_EURASIA)
		{
			format(string, sizeof(string), "* %s (%s) has successfully returned the stolen flag back to their base.", nameEx(playerid), GetTeam(playerid));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "Your team-mate has returned your team's stolen flag, How lucky you guys are!");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			SendClientMessageToAll(COLOR_LIME, "You won +4 score and $4000 for returning your team's flag to your base.");

			GivePlayerMoney(playerid, 4000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 4);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
		else
		{
			format(string, sizeof(string), "* %s (%s) has successfully take the flag of %s back to their base.", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "You have lost -3 score and $1000 due to the lost of flag, The flag will eventually spawn anytime.");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			foreach(new i : Player)
			{
			    if(flagPlayer[playerid] == gTeam[i])
			    {
			        GivePlayerMoney(i, -1000);
			        SetPlayerScore(i, GetPlayerScore(i) - 3);
			    }
			}

			SendClientMessageToAll(COLOR_LIME, "You won +6 score and $6000.");

			GivePlayerMoney(playerid, 6000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 6);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
	}
    	else if(IsAtFlag(playerid) == 4)
	{
	    if(gTeam[playerid] != TEAM_AUSTRALIA) return SendClientMessage(playerid, COLOR_PINK, "You have to be in team Australia to place a flag here.");
	    if(flagPlayer2[playerid] == -1) return SendClientMessage(playerid, COLOR_PINK, "You do not have a flag on you.");

		if(flagPlayer[playerid] == TEAM_AUSTRALIA)
		{
			format(string, sizeof(string), "* %s (%s) has successfully returned the stolen flag back to their base.", nameEx(playerid), GetTeam(playerid));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "Your team-mate has returned your team's stolen flag, How lucky you guys are!");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			SendClientMessageToAll(COLOR_LIME, "You won +4 score and $4000 for returning your team's flag to your base.");

			GivePlayerMoney(playerid, 4000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 4);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
		else
		{
			format(string, sizeof(string), "* %s (%s) has successfully take the flag of %s back to their base.", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "You have lost -3 score and $1000 due to the lost of flag, The flag will eventually spawn anytime.");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			foreach(new i : Player)
			{
			    if(flagPlayer[playerid] == gTeam[i])
			    {
			        GivePlayerMoney(i, -1000);
			        SetPlayerScore(i, GetPlayerScore(i) - 3);
			    }
			}

			SendClientMessageToAll(COLOR_LIME, "You won +6 score and $6000.");

			GivePlayerMoney(playerid, 6000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 6);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
	}
    	else if(IsAtFlag(playerid) == 5)
	{
	    if(gTeam[playerid] != TEAM_SOVIET) return SendClientMessage(playerid, COLOR_PINK, "You have to be in team Soviet to place a flag here.");
	    if(flagPlayer2[playerid] == -1) return SendClientMessage(playerid, COLOR_PINK, "You do not have a flag on you.");

		if(flagPlayer[playerid] == TEAM_SOVIET)
		{
			format(string, sizeof(string), "* %s (%s) has successfully returned the stolen flag back to their base.", nameEx(playerid), GetTeam(playerid));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "Your team-mate has returned your team's stolen flag, How lucky you guys are!");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			SendClientMessageToAll(COLOR_LIME, "You won +4 score and $4000 for returning your team's flag to your base.");

			GivePlayerMoney(playerid, 4000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 4);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
		else
		{
			format(string, sizeof(string), "* %s (%s) has successfully take the flag of %s back to their base.", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
			SendClientMessageToAll(COLOR_CUSTOM, string);
			SendTeamChat(flagPlayer[playerid], COLOR_YELLOW, "You have lost -3 score and $1000 due to the lost of flag, The flag will eventually spawn anytime.");

	        RemovePlayerAttachedObject(playerid, 0);

			fInfo[id][fTaken] = false;
			fInfo[id][HasIt] = INVALID_PLAYER_ID;

			CreateFlag(id, flagPlayer[playerid], fInfo[id][oFlag_Pos][0], fInfo[id][oFlag_Pos][1], fInfo[id][oFlag_Pos][2]);
			fInfo[id][foldpos] = true;

			foreach(new i : Player)
			{
			    if(flagPlayer[playerid] == gTeam[i])
			    {
			        GivePlayerMoney(i, -1000);
			        SetPlayerScore(i, GetPlayerScore(i) - 3);
			    }
			}

			SendClientMessageToAll(COLOR_LIME, "You won +6 score and $6000.");

			GivePlayerMoney(playerid, 6000);
			SetPlayerScore(playerid, GetPlayerScore(playerid) + 6);

			flagPlayer[playerid] = -1;
			flagPlayer2[playerid] = -1;
		}
	}
		else
		{
	    	SendClientMessage(playerid, COLOR_PINK, "You are not on a stolen flag booth.");
		}
	return 1;
}

CMD:buy(playerid, params[])
{
	if(AtShop(playerid))
	{
	    if(pInfo[playerid][VIP] >= 3)
	    {
	        ShowDialog(playerid, 2);
	    }
	    else
	    {
	        ShowDialog(playerid, 1);
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You are not on an armoury shop.");
	}
	return 1;
}

// VIP-Class Commands

CMD:vcmds(playerid, params[])
{
	new string[1000];
	strcat(string, ""col_y"");

	if(pInfo[playerid][VIP] == 0)
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	    return 1;
	}

	if(pInfo[playerid][VIP] >= 1)
	{
	    strcat(string, "Level 1 Donor+: "col_w"/cc, /v, /vsay, /armor, /heal, /nrg\n");
	}
	if(pInfo[playerid][VIP] >= 2)
	{
	    strcat(string, ""col_y"");
	    strcat(string, "Level 2 Donor+: "col_w"/skin, /nos, /hyd, /time\n");
	}
	if(pInfo[playerid][VIP] >= 3)
	{
	    strcat(string, ""col_y"");
	    strcat(string, "Level 3 Donor+: "col_w"Level 1 and 2 CMDS, /weather, /car, /vpack, /hunter\n");
	}
	if(pInfo[playerid][VIP] >= 1)
	{
	    ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_y"V.I.P. Commands", string, "Close", "");
	}
	return 1;
}

CMD:hunter(playerid, params[])
{
	if(pInfo[playerid][VIP] >= 3 || pInfo[playerid][Admin] >= 2)
	{
		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);

		SpawnVehicle(playerid, 425, 1, 1, X, Y, Z, A, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		SendClientMessage(playerid, COLOR_LIGHTBLUE, "You have spawned a \"Hunter\" (Model: 425) with color 1,1");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:nrg(playerid, params[])
{
	if(pInfo[playerid][VIP] >= 1 || pInfo[playerid][Admin] >= 1)
	{
		new colour1, colour2, string[128];

		colour1=random(256);
		colour2=random(256);

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);

		SpawnVehicle(playerid, 522, colour1, colour2, X, Y, Z, A, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		format(string, sizeof(string), "You have spawned a \"NRG-500\" (Model: 522) with color %d,%d", colour1, colour2);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:car(playerid, params[])
{
	if(pInfo[playerid][VIP] >= 3 || pInfo[playerid][Admin] >= 2)
	{
		new carID[50], car, colour1, colour2, string[128];
		if(sscanf(params, "s[50]I(255)I(255)", carID, colour1, colour2)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /car [VehicleID(Name)] [Color1(Optional)] [Color2(Optional)]");
		if(!isnumeric(carID)) car = GetVehicleModelIDFromName(carID);
		else car = strval(carID);
		if(car < 400 || car > 611) return SendClientMessage(playerid, COLOR_PINK, "Invalid Vehicle Model ID!");

		if(colour1==255) colour1=random(256);
		if(colour2==255) colour2=random(256);

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);

		SpawnVehicle(playerid, car, colour1, colour2, X, Y, Z, A, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		format(string, sizeof(string), "You have spawned a \"%s\" (Model: %d) with color %d,%d", VehicleNames[car-400], car, colour1, colour2);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:fix(playerid, params[])
{
	if(gClass[playerid] == 4 || pInfo[playerid][Admin] >= 2 || pInfo[playerid][VIP] >= 3)
	{
 	    if((GetTickCount() - GetPVarInt(playerid, "AntiFix")) > 1000*60*2)
	    {
			new string[128], id;
			if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /fix [playerid]");
			if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");
			if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_PINK, "Player not in a vehicle.");

			format(string, sizeof(string), "%s has fixed your vehicle.", nameEx(playerid));
			SendClientMessage(id, COLOR_YELLOW, string);
			format(string, sizeof(string), "You fixed %s vehicle.", nameEx(id));
			SendClientMessage(playerid, -1, string);
			
			RepairVehicle(GetPlayerVehicleID(id));

			if(pInfo[playerid][Admin] < 2)
			{
				SetPVarInt(playerid, "AntiFix", GetTickCount());
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_PINK, "You have to wait for 2 minutes before using the fix command again.");
		}
	}
	return 1;
}

CMD:cc(playerid, params[]) return cmd_clearchat(playerid, params);

CMD:clearchat(playerid, params[])
{
	if(pInfo[playerid][Admin] >= 1)
	{
    	new string[135], reason[128];
    	sscanf(params, "s[128]", reason);
    	if(!strlen(reason)) format(reason, sizeof(reason), "No reason specified.");
		for(new i = 0; i < 100; i++)
		{
	    	SendClientMessageToAll(-1, " ");
		}
		format(string, sizeof(string), "Chat cleared, reason: %s", reason);
		SendClientMessageToAll(COLOR_GRAD1, string);
	}
	else
	{
		SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:colorcar(playerid, params[])
{
	if(pInfo[playerid][VIP] >= 1 || pInfo[playerid][Admin] >= 4)
	{
		new
			string[130],
			col1,
			col2
		;
		if(sscanf(params, "iI(255)", col1, col2)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /cc [playerid] [colour1] [colour2(optional)]");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_PINK, "You have to be in a vehicle to use this command");

		if(col2==255) col2=random(256);

		format(string, sizeof(string), "You have changed the color of your vehicle %s to '%d,%d'", nameEx(playerid), VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], col1, col2);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		ChangeVehicleColor(GetPlayerVehicleID(playerid), col1, col2);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:v(playerid, params[])
{
	new string[135];

	if(pInfo[playerid][VIP] >= 1)
	{
	    if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /v [chat]");

	    format(string, sizeof string, "[Donor Level %d %s: %s]", pInfo[playerid][VIP], nameEx(playerid), params);
	    SendAdminMessage(0xFFD70000, string);

	    print(string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:vsay(playerid, params[])
{
	new string[135];

	if(pInfo[playerid][VIP] >= 1)
	{
	    if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /vsay [message]");

	    format(string, sizeof string, "VIP Donor %s: %s", nameEx(playerid), params);
	    SendClientMessageToAll(0xFFD70000, string);

	    print(string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have the permission to access this command.");
	}
	return 1;
}

CMD:armor(playerid, params[])
{
	if(gClass[playerid] == 4 || gClass[playerid] == 7 || pInfo[playerid][VIP] >= 1)
	{
	    new id, string[135];

 	    if((GetTickCount() - GetPVarInt(playerid, "AntiArmor")) > 1000*60*4)
	    {
	    	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /armor [playerid]");
	    	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

			format(string, sizeof(string), "You have given Player %s an armour.", nameEx(id));
	        SendClientMessage(playerid, COLOR_LIME, string);
	        format(string, sizeof(string), "%s has given an armour to you.", nameEx(playerid));
	        SendClientMessage(id, COLOR_LIME, string);
	        SendClientMessage(playerid, -1, "You are now on a time period of 4 minutes before using this command again.");

	        SetPlayerArmour(id, 100.0);

			SetPVarInt(playerid, "AntiArmor", GetTickCount());
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_PINK, "You have to wait a time period of 4 minutes before using this command again.");
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have permission to use this command.");
	}
	return 1;
}

CMD:heal(playerid, params[])
{
	if(gClass[playerid] == 1 || gClass[playerid] == 7 || pInfo[playerid][VIP] >= 1)
	{
	    new id, string[135];

 	    if((GetTickCount() - GetPVarInt(playerid, "AntiHeal")) > 1000*60*4)
	    {
	    	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_WHITE, "{3399FF}Usage:{FFFFFF} /heal [playerid]");
	    	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_PINK, "Player not connected.");

			format(string, sizeof(string), "You have healed %s, restoring his HP back to 100.", nameEx(id));
	        SendClientMessage(playerid, COLOR_LIME, string);
	        format(string, sizeof(string), "%s has healed you, restoring your HP back to 100.", nameEx(playerid));
	        SendClientMessage(id, COLOR_LIME, string);
	        SendClientMessage(playerid, -1, "You are now on a time period of 4 minutes before using this command again.");

	        SetPlayerHealth(id, 100.0);

			SetPVarInt(playerid, "AntiHeal", GetTickCount());
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_PINK, "You have to wait a time period of 4 minutes before using this command again.");
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_PINK, "You do not have permission to use this command.");
	}
	return 1;
}

CMD:zone(playerid, params[])
{
	if(specialZone != -1)
	{
	    new string[128], id = specialZone;
	    format(string, sizeof(string), "Zone %s is the current bonus hot spot zone, Capture it for additional rewards.", zInfo[id][ZoneName]);
	    SendClientMessage(playerid, COLOR_CUSTOM, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_CUSTOM, "There is no current bonus hot spot zone.");
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

main()
{
	print("\n");
	print("Loading...");
	print("SAMP "SAMP_VERSION", State War Field "MINI_VERSION" by ShadyEG, JaKe Elite and FERCOPRO");
	print("Map set on the parts of Las Venturas & Desert.");
	print("Warning, Server contains strong explict content.");
	print("Loading...");
	print("\n");
}

public VehRes(vehicleid)
{
    DestroyVehicle(vehicleid);
}

public SpecialZone()
{
	new string[128];

	specialZone += 1;
	new id = specialZone;
	if(zInfo[id][Taken] == true)
	{
	    if(zInfo[id][zSpecial] == false)
	    {
	        zInfo[id][zSpecial] = true;
	        
	        format(string, sizeof(string), "* Zone %s is now a bonus zone, Capture it for more special rewards.", zInfo[id][ZoneName]);
	        SendClientMessageToAll(COLOR_CUSTOM, string);
	        print(string);
	    }
	    else
	    {
	        zInfo[id][zSpecial] = false;

			SpecialZone();
	    }
	}
	else
	{
	    specialZone = -1;
	    SpecialZone();
	}
}

public OnGameModeInit()
{
    ////////////////////////////////////////////////////////////////////////////

    mysql_debug(1);
    mysql_connect(mysql_host, mysql_user, mysql_database, mysql_password);
    bans = db_open("BansList.db");
	db_query(bans, "CREATE TABLE IF NOT EXISTS `BANNED` (`NAME`, `IP`, `REASON`, `ADMIN`, `DATE`, `TIME`)");
    if(mysql_ping() == 1)
    {
        mysql_debug(1);
        printf("[MYSQL] Connection with the database: SUCCESS!");
    }
    else
    {
        printf("[MYSQL] Connection with the database: FAIL!");
    }
    for(new i=0; i<10; i++)
    {
        TeamCapture[i] = 0; // No captured zones yet.
    }
    
    Initialize_Settings();
    Initialize_TD();
	Initialize_Object();
	Initialize_Gangzone();
	Initialize_Cars();
	Initialize_WarField();
	Initialize_Timer();
	Initialize_Shop();
	Initialize_MapIcon();
	Initialize_Labels();
	Initialize_Disables();

	fInfo[0][foldpos] = true;
	CreateFlag(0, TEAM_USA, 223.0202, 1861.2423, 13.1470);
	fInfo[1][foldpos] = true;
	CreateFlag(1, TEAM_ARAB, 406.9611, 2534.1736, 16.5465);
	
	EnableVehicleFriendlyFire();

    ////////////////////////////////////////////////////////////////////////////

	print("Initializing default hostname, gamemodetext, language, mapname...");

	SendRconCommand("hostname State War Field | TDM and Capture ("MINI_VERSION")");
	SetGameModeText("SWF:TDM "MINI_VERSION"");
	SendRconCommand("mapname LV/Desert");
	SendRconCommand("language English");
	
	print("Initializing Carl Johnson's Ped Animation...");
	
	UsePlayerPedAnims();
	
	////////////////////////////////////////////////////////////////////////////
	
	// Classes
	
	print("Initializing Player Classes...");
	
	AddPlayerClass(287, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0); // USA
	AddPlayerClass(73, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0); // Eurasia
	AddPlayerClass(179, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0); // Arabia
	AddPlayerClass(202, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0); // Australia
	AddPlayerClass(285, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0); // Soviet

	////////////////////////////////////////////////////////////////////////////
	return 1;
}

public OnGameModeExit()
{
	for(new x=0; x<MAX_WAR; x++)
	{
	    DestroyZone(x);
	    DestroyFlag(x);
	}
	
	db_close(bans);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	for(new i=0; i<8; i++)
	{
	    TextDrawShowForPlayer(playerid, MainMenu[i]);
	}

	inClass[playerid] = 1;
	
	SetPlayerColor(playerid, COLOR_GREY);

	PlayerTextDrawHide(playerid, Textdraw0);

	PlayerPlaySound(playerid, 1097, 219.4820, 1822.7864, 7.5271);

    SetPlayerPos(playerid, 219.4820,1822.7864,7.5271);
	SetPlayerCameraPos(playerid, 225.7349,1822.9067, 7.521);
	SetPlayerFacingAngle( playerid, 270);
	SetPlayerCameraLookAt(playerid, 219.4820,1822.7864,7.5271);
	
	SetTeam(playerid, classid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    CamTimer[playerid] = SetTimerEx("GTAV", 100, false, "i", playerid);
	new string [ 135 ];
	
	Initialize_PTD(playerid);
	GetPlayerIp(playerid, pInfo[playerid][IP], 16);
	
	KillTimer(Protection[playerid]);
	
	for (new x=0; x<MAX_WAR; x++)
	{
	    InCP[playerid][x] = 0;
	    Helping[playerid][x] = 0;
	}

	Initialize_WarFieldShow(playerid);
    Label[playerid] = CreateDynamic3DTextLabel("Blank", -1, 0.0, 0.0, -20, 25.0, playerid);
    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Label[playerid] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
	
	SetPlayerColor(playerid, COLOR_GREY);
	
	ClearMe(playerid);
	
	LoggedIn[playerid] = 0; pInfo[playerid][Admin] = 0; pInfo[playerid][VIP] = 0; pInfo[playerid][Money] = 30000; pInfo[playerid][Scores] = 0;
	pInfo[playerid][Kills] = 0; pInfo[playerid][Deaths] = 0; gTeam[playerid] = -1; inClass[playerid] = 1; Capture[playerid] = 0; protect[playerid] = 0;
	Spawn[playerid] = 0; gClass[playerid] = 0; aDuty[playerid] = 0; pInfo[playerid][Rank] = 0; pInfo[playerid][pCar] = -1; Warn[playerid] = 0;
	HeadShot[playerid] = false; pInfo[playerid][pHelmet] = 0; takeZone[playerid] = -1; LastPM[playerid] = INVALID_PLAYER_ID; flagPlayer[playerid] = -1;
	flagPlayer2[playerid] = -1; pInfo[playerid][userid] = -1; 

	format(string, sizeof(string), "[Connection] Player %s (ID: %d) has connected the server.", nameEx(playerid), playerid);
	SendClientMessageToAll(COLOR_GREY, string);

	SendClientMessage(playerid, -1, "Welcome to State War Field - "MINI_VERSION" for SAMP "SAMP_VERSION"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Credits to Shady, JaKe and Amy for scripting the main gamemode & it's running system.");
	SendClientMessage(playerid, COLOR_YELLOW, "Select a team you wish to be in, Once you are spawned, we will ask you which class would you like to choose.");

    new query[200];
    format(query, sizeof(query), "SELECT * FROM `users` WHERE `username` = '%s' LIMIT 1", nameEx(playerid));
    mysql_query(query); 
    mysql_store_result(); 
    new rows = mysql_num_rows();
    
    if(rows)
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""col_lb"Login", ""col_w"This account is registered to our database.\nInsert your password to login to your account.\n"col_r"If this is not your account, logged out and change your nickname.", "Login", "");
    }
    else
	{
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""col_lb"Register", ""col_w"This account is not registered to our database.\nEnter your own password to create a new account.", "Register", "");
  	}
	mysql_free_result();
	new Query[700], DBResult:Result;
	format(Query, sizeof(Query), "SELECT * FROM `BANNED` WHERE `NAME` = '%s' OR `IP` = '%s'", DB_Escape(GetName(playerid)), DB_Escape(PlayerIP(playerid))); // this checks if player's username is in "BANNED" table
	Result = db_query(bans, Query);
	if(db_num_rows(Result))
	{
		new banreason[50], bannedby[24], banname[24], banip[18];
 		db_get_field_assoc(Result, "REASON", banreason, sizeof(banreason)); db_get_field_assoc(Result, "ADMIN", bannedby, sizeof(bannedby));
		db_get_field_assoc(Result, "NAME", banname, sizeof(banname)); db_get_field_assoc(Result, "IP", banip, sizeof(banip));
		format(string, sizeof(string), "{FFFFFF}Our system has detected that your {FC4949}username or IP{FFFFFF} is {FC4949}banned.\n\n{FFFFFF}Name:{FC4949} %s\n{FFFFFF}IP:{FC4949} %s\n{FFFFFF}Banned by:{FC4949} %s\n{FFFFFF}Reason:{FC4949} %s\n\nIf you think this is a bugged, false ban or the admin abused his/her powers, Please post a ban appeal on our forums.\nMake sure to take a picture of this by pressing F8, Don't lie on your appeal.", banname, banip, bannedby, banreason);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FC4949}You are banned from this server.", string, "Close", ""), string = "\0";
		printf("%s has been kicked from OnPlayerConnect - Username ban detection", GetName(playerid));
		SetTimerEx("KickTimer", 75, false, "i", playerid);
		db_free_result(Result);
		string = "\0";
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new reason2 [ 100 ] = "null", string [ 128 ];

	KillTimer(Protection[playerid]);
	PlayerTextDrawDestroy(playerid, Textdraw0);

    if(pInfo[playerid][pCar] != -1) EraseVeh(pInfo[playerid][pCar]);

	Delete3DTextLabel(Label[playerid]);
	Label[playerid] = Text3D:INVALID_3DTEXT_ID;

	for(new i=0; i<8; i++)
	{
	    TextDrawHideForPlayer(playerid, MainMenu[i]);
	}

	if(playerCurVeh[playerid] != INVALID_PLAYER_ID)
 	if(vehicleDriver[playerCurVeh[playerid]] == playerid) vehicleDriver[playerCurVeh[playerid]] = INVALID_PLAYER_ID;

	switch( reason )
	{
	    case 0: reason2 = "Crash/Timeout";
	    case 1: reason2 = "Leaving";
	    case 2: reason2 = "Kick/Ban";
	}

	if(LoggedIn[playerid] == 1)
	{
        new query[600];
        format(query, sizeof(query), "UPDATE `users` SET `ip`='%s', `helmet`=%d, `admin`=%d, `vip`=%d, `scores`=%d, `money`=%d, `kills`=%d, `deaths`=%d, `rank`=%d WHERE `username`='%s'", pInfo[playerid][IP], pInfo[playerid][pHelmet], pInfo[playerid][Admin], pInfo[playerid][VIP], GetPlayerScore(playerid), GetPlayerMoney(playerid), pInfo[playerid][Kills], pInfo[playerid][Deaths], pInfo[playerid][Rank], nameEx(playerid));
        mysql_query(query);
		
		LoggedIn[playerid] = 0;
	}

	for(new x=0; x<100; x++)
	{
	    if(InCP[playerid][x] == 1)
	    {
			zInfo[x][UnderAttack] = 0;
			GangZoneStopFlashForAll(zInfo[x][Zone]);
	        zInfo[x][UnderAttack] = 0;
	        takeZone[playerid] = -1;
			InCP[playerid][x] = 0;
	    }
	}
	
	if(flagPlayer2[playerid] != -1)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

        RemovePlayerAttachedObject(playerid, 0);

		new id = flagPlayer2[playerid];

		for(new a=0; a<3; a++)
		{
		    fInfo[id][oFlag_Pos][a] = fInfo[id][flag_Pos][a];
		}

		fInfo[id][fTaken] = false;
		fInfo[id][HasIt] = INVALID_PLAYER_ID;
		fInfo[id][oTeam] = fInfo[id][TeamID];

        fInfo[id][foldpos] = false;
		CreateFlag(id, flagPlayer[playerid], x, y, z);

		format(string, sizeof(string), "* %s (%s) has failed to take the flag of %s back to their base. (Disconnected)", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
		SendClientMessageToAll(COLOR_CUSTOM, string);
		SendClientMessageToAll(COLOR_CUSTOM, "The flag has been dropped to the Player's location.");

		flagPlayer[playerid] = -1;
		flagPlayer2[playerid] = -1;
	}
	
	takeZone[playerid] = -1;

	format(string, sizeof(string), "[Connection] Player %s (ID: %d) has disconnected the server. (%s)", nameEx(playerid), playerid, reason2);
	SendClientMessageToAll(COLOR_GREY, string);
	return 1;
}

public KickTimer(playerid)
{
    Kick(playerid);
    return 1;
}

public KickMe(playerid)
{
	return Kick(playerid);
}

public OnPlayerSpawn(playerid)
{
 	new string [ 128 ];
	Spawn[playerid]++;
	if(Spawn[playerid] == 1)
	{
	    SendClientMessage(playerid, COLOR_LIGHTGREEN, "Select your class on the dialogue.");
	    ShowDialog(playerid, 0);
	}
	
	HeadShot[playerid] = false;
	
	PlayerPlaySound(playerid, 1098, 219.4820, 1822.7864, 7.5271);
	
	if(flagPlayer2[playerid] != -1)
	{
		SetPlayerAttachedObject(playerid, 0, 2914, 15, 0.014013, 0.077415, -0.424313, 354.422760, 358.421966, 92.942932, 1.000000, 1.000000, 1.000000 );
	}
	
	PlayerTextDrawShow(playerid, Textdraw0);
	
	SetPlayerTeamColor(playerid);
	SetPlayerSpawn(playerid);
	
	KillTimer(Protection[playerid]);
	
    SetPlayerHealth(playerid, 100000);
    
	Protection[playerid] = SetTimerEx("SpawnProtection", 15000, false, "d", playerid);
	protect[playerid] = 1;

	UpdateDynamic3DTextLabelText(Label[playerid], COLOR_LIME, "* Spawn Protection *");
	
	SendClientMessage(playerid, COLOR_LIME, "You are on spawn protection for 15 seconds, Any further damage will be blocked.");
	
	GangZoneShowForPlayer(playerid, GZ_USA, COLOR_USA);
	GangZoneShowForPlayer(playerid, GZ_EURASIA, COLOR_EURASIA);
	GangZoneShowForPlayer(playerid, GZ_ARAB, COLOR_ARAB);
	GangZoneShowForPlayer(playerid, GZ_AUSTRALIA, COLOR_AUSTRALIA);
	GangZoneShowForPlayer(playerid, GZ_SOVIET, COLOR_SOVIET);
	
	format(string, sizeof(string), "News: "col_w"%s", servermotdUpdate);
	SendClientMessage(playerid, COLOR_UPDATE, string);
	
	printf("Player %s spawned.", nameEx(playerid));
	return 1;
}

public SpawnProtection(playerid)
{
	Initialize_Spawn(playerid);
	RankUp(playerid);

	protect[playerid] = 0;
	SetPlayerHealth(playerid, 100);
	return SendClientMessage(playerid, COLOR_REALRED, "Your spawn protection is over, You can be killed - Your damage will no longer be blocked.");
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
    if(protect[damagedid] == 1)
    {
	    GameTextForPlayer(playerid, "~r~Shots Blocked", 3000, 3);
	    SendClientMessage(playerid, COLOR_REALRED, "Player is on spawn protection, Any shots you have given to the player will be blocked.");
	    return 0;
	}

	if(aDuty[damagedid] == 1)
	{
	    GameTextForPlayer(playerid, "~r~Shots Blocked~n~~g~On-Duty Admin", 3000, 3);
	    SendClientMessage(playerid, COLOR_REALRED, "Your shot to that on duty admin has been blocked.");
	    return 0;
	}

	if(protect[playerid] == 1)
	{
	    GameTextForPlayer(playerid, "~r~Shots Blocked", 3000, 3);
	    SendClientMessage(playerid, COLOR_REALRED, "You are on spawn protection, Any shots you have given to the player will be blocked.");
	    return 0;
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	new Float:HP;
	new string[128];

    if(issuerid != INVALID_PLAYER_ID)
    {
        if(weaponid >= 22 && weaponid <= 34)
        {
            if(protect[playerid] == 0 || aDuty[playerid] == 0)
            {
		        if(bodypart == 9)
		        {
		            if(pInfo[playerid][pHelmet] == 0)
		            {
			            if(HeadShot[playerid] == false)
			            {
							format(string, sizeof(string), "You have instantly killed Player %s (%d) by shooting him in the head.", nameEx(playerid), playerid);
							SendClientMessage(issuerid, COLOR_LIME, string);
							SendClientMessage(issuerid, COLOR_YELLOW, "You received +2 score for that along with $1000.");

							SendClientMessage(playerid, COLOR_REALRED, "You have been shot in the head and instantly dies.");

							GivePlayerMoney(issuerid, 1000);
							SetPlayerScore(issuerid, GetPlayerScore(issuerid) + 2);

							GameTextForPlayer(playerid, "~r~Headshot!", 3000, 3);
							GameTextForPlayer(issuerid, "~r~Headshot!", 3000, 3);

							SetPlayerArmour(playerid, 0.0);
					        SetPlayerHealth(playerid, 0.0);
					        HeadShot[playerid] = true;

					        // Double Sonds for Headshot
					        PlayerPlaySound(issuerid, 17802, 0, 0, 0);
					        PlayerPlaySound(issuerid, 17802, 0, 0, 0);
					        PlayerPlaySound(issuerid, 17802, 0, 0, 0);
						}
					}
					else
					{
					    SendClientMessage(issuerid, COLOR_REALRED, "Player is wearing a helmet, Any possible headshot is being protected by the helmet, FAILED.");
					}
				}
			}
		}

		if(protect[playerid] == 0 || aDuty[playerid] == 0)
		{
        	PlayerPlaySound(issuerid, 17802, 0, 0, 0);
		}
    }
	GetPlayerHealth(playerid, HP);
	if(weaponid == 24) SetPlayerHealth(playerid, HP-50);//DesertEagle
    if(weaponid == 22) SetPlayerHealth(playerid, HP-50);//Colt45
    if(weaponid == 32) SetPlayerHealth(playerid, HP-10);//Tec9
    if(weaponid == 28) SetPlayerHealth(playerid, HP-10);//Uzi
    if(weaponid == 31) SetPlayerHealth(playerid, HP-35);//M4
    if(weaponid == 30) SetPlayerHealth(playerid, HP-40);//AK
    if(weaponid == 29) SetPlayerHealth(playerid, HP-18);//MP5
    if(weaponid == 25) SetPlayerHealth(playerid, HP-100);//PumpShotgun
    if(weaponid == 27) SetPlayerHealth(playerid, HP-70);//Spaz12
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new string[128];

	if(killerid != INVALID_PLAYER_ID)
	{
	    pInfo[killerid][Kills] ++;
	    
	    new random2 = random(3000);
	    
		switch(random2)
		{
		    case 0..900: random2 = random(3000);
		}
	    
	    format(string, sizeof string, "You have killed %s(%d).", nameEx(playerid), playerid);
	    SendClientMessage(killerid, COLOR_LIGHTGREEN, string);
	    format(string, sizeof string, "You received a 1+ score && %d$", random2);
	    SendClientMessage(killerid, COLOR_LIGHTGREEN, string);
	    
	    SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	    GivePlayerMoney(killerid, random2);
	    
	    RankUp(killerid);
	}
	
	if(flagPlayer2[playerid] != -1)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

        RemovePlayerAttachedObject(playerid, 0);

		new id = flagPlayer2[playerid];

		for(new a=0; a<3; a++)
		{
		    fInfo[id][oFlag_Pos][a] = fInfo[id][flag_Pos][a];
		}

		fInfo[id][fTaken] = false;
		fInfo[id][HasIt] = INVALID_PLAYER_ID;
		fInfo[id][oTeam] = fInfo[id][TeamID];

        fInfo[id][foldpos] = false;
		CreateFlag(id, flagPlayer[playerid], x, y, z);

		format(string, sizeof(string), "* %s (%s) has failed to take the flag of %s back to their base. (Died)", nameEx(playerid), GetTeam(playerid), GetTeamEx(flagPlayer2[playerid]));
		SendClientMessageToAll(COLOR_CUSTOM, string);
		SendClientMessageToAll(COLOR_CUSTOM, "The flag has been dropped to the Player's location.");

		SendClientMessage(playerid, -1, "You failed to take the flag back to your base.");

		flagPlayer[playerid] = -1;
		flagPlayer2[playerid] = -1;
	}
				
	protect[playerid] = 0;
	KillTimer(Protection[playerid]);
	
	if(pInfo[playerid][pHelmet] == 1)
	{
	    SendClientMessage(playerid, -1, "You have lost your 'helmet' accessory.");
	}
	pInfo[playerid][pHelmet] = 0;
	pInfo[playerid][Deaths] ++;
	
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "A cash of $635 has been deducted to your death.");
	GivePlayerMoney(playerid, -635);
	
	SendDeathMessage(killerid, playerid, reason);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	foreach(new i : Player)
	{
        if(vehicleid == pInfo[i][pCar])
		{
		    EraseVeh(vehicleid);
	        pInfo[i][pCar] = -1;
        }
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string [ 128+50 ];
	ChatLog(playerid, text);
	if(stringContainsIP(text)){
	SendClientMessage(playerid, COLOR_RED, "Error:{FFFFFF} Text blocked for advertising.");
	}

	format(string, sizeof(string), "(%d) %s: "col_w"%s", playerid, nameEx(playerid), text);
	SendClientMessageToAll(GetPlayerColor(playerid), string);
	
	printf("(%d) %s: %s", playerid, nameEx(playerid), text);
	
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 6000);
	return 0;
}

public OnQueryError(errorid, error[], resultid, extraid, callback[], query[], connectionHandle)
{
	switch(errorid)
	{
		case CR_COMMAND_OUT_OF_SYNC:
		{
			printf("Commands out of sync for thread ID: %d",resultid);
		}
		case ER_SYNTAX_ERROR:
		{
			printf("Something is wrong in your syntax, query: %s",query);
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vid = GetPlayerVehicleID(playerid);

	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(IsAHelicopter(vid) || IsAPlane(vid))
	    {
	    	if(gClass[playerid] == 3 || gClass[playerid] == 7)
	    	{
	    	}
	    	else
			{
			    RemovePlayerFromVehicle(playerid);
			    SetCameraBehindPlayer(playerid);
			    SendClientMessage(playerid, COLOR_PINK, "You have to be in the Pilot class in order to fly this vehicle.");
			}
		}
		if(GetVehicleModel(vid) == 432 || GetVehicleModel(vid) == 406 || GetVehicleModel(vid) == 606)
		{
	    	if(gClass[playerid] == 3 || gClass[playerid] == 7)
	    	{
	    	}
	    	else
			{
			    RemovePlayerFromVehicle(playerid);
			    SetCameraBehindPlayer(playerid);
			    SendClientMessage(playerid, COLOR_PINK, "You have to be in the Engineer class in order to drive this vehicle.");
		    }
		}
		
		SetPlayerArmedWeapon(playerid, 0);
	}
	
	if(newstate == PLAYER_STATE_DRIVER)
	{
 		if(GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
 		{
			vehicleDriver[GetPlayerVehicleID(playerid)] = playerid;
            playerCurVeh[playerid] = GetPlayerVehicleID(playerid);
   		}
   	}
   	else if(oldstate == PLAYER_STATE_DRIVER)
   		{
        	if(playerCurVeh[playerid] != INVALID_VEHICLE_ID)
			{
   				if(vehicleDriver[playerCurVeh[playerid]] == playerid) vehicleDriver[playerCurVeh[playerid]] = INVALID_PLAYER_ID;
       			playerCurVeh[playerid] = INVALID_VEHICLE_ID;
        	}
	   	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new wID = weaponid;
	new Float:vHealth; GetVehicleHealth(hitid, vHealth);

	if(hittype == 2 && !IsDriverAvailable(hitid) && vHealth > 249)
	{
 		if(IsAirModel(GetVehicleModel(hitid)) == 1)
 		{
		 	switch(wID)
 		    {
 		        case 22, 29: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
				case 23: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
    			case 24, 38: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
       			case 25, 26: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
                case 27: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
                case 28, 32: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
                case 30, 31: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
                case 33: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
                case 34: SetVehicleHealth(hitid, vHealth - AirDamage[wID]);
		 	}
   		}
		else
		{
			switch(wID)
 		    {
 		        case 22, 29: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
				case 23: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
    			case 24, 38: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
       			case 25, 26: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
                case 27: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
                case 28, 32: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
                case 30, 31: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
                case 33: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
                case 34: SetVehicleHealth(hitid, vHealth - VehDamage[wID]);
          	}
		}
 	    new vModel = GetVehicleModel(hitid);
		new Float:hX, Float:hY, Float:hZ, Float:rX, Float:rY, Float:rZ;
		GetVehicleModelInfo(vModel, VEHICLE_MODEL_INFO_WHEELSFRONT, hX, hY, hZ);
		GetVehicleModelInfo(vModel, VEHICLE_MODEL_INFO_WHEELSREAR, rX, rY, rZ);
		new panels, doors, lights, tires;

 		if( fX >= hX - 3.0 && fX <= hX + 0.0 &&
		 	fY >= hY - 0.5 && fY <= hY + 0.5 &&
		  	fZ >= hZ - 0.5 && fZ <= hZ + 0.5 )
		{
	    	GetVehicleDamageStatus(hitid, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(hitid, panels, doors, lights,(tires | 0b1000));
		}
		if( fX >= hX - 0.5 && fX <= hX + 0.5 &&
		 	fY >= hY - 0.5 && fY <= hY + 0.5 &&
		  	fZ >= hZ - 0.5 && fZ <= hZ + 0.5 )
		{
	    	GetVehicleDamageStatus(hitid, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(hitid, panels, doors, lights, (tires | 0b0010));
 		}
    	if( fX >= rX - 3.0 && fX <= rX + 0.0 &&
		 	fY >= rY - 0.5 && fY <= rY + 0.5 &&
		  	fZ >= rZ - 0.5 && fZ <= rZ + 0.5 )
		{
        	GetVehicleDamageStatus(hitid, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(hitid, panels, doors, lights, (tires | 0b0100));
 		}
    	if( fX >= rX - 0.5 && fX <= rX + 0.5 &&
		 	fY >= rY - 0.5 && fY <= rY + 0.5 &&
		  	fZ >= rZ - 0.5 && fZ <= rZ + 0.5 )
		{
	    	GetVehicleDamageStatus(hitid, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(hitid, panels, doors, lights, (tires | 0b0001));
		}
	}
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new string[135];

	if(IsPlayerInAnyVehicle(playerid))
	{
	    SendClientMessage(playerid, COLOR_PINK, "You cannot take a flag whilist on a vehicle.");
	    return 0;
	}
	
	for(new x=0; x<MAX_WAR; x++)
	{
	    if(fInfo[x][fTaken] == true)
	    {
	        if(pickupid == fInfo[x][flagPickup])
	        {
	            if(flagPlayer2[playerid] != -1)
	            {
	                SendClientMessage(playerid, COLOR_PINK, "You cannot handle a lot of flags, You can only steal one.");
	                return 1;
	            }
	        
	            if(fInfo[x][TeamID] == gTeam[playerid])
	            {
	                if(fInfo[x][foldpos] == true) return SendClientMessage(playerid, COLOR_PINK, "The flag is already on your base!");
	            
					format(string, sizeof(string), "WARNING: %s got their flags back, they are now bringing it back to their base (%s).", nameEx(playerid), GetTeam(playerid));
					SendClientMessageToAll(COLOR_CUSTOM, string);

		            DestroyDynamic3DTextLabel(fInfo[x][fLabel]);
		            DestroyDynamicMapIcon(fInfo[x][fMap]);
		            DestroyDynamicPickup(fInfo[x][flagPickup]);
		            fInfo[x][HasIt] = playerid;
	         		SetPlayerAttachedObject(playerid, 0, 2914, 15, 0.014013, 0.077415, -0.424313, 354.422760, 358.421966, 92.942932, 1.000000, 1.000000, 1.000000 );

					SendClientMessage(playerid, -1, "Take your team's stolen flag back to your base before it's too late!");

					flagPlayer[playerid] = fInfo[x][TeamID];
					flagPlayer2[playerid] = x;
	            }
	            else
	            {
		            DestroyDynamic3DTextLabel(fInfo[x][fLabel]);
		            DestroyDynamicMapIcon(fInfo[x][fMap]);
		            DestroyDynamicPickup(fInfo[x][flagPickup]);
		            fInfo[x][HasIt] = playerid;
	         		SetPlayerAttachedObject(playerid, 0, 2914, 15, 0.014013, 0.077415, -0.424313, 354.422760, 358.421966, 92.942932, 1.000000, 1.000000, 1.000000 );

					format(string, sizeof(string), "WARNING: %s has the flags of %s and going to send it to %s.", nameEx(playerid), GetTeamEx(fInfo[x][TeamID]), GetTeam(playerid));
					SendClientMessageToAll(COLOR_CUSTOM, string);

					SendClientMessage(playerid, -1, "Take it back to your base quickly before the enemy got their flag back!");

					flagPlayer[playerid] = fInfo[x][TeamID];
					flagPlayer2[playerid] = x;
				}
	        }
	    }
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new string[135];

	if(IsPlayerInAnyVehicle(playerid))
	{
	    SendClientMessage(playerid, COLOR_PINK, "You cannot capture a zone whilist on a vehicle.");
	    return 0;
	}

	for(new x=0; x<MAX_WAR; x++)
	{
	    if(zInfo[x][Taken] == true)
	    {
	        if(checkpointid == zInfo[x][CP])
	        {
				if(zInfo[x][tCP] == gTeam[playerid])
				{
					SendClientMessage(playerid, COLOR_REALRED, "This zone is already captured by your team!");
					return 1;
				}
				if(zInfo[x][UnderAttack] == 1)
				{
				    if(gTeam[zInfo[x][zAttacker]] == gTeam[playerid])
				    {
						Helping[playerid][x] = 1;

						format(string, sizeof(string), "WARNING: %s is now helping his team-mate %s on capturing the %s.", nameEx(playerid), nameEx(zInfo[x][zAttacker]), zInfo[x][ZoneName]);
						SendClientMessageToAll(COLOR_CUSTOM, string);
					}
					else
					{
					    SendClientMessage(playerid, COLOR_PINK, "You cannot help a rival team on capturing a zone.");
					}
				}
				else
				{
				    Capture[playerid] = 1;

					zInfo[x][UnderAttack] = 1;

					CountTime[x] = SetTimerEx("CountDown", 1000, true, "i", playerid, x);

					zInfo[x][zAttacker] = playerid;
					InCP[playerid][x] = 1;
					zInfo[x][Captured] = 0;
					takeZone[playerid] = x;

					GangZoneFlashForAll(zInfo[x][Zone], GetZoneColor(gTeam[playerid]));

					format(string, sizeof(string), "WARNING: %s is now attempting to capture the %s for %s from the hands of %s.", nameEx(playerid), zInfo[x][ZoneName], GetTeam(playerid), GetTeamEx(zInfo[x][tCP]));
					SendClientMessageToAll(COLOR_CUSTOM, string);
				}
	        }
	    }
	}
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	new string[128];

	if(Capture[playerid] != 1) return 0;

	for(new x=0; x<MAX_WAR; x++)
	{
	    if(zInfo[x][Taken] == true)
	    {
			if(checkpointid == zInfo[x][CP])
			{
			    if(Capture[playerid] == 1)
			    {
					SendClientMessage(playerid, COLOR_REALRED, "You have left the checkpoint, You have failed to capture the specific zone!");
					zInfo[x][UnderAttack] = 0;
					InCP[playerid][x] = 0;
					GangZoneStopFlashForAll(zInfo[x][Zone]);
					KillTimer(CountTime[playerid]);

					Capture[playerid] = 0;
					takeZone[playerid] = -1;

					format(string, sizeof(string), "** %s (%s) has failed to capture the %s from the hands of %s.", nameEx(playerid), GetTeam(playerid), zInfo[x][ZoneName], GetTeamEx(zInfo[x][tCP]));
					SendClientMessageToAll(COLOR_CUSTOM, string);
				}
				else
				{
				    foreach(new i : Player)
				    {
						if(Helping[i][x] == 1)
						{
							SendClientMessage(playerid, COLOR_PINK, "You are no longer helping your team-mate on capturing the zone.");
							Helping[i][x] = 0;
						}
					}
				}
			}
		}
	}
	return 1;
}

public SetCaptureZone(playerid)
{
	new string[128];

	for(new x=0; x<MAX_WAR; x++)
	{
	    if(takeZone[playerid] == x)
	    {
	        new id = takeZone[playerid];
	        if(zInfo[id][Taken] == true)
	        {
				SetPlayerScore(playerid, GetPlayerScore(playerid)+3);
				GivePlayerMoney(playerid, 2000);
				format(string, sizeof string, "Congratulations, You have successfully captured the %s, You earned +2 score and +$2000", zInfo[id][ZoneName]);
				SendClientMessage(playerid, COLOR_LIME, string);

				foreach(new i : Player)
				{
				    if(zInfo[id][tCP] == gTeam[i])
				    {
				        format(string, sizeof string, "Your team lost the %s, a cash of $500 has been deducted.", zInfo[id][ZoneName]);
						SendClientMessage(i, -1, string);
						GivePlayerMoney(i, -500);
				    }

				    if(gTeam[playerid] == gTeam[i] && i != playerid)
				    {
				        format(string, sizeof string, "Your team has captured the %s, a cash of $1000 has been added.", zInfo[id][ZoneName]);
						SendClientMessage(i, -1, string);
						GivePlayerMoney(i, 1000);
				    }
				}

				if(zInfo[id][zSpecial] == true)
				{
				    SendClientMessage(playerid, -1, "You get an extra score of +3, cash +$2000 and a MP5 as a special reward from the zone.");
				    
				    GivePlayerWeapon(playerid, 29, 1000);
				    
				    GivePlayerMoney(playerid, 2000);
				    SetPlayerScore(playerid, GetPlayerScore(playerid) + 3);
				}

				format(string, sizeof(string), "** the %s has successfully captured the %s from the hands of %s.", GetTeam(playerid), zInfo[id][ZoneName], GetTeamEx(zInfo[id][tCP]));
				SendClientMessageToAll(COLOR_CUSTOM, string);
				
				Capture[playerid] = 0;

				TeamCapture[gTeam[playerid]] ++;

				zInfo[id][UnderAttack] = 0;
				zInfo[id][tCP] = gTeam[playerid];

				GangZoneStopFlashForAll(zInfo[id][Zone]);

				GangZoneShowForAll(zInfo[id][Zone], GetZoneColor(gTeam[playerid]));

				zInfo[id][Captured] = 1;
				KillTimer(CountTime[playerid]);
				
				takeZone[playerid] = -1;
	        }
	    }
	}

	RankUp(playerid);
	return 1;
}

public CountDown(playerid, zoneid)
{
	CountVar[playerid]--;
	if(CountVar[playerid] <= 0)
	{
	    SetCaptureZone(playerid);
		foreach (new i : Player)
		{
			if(Helping[i][zoneid] == 1)
			{
                GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~g~Helping success!", 2000, 3);
                
				SendClientMessage(i, COLOR_LIME, "You received +2 scores and $2000 for helping a team-mate on capturing a zone.");
				
				GivePlayerMoney(i, 2000);
				SetPlayerScore(i, GetPlayerScore(i) + 2);
				
				Helping[i][zoneid] = 0;
			}
		}
	    
	    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~Captured!", 2000, 3);
	
		CountVar[zoneid] = 25;
		KillTimer(CountTime[zoneid]);
	}
	else if(CountVar[playerid] >= 1)
    {
		new str[124];

		foreach (new i : Player)
		{
			if(Helping[i][zoneid] == 1)
			{
				// Double the countdown.
				CountVar[zoneid] --;
				// The same message updates
				format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~r~Helping Capturing~w~...%d", CountVar[zoneid]);
				GameTextForPlayer(i, str, 1000, 3);
			}
		}

		format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~r~Capturing~w~...%d", CountVar[zoneid]);
		GameTextForPlayer(playerid, str, 1000, 3);
	}
    return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(LoggedIn[playerid] == 0)
	{
	    SendClientMessage(playerid, COLOR_LIME, "Info: "col_w"You cannot spawn whilist not registered or logged in.");
	    return  0;
	}

	new team1count = GetPlayersCountInTeam(TEAM_USA); 
	new team2count = GetPlayersCountInTeam(TEAM_EURASIA);
	new team3count = GetPlayersCountInTeam(TEAM_ARAB);
	new team4count = GetPlayersCountInTeam(TEAM_AUSTRALIA);
	new team5count = GetPlayersCountInTeam(TEAM_SOVIET);

	switch(gTeam[playerid]) 
	{
		case TEAM_USA:
		{
			if(team1count > team2count && team3count && team4count && team5count)
			{
				SendClientMessage(playerid, COLOR_REALRED, "This team is currently full!");
				return 0; 
			}
		}
		case TEAM_EURASIA:
		{
			if(team2count > team1count && team3count && team4count && team5count)
			{
				SendClientMessage(playerid, COLOR_REALRED, "This team is currently full!");
				return 0;
			}
		}
		case TEAM_ARAB:
		{
			if(team3count > team1count && team2count && team4count && team5count)
			{
				SendClientMessage(playerid, COLOR_REALRED, "This team is currently full!");
				return 0;
			}
		}
		case TEAM_AUSTRALIA:
		{
			if(team4count > team1count && team2count && team3count && team4count)
			{
				SendClientMessage(playerid, COLOR_REALRED, "This team is currently full!");
				return 0;
			}
		}
		case TEAM_SOVIET:
		{
			if(team5count > team1count && team2count && team3count && team4count && team5count)
			{
				SendClientMessage(playerid, COLOR_REALRED, "This team is currently full!");
				return 0;
			}
		}
	}
	
	Spawn[playerid] = 0;

	inClass[playerid] = 0;
	
	for(new i=0; i<8; i++)
	{
	    TextDrawHideForPlayer(playerid, MainMenu[i]);
	}
	
	ClearMe(playerid);
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public ForPlayer()
{
	foreach(new playerid : Player)
	{
		new string[256];
	    format(string, 256, "Rank: %s, Score: %d, Kills: %d, Deaths: %d, Team: %s, Class: %s", GetRank(playerid), GetPlayerScore(playerid), pInfo[playerid][Kills], pInfo[playerid][Deaths], GetTeam(playerid), GetClass(playerid));
	    PlayerTextDrawSetString(playerid, Textdraw0, string);

		if(GetPlayerPing(playerid) >= 1000)
		{
		    format(string, sizeof(string), "Hybrid has kicked %s (%d) due to high ping exceeding (%d/1000)", nameEx(playerid), playerid, GetPlayerPing(playerid));
		    SendClientMessageToAll(COLOR_REALRED, string);
		    KickDelay(playerid);
		}
	}
}

public OnPlayerUpdate(playerid)
{
	// Synced Goggles

	switch(GetPlayerWeapon(playerid))
	{
		case 44, 45:
		{
			new keys, ud, lr;
			GetPlayerKeys(playerid, keys, ud, lr);
			if((keys & KEY_FIRE) && (!IsPlayerInAnyVehicle(playerid)))
			{
				return 0;
			}
		}
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_HELP)
	{
	    new string[1000];
	
		if(response)
		{
		    switch(listitem)
		    {
		        case 0:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "You can earn score by killing, capturing zones (see more @ /help) or doing reaction-contest/activities.\n");
		            strcat(string, "You can rank up by earning the specific score for that rank - see /ranks for the list of the specific score for a rank.\n");
		            strcat(string, "You can earn money by killing, capturing zones (see more @ /help) or doing reaction-contest/activities.\n\n");
		            strcat(string, "Still don't get it? Call an admin for an assistance.");
		            
		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"How to earn score/rank/money?", string, "Close", "");
		        }
		        case 1:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "You can capture zones by standing on a red checkpoint with a flag on it.\n");
		            strcat(string, "You cannot capture zones which hasn't a flag on it (Since they are the main HQ of each team.)\n");
		            strcat(string, "You may not press ESC or AFK at the Checkpoint during the capture, You aren't also allowed to use vehicle on capturing.\n");
		            strcat(string, "Zones are one by one picked as Bonus Zone in each 5 minutes, You get a special reward once you captured one.");

		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"How to capture zones?", string, "Close", "");
		        }
		        case 2:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "You can become a staff by getting handpicked or by applying at our forum (SOON)\n");
		            strcat(string, "You may not beg for any of positions in the staff team, This would result of auto-denial or ban.\n");
		            strcat(string, "Once you got accepted on the application, You may contact the Executive Admin to set you to admin.\n");
		            strcat(string, "Your application will be reviewed afterwards when the Executive Admins aren't busy.");

		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"How to become a staff member?", string, "Close", "");
		        }
		        case 3:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "As you may notice, You cannot ride on some of the vehicles, They are class restricted.\n");
		            strcat(string, "E.G. You are Pilot, you can drive some regular vehicles + planes/helicopter, But not heavy vehicles.\n");
		            strcat(string, "You can list the classes which has the ability to drive a specific vehicle by using /abilities.\n");
		            strcat(string, "Donor Class has access to all vehicles, as it is included on their benefit of becoming a Donor.");

		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"How to use the restricted vehicles?", string, "Close", "");
		        }
		        case 4:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "You can refill your health, armour and etchetera at your HQ's Armoury Shop or at any HQ by typing /buy.\n");
		            strcat(string, "Donor Players has a benefit on /buy, Some stuffs are free for them, Specially the HP/Armour and Helmet.\n");
		            strcat(string, "You can also buy weapons at our Armoury Shop!");

		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"How to buy stuffs?", string, "Close", "");
		        }
		        case 5:
		        {
		            strcat(string, ""col_gy"");
		            strcat(string, "To add more enjoyment, We have added a flag system, Where in you can stole your enemies flag or reclaim your flag somewhere.\n");
		            strcat(string, "Stealing a flag costs a high score and money due to it's difficulties to stole it, You also get score/money on reclaiming it.\n");
		            strcat(string, "The untouched flags can be found at the HQ, and the touched ones can be found in the last stealer's position.\n");
		            strcat(string, "The flag has a colored marker of their team's color, with a label on it, The flag color is always green for each teams.\n");
		            strcat(string, "Once you got the flag, Head back to your HQ (YOUR HQ ONLY) and /placeflag on the specific point.");

		            ShowPlayerDialog(playerid, DIALOG_SHOW, DIALOG_STYLE_MSGBOX, ""col_lb"What are flags?", string, "Close", "");
		        }
		    }
		}
	}

	if(dialogid == DIALOG_STATS)
	{
	    new string[1000], id;

		if(response)
		{
		    switch(listitem)
		    {
		        case 0:
		        {
					new Float:ratio = (float(pInfo[id][Kills])/float(pInfo[id][Deaths]));
					format(string, sizeof string, "{007BD0}[Account]{D8D8D8} Account ID: %d | Name: %s (%d) | Rank: %s(%d) | Registration Date: %s", pInfo[id][userid], nameEx(id), id, GetRank(id), pInfo[id][Rank], pInfo[id][RegisterDate]);
					SendClientMessage(playerid, COLOR_WHITE, string);
					format(string, sizeof string, "{007BD0}[Details]{D8D8D8} Team: %s | Class: %s | Score: %d | Money: %d | Kills: %d | Deaths: %d | Ratio: %.3f", GetTeam(id), GetClass(id), GetPlayerScore(id), GetPlayerMoney(id), pInfo[id][Kills], pInfo[id][Deaths], ratio);
					SendClientMessage(playerid, COLOR_WHITE, string);
					format(string, sizeof string, "{007BD0}[Positions]{D8D8D8} Admin level: %d, VIP level: %d", pInfo[id][Admin], pInfo[id][VIP]);
					SendClientMessage(playerid, COLOR_WHITE, string);
		        }
			}
		}
	}
	
	if(dialogid == DIALOG_SHOP)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(pInfo[playerid][VIP] != 3)
	                {
	                	if(GetPlayerMoney(playerid) < 6500) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
	                }

	                SetPlayerHealth(playerid, 100.0);

	                if(pInfo[playerid][VIP] >= 3)
	                {
						SendClientMessage(playerid, -1, "No charges has been made towards you, Donor Pass, HP refilled.");
	                }
	                else
	                {
	                    GivePlayerMoney(playerid, -5000);
	                    SendClientMessage(playerid, -1, "$5,000 has been charged to you for the HP refill.");
	                }
	            }
	            case 1:
	            {
	                if(pInfo[playerid][VIP] != 3)
	                {
	                	if(GetPlayerMoney(playerid) < 6500) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
	                }

	                SetPlayerArmour(playerid, 100.0);

	                if(pInfo[playerid][VIP] >= 3)
	                {
						SendClientMessage(playerid, -1, "No charges has been made towards you, Donor Pass, Vest refilled.");
	                }
	                else
	                {
	                    GivePlayerMoney(playerid, -6500);
	                    SendClientMessage(playerid, -1, "$6,500 has been charged to you for the Vest refill.");
	                }
	            }
	            case 2:
	            {
                	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
                    GivePlayerMoney(playerid, -10000);
                    SendClientMessage(playerid, -1, "$10,000 has been charged to you for the Night Vision.");
                    GivePlayerWeapon(playerid, 44, 1);
	            }
	            case 3:
	            {
                	if(GetPlayerMoney(playerid) < 10000) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
                    GivePlayerMoney(playerid, -10000);
                    SendClientMessage(playerid, -1, "$10,000 has been charged to you for the Thermal Goggles.");
                    GivePlayerWeapon(playerid, 45, 1);
	            }
	            case 4:
	            {
                	if(GetPlayerMoney(playerid) < 800) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
                    GivePlayerMoney(playerid, -10000);
                    SendClientMessage(playerid, -1, "$800 has been charged to you for the Binoculars.");
                    GivePlayerWeapon(playerid, 43, 1);
	            }
	            case 5:
	            {
	                if(pInfo[playerid][VIP] != 3)
	                {
	                	if(GetPlayerMoney(playerid) < 7000) return SendClientMessage(playerid, COLOR_PINK, "You do not have the money to the buy this item.");
	                }

					pInfo[playerid][pHelmet] = 1;

	                if(pInfo[playerid][VIP] >= 3)
	                {
						SendClientMessage(playerid, -1, "No charges has been made towards you, Donor Pass, Helmet Accessory given.");
	                }
	                else
	                {
	                    GivePlayerMoney(playerid, -7000);
	                    SendClientMessage(playerid, -1, "$7,000 has been charged to you for the Helmet Accessory.");
	                }
	            }
	        }
	    }
	}
	if(dialogid == DIALOG_CLASS)
	{
		if(!response)
		{
		    ShowDialog(playerid, 0);
		}
		else
		{
		    switch(listitem)
		    {
		        // assault
		        case 0:
		        {
		            gClass[playerid] = 1;
		            SendClientMessage(playerid, -1, "You have choosen the class: Assault.");
		            SendClientMessage(playerid, COLOR_YELLOW, "You have the ability to /heal with a limit of 4 minutes waiting period.");
		            
		            if(pInfo[playerid][VIP] >= 2)
		            {
						switch(gTeam[playerid])
						{
			            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
			            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
			            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
			            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
			            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
						}
		            }
		        }
		        // sniper
		        case 1:
		        {
		            if(GetPlayerScore(playerid) < 50) return SendClientMessage(playerid, COLOR_PINK, "You need a score of 50 to use this class."), ShowDialog(playerid, 0);

		            gClass[playerid] = 2;
		            SendClientMessage(playerid, -1, "You have choosen the class: Sniper.");
		            SendClientMessage(playerid, COLOR_YELLOW, "Your marker cannot be seen on the map with this class.");

					switch(gTeam[playerid])
					{
		            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
		            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
		            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
		            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
		            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
					}
		        }
		        // pilot
		        case 2:
		        {
		            if(GetPlayerScore(playerid) < 2500) return SendClientMessage(playerid, COLOR_PINK, "You need a score of 2500 to use this class."), ShowDialog(playerid, 0);

		            gClass[playerid] = 3;
		            SendClientMessage(playerid, -1, "You have choosen the class: Pilot.");
		            SendClientMessage(playerid, COLOR_YELLOW, "Your class has ability to fly planes/hunters, So good luck on flying them.");

		            if(pInfo[playerid][VIP] >= 2)
		            {
						switch(gTeam[playerid])
						{
			            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
			            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
			            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
			            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
			            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
						}
		            }
		        }
		        // engineer
		        case 3:
		        {
		            if(GetPlayerScore(playerid) < 1500) return SendClientMessage(playerid, COLOR_PINK, "You need a score of 1500 to use this class."), ShowDialog(playerid, 0);

		            gClass[playerid] = 4;
		            SendClientMessage(playerid, -1, "You have choosen the class: Engineer.");
		            SendClientMessage(playerid, COLOR_YELLOW, "Your class has ability to drive Rhino/Heavy Vehicle, good luck on operating them.");

		            if(pInfo[playerid][VIP] >= 2)
		            {
						switch(gTeam[playerid])
						{
			            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
			            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
			            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
			            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
			            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
						}
		            }
		        }
		        // supporter
		        case 4:
		        {
		            if(GetPlayerScore(playerid) < 4500) return SendClientMessage(playerid, COLOR_PINK, "You need a score of 4500 to use this class."), ShowDialog(playerid, 0);
		        
		            gClass[playerid] = 5;
		            SendClientMessage(playerid, -1, "You have choosen the class: Supporter.");
		            SendClientMessage(playerid, COLOR_YELLOW, "You have the ability to /armor and /heal with a limit of 4 minutes waiting period.");

		            if(pInfo[playerid][VIP] >= 2)
		            {
						switch(gTeam[playerid])
						{
			            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
			            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
			            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
			            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
			            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
						}
		            }
		        }
		        // demolisher
		        case 5:
		        {
		            if(GetPlayerScore(playerid) < 6000) return SendClientMessage(playerid, COLOR_PINK, "You need a score of 6000 to use this class."), ShowDialog(playerid, 0);

		            gClass[playerid] = 6;
		            SendClientMessage(playerid, -1, "You have choosen the class: Demolisher.");
		            SendClientMessage(playerid, COLOR_YELLOW, "You have the ability to /plant and /def with a limit of 4 minutes waiting period.");

		            if(pInfo[playerid][VIP] >= 2)
		            {
						switch(gTeam[playerid])
						{
			            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
			            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
			            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
			            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
			            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
						}
		            }
		        }
		        // donor
		        case 6:
		        {
		            if(pInfo[playerid][VIP] != 3) return SendClientMessage(playerid, COLOR_PINK, "You need to be at least a VIP Level 3 donor to access this class."), ShowDialog(playerid, 0);
		        
		            gClass[playerid] = 7;
		            SendClientMessage(playerid, -1, "You have choosen the class: Donor (SPECIAL).");
		            SendClientMessage(playerid, COLOR_YELLOW, "Your class has a capability of all the combined classes/Free Armoury on spawn/No payments of the HP-Armor in /buy (Limited)");
					SendClientMessage(playerid, COLOR_YELLOW, "You also have a hidden marker on the map.");
					
					switch(gTeam[playerid])
					{
		            	case TEAM_USA: SetPlayerColor(playerid, COLOR_USAS);
		            	case TEAM_EURASIA: SetPlayerColor(playerid, COLOR_EURASIAS);
		            	case TEAM_ARAB: SetPlayerColor(playerid, COLOR_ARABS);
		            	case TEAM_AUSTRALIA: SetPlayerColor(playerid, COLOR_AUSTRALIAS);
		            	case TEAM_SOVIET: SetPlayerColor(playerid, COLOR_SOVIETS);
					}
				}
		    }
		}
	}

	if(dialogid == DIALOG_REGISTER)
	{
	    if(!response)
	    {
        	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""col_lb"Register", ""col_w"This account is not registered to our database.\nEnter your own password to create a new account.", "Register", "");
	    }
		else
		{
			if(strlen(inputtext) < 4 || strlen(inputtext) > 15)
			{
        		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""col_lb"Register", ""col_w"This account is not registered to our database.\nEnter your own password to create a new account.\n"col_r"Invalid Password Length (4 to 15 lengths)", "Register", "");
			    return 1;
			}

            new escpass[100];
            mysql_real_escape_string(inputtext, escpass);
            RegisterPlayer(playerid, escpass);

			LoggedIn[playerid] = 1;
			return 1;
		}
	}
	if(dialogid == DIALOG_LOGIN)
	{
	    if(!response)
	    {
	        ClearMe(playerid);
			SendClientMessage(playerid, COLOR_REALRED, "You have been kicked after refusing to login.");
			KickDelay(playerid);
	    }
		else
		{
            new query[200], escapepass[100];
            mysql_real_escape_string(inputtext, escapepass); 
            format(query, sizeof(query), "SELECT `username` FROM `users` WHERE `username` = '%s' AND `password` = SHA1('%s')", nameEx(playerid), escapepass);
            mysql_query(query);
            mysql_store_result();
            new numrows = mysql_num_rows();
            if(numrows)
			{
				LoginPlayer(playerid);
			}
			else
            {
        		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""col_lb"Login", ""col_w"This account is registered to our database.\nInsert your password to login to your account.\n"col_r"If this is not your account, logged out and change your nickname.\nIncorrect Password inserted.", "Login", "");
            }
            mysql_free_result();
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
//==============================================================================
forward GTAV(playerid);
public GTAV(playerid)
{
	if(Stage[playerid] == 1)
	{
  		KillTimer(CamTimer[playerid]);
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, x, y, z+100);
		SetPlayerCameraLookAt(playerid, x, y, z);
		Stage[playerid] = 2;
  		CamTimer[playerid] = SetTimerEx("GTAV", 1000, true, "i", playerid);
	}
	else if(Stage[playerid] == 2)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, x, y, z+75);
		SetPlayerCameraLookAt(playerid, x, y, z);
		Stage[playerid] = 3;
	}
	else if(Stage[playerid] == 3)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, x, y, z+50);
		SetPlayerCameraLookAt(playerid, x, y, z);
		Stage[playerid] = 4;
	}
	else if(Stage[playerid] == 4)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, x, y, z+25);
		SetPlayerCameraLookAt(playerid, x, y, z);
		Stage[playerid] = 5;
	}
	else if(Stage[playerid] == 5)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCameraPos(playerid, x, y, z+10);
		SetPlayerCameraLookAt(playerid, x, y, z);
		Stage[playerid] = 6;
	}
	else if(Stage[playerid] == 6)
	{
		SetCameraBehindPlayer(playerid);
		Stage[playerid] = 0;
		KillTimer(CamTimer[playerid]);
	}
	return 1;
}
//==============================================================================
public OnRevCTRLHTTPResponse(index, response_code, data[]) {
	if (response_code != 200) {
		return ShowPlayerDialog(index, DIALOG_CHANGES, DIALOG_STYLE_MSGBOX, ""col_up"Updates | 1 of 1", "{FFFFFF}An error has occurred, try again later.", "Okay", "");
	}
	return ShowPlayerDialog(index, DIALOG_CHANGES, DIALOG_STYLE_MSGBOX, ""col_up"Updates | 1 of 1", data, "Okay", "");
}

#if !defined USER_PROJECT
 #error Define USER_PROJECT with your {username}/{project codename}.
#endif

#if !defined PROJECT_ID
 #error Define your project id. Find it on your RevCTRL project's about page.
#endif
//==============================================================================
