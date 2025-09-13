 -- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2025 at 03:07 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `attendance_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `employee_name` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `employee_id`, `employee_name`, `department`, `date`, `check_in`, `check_out`, `status`) VALUES
(1, 1, NULL, NULL, '2025-08-22', '2025-08-22 10:28:31', '2025-08-22 18:16:04', 'Present'),
(2, 1, NULL, NULL, '2025-08-22', '2025-08-22 10:49:31', '2025-08-22 18:16:04', 'Present'),
(3, 1, NULL, NULL, '2025-08-22', '2025-08-22 10:56:42', '2025-08-22 18:16:04', 'Present'),
(4, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:02:58', '2025-08-22 18:16:04', 'Present'),
(5, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:03:41', '2025-08-22 18:16:04', 'Present'),
(6, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:13:45', '2025-08-22 18:16:04', 'Present'),
(7, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:16:22', '2025-08-22 18:16:04', 'Present'),
(8, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:20:09', '2025-08-22 18:16:04', 'Present'),
(9, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:22:36', '2025-08-22 18:16:04', 'Present'),
(10, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:23:24', '2025-08-22 18:16:04', 'Present'),
(11, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:24:05', '2025-08-22 18:16:04', 'Present'),
(12, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:25:19', '2025-08-22 18:16:04', 'Present'),
(13, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:25:50', '2025-08-22 18:16:04', 'Present'),
(14, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:31:41', '2025-08-22 18:16:04', 'Present'),
(15, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:31:41', '2025-08-22 18:16:04', 'Present'),
(16, 1, NULL, NULL, '2025-08-22', '2025-08-22 11:42:25', '2025-08-22 18:16:04', 'Present'),
(17, 1, NULL, NULL, '2025-08-22', '2025-08-22 12:02:57', '2025-08-22 18:16:04', 'Present'),
(18, 5, NULL, NULL, '2025-08-22', '2025-08-22 16:47:25', '2025-08-22 17:41:44', 'Present'),
(19, 5, NULL, NULL, '2025-08-22', '2025-08-22 16:53:25', '2025-08-22 17:41:44', 'Present'),
(20, 5, NULL, NULL, '2025-08-22', '2025-08-22 16:59:12', '2025-08-22 17:41:44', 'Present'),
(21, 5, 'vivek', NULL, '2025-08-22', '2025-08-22 17:01:46', '2025-08-22 17:41:44', 'Present'),
(22, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:10:00', '2025-08-22 17:41:44', 'Present'),
(23, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:16:02', '2025-08-22 17:41:44', 'Present'),
(24, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:16:40', '2025-08-22 17:41:44', 'Present'),
(25, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:27:35', '2025-08-22 17:41:44', 'Present'),
(26, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:36:20', '2025-08-22 17:41:44', 'Present'),
(27, 5, 'vivek', 'Engineering', '2025-08-22', '2025-08-22 17:41:39', '2025-08-22 17:41:44', 'Present'),
(28, 1, 'Chahat Rana', 'IT', '2025-08-22', '2025-08-22 17:52:35', '2025-08-22 18:16:04', 'Present'),
(29, 1, 'Chahat Rana', 'IT', '2025-08-22', '2025-08-22 18:04:26', '2025-08-22 18:16:04', 'Present'),
(30, 1, 'Chahat Rana', 'IT', '2025-08-22', '2025-08-22 18:05:37', '2025-08-22 18:16:04', 'Present'),
(31, 1, 'Chahat Rana', 'IT', '2025-08-22', '2025-08-22 18:16:03', '2025-08-22 18:16:04', 'Present'),
(32, 6, 'Arpit Singh', 'Marketing', '2025-08-22', '2025-08-22 18:19:46', '2025-08-22 18:19:50', 'Present'),
(33, 4, 'krishna', 'IT', '2025-08-22', '2025-08-22 18:23:21', '2025-08-22 18:23:35', 'Present');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `name`, `email`, `password`, `department`) VALUES
(1, 'Chahat Rana', 'ranachahat02@gmail.com', '$2b$10$xaHULwBM2zEd1mAqzl4lUu2mSFaf9Z.c3OJvYF4OLBn3DcLbpR.2a', 'IT'),
(2, 'milan Rana', 'milanrana488@gmail.com', '$2b$10$R3CIw4O7D4JeBUc1V4xELOS3/xG0LIrdVkFRBvvzcyyh.idDK.D2C', 'IT'),
(3, 'mukesh', 'mumbai@gmail.com', '$2b$10$R2/2cDPeccqGItwacL6Rcus6vavNTF22Y9ma4Ss6K0L04hwm/K.uK', 'IT'),
(4, 'krishna', 'krishna@gmail.com', '$2b$10$xlg7tVBXGRt26Odd3HsiEe.06sXm0qaMOBGfg2WyAN.5B.iv8iZH6', 'IT'),
(5, 'vivek', 'thevivek@gmail.com', '$2b$10$mSatqu0gHKJTO3Bt5bqeEOOW67qn2WEQwgkgUmMnaejzPnJZMh3Bu', 'Engineering'),
(6, 'Arpit Singh', 'arpit@gmail.com', '$2b$10$nIu15JRe79lD6yB2wQjc2OMoajvBSpBrWrGaUw0zQv6FGSm6g2d.y', 'Marketing'),
(7, 'krishna Rana', 'dffff@gmail.com', '$2b$10$0ebZpm1NGA7vGfU2ApDk1OsrVxkjrGWoRaLEPsChtsSfMd9B/Hu6K', 'HR');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
