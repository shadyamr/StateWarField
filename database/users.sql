-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 26, 2015 at 07:30 AM
-- Server version: 5.6.21
-- PHP Version: 5.5.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sfw`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`userid` int(10) NOT NULL,
  `username` varchar(24) NOT NULL,
  `password` varchar(41) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `registerdate` varchar(90) NOT NULL,
  `helmet` int(10) NOT NULL,
  `admin` int(10) NOT NULL,
  `vip` int(10) NOT NULL,
  `money` int(15) NOT NULL,
  `scores` int(10) NOT NULL,
  `kills` int(10) NOT NULL,
  `deaths` int(10) NOT NULL,
  `rank` int(10) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userid`, `username`, `password`, `ip`, `registerdate`, `helmet`, `admin`, `vip`, `money`, `scores`, `kills`, `deaths`, `rank`) VALUES
(3, 'Vanessa_Hudson', '0d77af0b32aa76511f46641da7912cc7819f6d1f', '192.168.1.100', '03/26/2015', 1, 5, 5, 37317, 8, 0, 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`userid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `userid` int(10) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
