 --Team: Binary Bandits
 --Project: University Management System
           --Team Members:
 --Name: Adib Hasan ID: 221-15-5002
 --Name: Jahid Hasan Siam ID: 221-15-5833
 --Name: Mahmudul Hasan Safin ID: 221-15-5450
 --Name: Md. Rezaul ID: 221-15-5822


CREATE SCHEMA pr2;
GO

CREATE TABLE pr2.Addresses
(
	AddressID     INTEGER        PRIMARY KEY    IDENTITY(1,1),
	Street1       VARCHAR(20)    NOT NULL,
	Street2       VARCHAR(20),
	City          VARCHAR(20)    NOT NULL,
	State         VARCHAR(20)    NOT NULL,
	ZIP           VARCHAR(10)    NOT NULL
);

CREATE TABLE pr2.AreaOfStudy
(
	AreaOfStudyID	    VARCHAR(20)						PRIMARY KEY,
	StudyTitle	        VARCHAR(50)			NOT NULL,
	UniversityID	        INTEGER				NOT NULL	REFERENCES pr2.University(UniversityID)
);

CREATE TABLE pr2.Benefits
(
	BenefitID           INTEGER        PRIMARY KEY    IDENTITY(1,1),
	BenefitCost         INTEGER        NOT NULL,
	BenefitDescription  VARCHAR(500),
	BenefitSelection    INTEGER        NOT NULL       REFERENCES pr2.BenefitSelection(BenefitSelectionID),
);

CREATE TABLE pr2.BenefitSelection
(
	BenefitSelectionID INTEGER      PRIMARY KEY     IDENTITY(1,1),
	BenefitSelection   VARCHAR(20)  NOT NULL
);

CREATE TABLE pr2.Buildings
(
	ID				INTEGER      PRIMARY KEY   IDENTITY(1,1),
	BuildingName	VARCHAR(80)  NOT NULL
);

CREATE TABLE pr2.ClassRoom
(
	ClassRoomID		VARCHAR(20)  NOT NULL	PRIMARY KEY,
	Building		INTEGER      NOT NULL   REFERENCES pr2.Buildings(Id),
	RoomNumber		VARCHAR(20)  NOT NULL,
	MaximumSeating	INTEGER      NOT NULL   CHECK(MaximumSeating > 0),
	Projector		INTEGER      NOT NULL   REFERENCES pr2.ProjectorInfo(ProjectorID),
	WhiteBoardCount INTEGER      NOT NULL,
	OtherAV         VARCHAR(20)  
);

CREATE TABLE pr2.University
(
	UniversityID	INTEGER		PRIMARY KEY		IDENTITY(1,1),
	UniversityName	VARCHAR(20)	NOT NULL		UNIQUE
);

CREATE TABLE pr2.CourseCatalogue
(
	CourseCode   VARCHAR(20) NOT NULL,
	CourseNumber INTEGER     NOT NULL,
	PRIMARY KEY (CourseCode,CourseNumber),
	CourseTitle  VARCHAR(50) NOT NULL,
	CourseDesc   VARCHAR(500) 
);

CREATE TABLE pr2.CourseDailySchedule
(
	DailyID			INTEGER	  PRIMARY KEY	  IDENTITY(1,1),
	CourseID		INTEGER	  NOT NULL        UNIQUE			REFERENCES pr2.CourseSchedule(CourseScheduleID),
	DayOfWeek		INTEGER	  NOT NULL							REFERENCES pr2.DayOfWeek(Id),
	StartTime		TIME	  NOT NULL,
	EndTime     	TIME      NOT NULL		  CHECK (EndTime > StartTime)
);

CREATE TABLE pr2.CourseEnrollment
(
	EnrollmentID	INTEGER	        PRIMARY KEY,
	CourseID	    INTEGER	        NOT NULL      REFERENCES    pr2.CourseSchedule(CourseScheduleID),
	StudentID	    INTEGER	        NOT NULL      REFERENCES    pr2.StudentInfo(StudentID),
	StatusID	    INTEGER	        NOT NULL      REFERENCES    pr2.StudentGradingStatus(StudentGradingStatusID),
	GradeID	        INTEGER	                      REFERENCES    pr2.Grades(GradeID)
);

CREATE TABLE pr2.CourseSchedule
(
	CourseScheduleID INTEGER     PRIMARY KEY IDENTITY(1,1),
	CourseCode       VARCHAR(20) NOT NULL,
	CourseNumber	 INTEGER     NOT NULL,
	FOREIGN KEY(CourseCode,CourseNumber)  REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber),
	NumberOfSeats    INTEGER     NOT NULL CHECK(NumberOfSeats>=0),
	Location		 VARCHAR(20)          REFERENCES pr2.ClassRoom(ClassRoomID),
	Semester		 INTEGER     NOT NULL REFERENCES pr2.SemesterInfo(SemesterID)
);

CREATE TABLE pr2.DayOfWeek
(
	Id	    INTEGER			PRIMARY KEY	 IDENTITY(1,1),
	Text	VARCHAR(50)		NOT NULL	 UNIQUE
);

CREATE TABLE pr2.EmployeeInfo
(
	EmployeeID     VARCHAR(20)    PRIMARY KEY,
	PersonID       INTEGER        NOT NULL       REFERENCES pr2.People(PersonID),
	YearlyPay      DECIMAL(10,2)  NOT NULL,
	HealthBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	VisionBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	DentalBenefits INTEGER        NOT NULL       REFERENCES pr2.Benefits(BenefitID),
	JobInformation InTEGER        NOT NULL       REFERENCES pr2.JobInformation(JobID)
);

CREATE TABLE pr2.Grades
(
	GradeID	    INTEGER	       PRIMARY KEY	 IDENTITY(1,1),
	Grade		VARCHAR(20)	   NOT NULL		 UNIQUE
);

CREATE TABLE pr2.JobInformation
( 
	JobID           INTEGER        PRIMARY KEY    IDENTITY(1,1),
	JobDescription  VARCHAR(500)   NOT NULL,
	JobRequirements VARCHAR(500),
	MinPay          DECIMAL(10,2)  NOT NULL       CHECK  (Minpay >= 0),
    MaxPay          DECIMAL(10,2)  NOT NULL       CHECK  (Maxpay >= 0),
	UnionJob        VARCHAR(3)     NOT NULL	      DEFAULT 'Yes'
);

CREATE TABLE pr2.People
(
	PersonID     INTEGER        PRIMARY KEY		IDENTITY(1,1),
	NTID         VARCHAR(20)    NOT NULL		UNIQUE,
	FirstName    VARCHAR(50)    NOT NULL,
    LastName     VARCHAR(50)    NOT NULL,
	Password     VARCHAR(50),
	DOB          DATE           NOT NULL,
	SSN          VARCHAR(11),
	HomeAddress  INTEGER        NOT NULL		REFERENCES pr2.Addresses(AddressID),
	LocalAddress INTEGER						REFERENCES pr2.Addresses(AddressID),
	IsActive     VARCHAR(3)     NOT NULL		DEFAULT 'Yes'
);

CREATE TABLE pr2.Prerequisites
(
	ParentCode   VARCHAR(20) NOT NULL,
	ParentNumber INTEGER     NOT NULL,
	ChildCode    VARCHAR(20) NOT NULL,
	ChildNumber  INTEGER     NOT NULL,
	PRIMARY KEY (ParentCode, ParentNumber,ChildCode,ChildNumber),
	FOREIGN KEY (ParentCode, ParentNumber) REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber),
	FOREIGN KEY (ChildCode,ChildNumber)    REFERENCES pr2.CourseCatalogue(CourseCode, CourseNumber)
);

CREATE TABLE pr2.ProjectorInfo
(
	ProjectorID   INTEGER      PRIMARY KEY  IDENTITY(1,1),
	ProjectorText VARCHAR(20)  NOT NULL
);

CREATE TABLE pr2.SemesterInfo
(
	SemesterID	INTEGER	    PRIMARY KEY		  IDENTITY(1,1),
	Semester	INTEGER	    NOT NULL		  REFERENCES        pr2.SemesterText(SemesterTextID),
	Year		INTEGER	    NOT NULL,
	FirstDay	DATE		NOT NULL,
	LastDay		DATE		NOT NULL          CHECK(LastDay > FirstDay)
);

CREATE TABLE pr2.SemesterText
(
	SemesterTextID	INTEGER			PRIMARY KEY		IDENTITY(1,1),
	SemesterText	VARCHAR(50)		NOT NULL
);

CREATE TABLE pr2.StudentAreaOfStudy
(
	AreaOfStudyID	INTEGER	      PRIMARY KEY,
	StudentID		INTEGER	      NOT NULL		REFERENCES pr2.StudentInfo(StudentID),
	AreaID		    VARCHAR(20)	  NOT NULL		REFERENCES pr2.AreaOfStudy(AreaOfStudyID),
	IsMajor			VARCHAR(3)	  NOT NULL
);

CREATE TABLE pr2.StudentGradingStatus
(
	StudentGradingStatusId      INTEGER	       PRIMARY KEY IDENTITY(1,1),
	StudentGradingStatus        VARCHAR(20)    NOT NULL
);

CREATE TABLE pr2.StudentInfo 
(
	StudentID				INTEGER	    PRIMARY KEY    IDENTITY(1,1),
	PersonID				INTEGER 	NOT NULL       REFERENCES     pr2.People(PersonID),
	StudentStatusID			INTEGER					   REFERENCES     pr2.StudentStatus(StudentStatusID)	
);

CREATE TABLE pr2.StudentStatus 
(
	StudentStatusID      INTEGER	    PRIMARY KEY	   IDENTITY(1,1),
	StudentStatus		 VARCHAR(80)	NOT NULL
);

CREATE TABLE pr2.TeachingAssignment
(
	EmployeeID           VARCHAR(20)     NOT NULL	  REFERENCES pr2.EmployeeInfo(EmployeeID),
	CourseScheduleID     INTEGER         NOT NULL     REFERENCES pr2.CourseSchedule(CourseScheduleID) ,
	PRIMARY KEY (EmployeeID, CourseScheduleID)
);


--Data insertion in the Table

INSERT INTO pr2.Addresses (Street1, Street2, City, State, ZIP) VALUES 
('Dhanmondi 32', 'Mirpur Road', 'Dhaka', 'Dhaka Division', '1209'),
('Gulshan Avenue', 'Banani Road 11', 'Dhaka', 'Dhaka Division', '1212'),
('Shahjalal Road', NULL, 'Sylhet', 'Sylhet Division', '3100'),
('Rajshahi Road', NULL, 'Rajshahi', 'Rajshahi Division', '6200'),
('CDA Avenue', 'Nasirabad', 'Chattogram', 'Chattogram Division', '4000'),
('Khulna Main Road', NULL, 'Khulna', 'Khulna Division', '9100');

SELECT * FROM pr2.Addresses

INSERT INTO pr2.AreaOfStudy VALUES
('01-CSE', 'Computer Science & Engineering', 1),
('02-BBA', 'Business Administration', 1),
('03-EEE', 'Electrical & Electronic Engineering', 1),
('04-ECO', 'Economics', 3),
('05-LLB', 'Law', 1),
('06-ENG', 'English Literature', 4);

SELECT * FROM pr2.AreaOfStudy

INSERT INTO pr2.Benefits (BenefitCost, BenefitDescription, BenefitSelection) VALUES
(2000, 'General Consultation', 1),
(3000, 'Hospitalization', 2),
(1000, 'Pathology Tests', 3),
(4000, 'Maternity Care', 2),
(2500, 'Dental Care', 1),
(1500, 'Eye Check-Up', 3);

SELECT * FROM pr2.Benefits

INSERT INTO pr2.BenefitSelection (BenefitSelection) VALUES 
('Single'),
('Family'),
('Op-out');

SELECT * FROM pr2.BenefitSelection;

INSERT INTO pr2.Buildings (BuildingName) VALUES
('A.K. Khan Building'),
('Sheikh Fazilatunnessa Hall'),
('Tajuddin Auditorium'),
('Iqbal Center'),
('Bangabandhu Communication Lab'),
('National Research Center');

SELECT * FROM pr2.Buildings;

INSERT INTO pr2.ClassRoom (ClassRoomID, Building, RoomNumber, MaximumSeating, Projector, WhiteBoardCount, OtherAV) VALUES
('01-AK', 1, 'AK-101', 50, 1, 2, 'Projector'),
('02-SF', 2, 'SF-302', 60, 1, 1, 'None'),
('03-TA', 3, 'TA-102', 40, 0, 1, 'None'),
('04-IC', 4, 'IC-201', 70, 2, 2, 'Sound System'),
('05-BB', 5, 'BB-102', 30, 1, 0, 'None'),
('06-NC', 6, 'NC-305', 20, 1, 2, 'None');

SELECT * FROM pr2.ClassRoom

INSERT INTO pr2.University (UniversityName) VALUES
('University of Dhaka'),
('Bangladesh University of Engineering and Technology'),
('North South University'),
('BRAC University'),
('Rajshahi University'),
('Chittagong University');

SELECT * FROM pr2.University

INSERT INTO pr2.CourseCatalogue VALUES('CSE', '102', 'Data Structures', 'Introduction to fundamental data structures such as arrays, stacks, queues, and linked lists.'),
('BBA', '202', 'Financial Accounting', 'Principles of financial accounting, financial statements, and analysis.'),
('EEE', '303', 'Control Systems', 'Fundamentals of feedback control systems and stability analysis.'),
('ENG', '405', 'World Literature', 'Exploration of literary works from various cultures and epochs.'),
('LAW', '101', 'Introduction to Law', 'Basic principles and history of law in Bangladesh.'),
('CSE', '502', 'Artificial Intelligence', 'Foundations of AI, including machine learning, search algorithms, and reasoning.');

SELECT * FROM pr2.CourseCatalogue

INSERT INTO pr2.CourseDailySchedule (CourseID, DayOfWeek, StartTime, EndTime) VALUES
(13, 2, '10:00:00', '12:00:00'),
(19, 3, '12:30:00', '14:30:00'),
(20, 4, '15:00:00', '17:00:00'),
(21, 5, '09:00:00', '11:00:00'),
(22, 6, '08:30:00', '10:00:00'),
(27, 1, '11:30:00', '13:30:00');

DBCC CHECKIDENT ('pr2.CourseDailySchedule', RESEED, 2)

INSERT INTO pr2.CourseDailySchedule (CourseID, DayOfWeek, StartTime, EndTime) VALUES
(19, 6, '15:00:00', '17:00:00');

DBCC CHECKIDENT ('pr2.CourseDailySchedule', RESEED, 4)
INSERT INTO pr2.CourseDailySchedule (CourseID , DayOfWeek , StartTime , EndTime) VALUES
(20,3,'16:00:00','18:00:00'),
(21,4,'18:00:00','19:20:00'),
(22,5,'9:00:00','10:30:00'),
(27,3,'16:30:00','19:00:00'),
(29,1,'15:00:00','18:00:00'),
(30,1,'16:00:00','19:00:00')

SELECT * FROM pr2.CourseDailySchedule

INSERT INTO pr2.CourseEnrollment (EnrollmentID, CourseID, StudentID, StatusID, GradeID) VALUES
(200, 13, 1, 1, 1),
(201, 19, 2, 2, NULL),
(202, 20, 3, 1, 3),
(203, 21, 4, 2, 2),
(204, 22, 5, 1, NULL),
(205, 27, 6, 2, 1);

SELECT * FROM pr2.CourseEnrollment


INSERT INTO pr2.CourseSchedule (CourseCode, CourseNumber, NumberOfSeats, Location, Semester) VALUES 
('CSE', 102, 50, '01-AK', 1),
('BBA', 202, 60, '02-SF', 2),
('EEE', 303, 40, '03-TA', 3),
('ENG', 405, 45, '04-IC', 4),
('LAW', 101, 30, '05-BB', 5),
('CSE', 502, 25, '06-NC', 1);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 12);

INSERT INTO pr2.CourseSchedule (CourseCode, CourseNumber, NumberOfSeats, Location, Semester) VALUES 
('CS', 612, 50, '04-CST', 1);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 18);

INSERT INTO pr2.CourseSchedule (CourseCode, CourseNumber, NumberOfSeats, Location, Semester) VALUES 
('CS', 692, 60, '04-CST', 2),
('EE', 632, 25, '05-NCC', 3),
('EE', 662, 35, '03-HC', 4),
('CS', 702, 45, '02-HL', 5);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 26);

INSERT INTO pr2.CourseSchedule (CourseCode, CourseNumber, NumberOfSeats, Location, Semester) VALUES 
('CS', 772, 15, NULL, 7);

DBCC CHECKIDENT ('pr2.CourseSchedule', RESEED, 28);

INSERT INTO pr2.CourseSchedule (CourseCode, CourseNumber, NumberOfSeats, Location, Semester) VALUES 
('MAE', 111, 30, NULL, 1),
('CE', 775, 30, NULL, 8);

SELECT * FROM pr2.CourseSchedule;


INSERT INTO pr2.DayOfWeek (Text) VALUES
('Sunday'),
('Monday'),
('Tuesday'),
('Wednesday'),
('Thursday'),
('Friday'),
('Saturday');

SELECT * FROM pr2.DayOfWeek;

INSERT INTO pr2.EmployeeInfo (EmployeeID, PersonID, YearlyPay, HealthBenefits, VisionBenefits, DentalBenefits, JobInformation) VALUES
('01-CSE', 7, 20000.00, 1, 1, 2, 3),
('02-BBA', 8, 15000.00, 2, 2, 1, 4),
('03-EEE', 9, 25000.00, 1, 3, 2, 2),
('04-ENG', 10, 30000.00, 3, 2, 3, 1),
('05-LAW', 11, 18000.00, 2, 1, 2, 5),
('06-CSE', 12, 22000.00, 1, 2, 1, 6);

SELECT * FROM pr2.EmployeeInfo

INSERT INTO pr2.Grades (Grade) VALUES
('A'),
('B'),
('C'),
('D');

SELECT * FROM pr2.Grades

INSERT INTO pr2.JobInformation (JobDescription, JobRequirements, MinPay, MaxPay, UnionJob) VALUES
('Professor', 'PhD with 5+ years of experience in teaching/research', 30000.00, 80000.00, 'No'),
('Assistant Professor', 'PhD with 2+ years of experience', 20000.00, 60000.00, 'Yes'),
('Lecturer', 'Masters with strong academic background', 15000.00, 40000.00, 'Yes'),
('Adjunct Faculty', 'Masters with industry experience', 10000.00, 30000.00, 'No'),
('Research Assistant', 'Masters pursuing PhD', 12000.00, 25000.00, 'No'),
('Teaching Assistant', 'Bachelor’s degree pursuing Masters', 8000.00, 20000.00, 'No');

SELECT * FROM pr2.JobInformation

-- Students
INSERT INTO pr2.People (NTID, FirstName, LastName, Password, DOB, SSN, HomeAddress, LocalAddress, IsActive) VALUES
('01-RA', 'Rakib', 'Ahmed', 'rakib123', '19990512', 'B123456789', 1, NULL, 'Yes'),
('02-SA', 'Sanjana', 'Akter', 'san123', '20000120', NULL, 3, 4, 'Yes'),
('03-MR', 'Moin', 'Rahman', NULL, '19991214', NULL, 3, 1, 'Yes'),
('04-NS', 'Nusrat', 'Sultana', 'nusrat_234', '19980317', 'G987654321', 4, 6, 'No'),
('05-MK', 'Mehedi', 'Khan', NULL, '19990810', 'H567812345', 2, NULL, 'Yes'),
('06-FH', 'Farhana', 'Haque', 'farhana2024', '19971204', 'J098712345', 5, 3, 'No');

--Professors/employees
INSERT INTO pr2.People (NTID, FirstName, LastName, Password, DOB, SSN, HomeAddress, LocalAddress, IsActive) VALUES
('01-AB', 'Abul', 'Bashar', 'pass123', '19751201', 'P87654321', 1, 2, 'Yes'),
('02-SI', 'Siddiqur', 'Islam', NULL, '19800909', 'L43210987', 1, 2, 'Yes'),
('03-FA', 'Farid', 'Ahmed', NULL, '19840612', 'K098764321', 5, 4, 'Yes'),
('04-NS', 'Nasima', 'Sultana', 'ns_2022', '19820522', 'M876543210', 1, 6, 'No'),
('05-TA', 'Tahmid', 'Ahmed', 'tahmid321', '19861231', 'T543218765', 2, NULL, 'Yes'),
('06-RI', 'Rizwan', 'Islam', NULL, '19870315', 'F123456789', 5, NULL, 'No');

SELECT * FROM pr2.People

INSERT INTO pr2.Prerequisites (ParentCode , ParentNumber , ChildCode , ChildNumber) VALUES
('CE',787,'CS',692),
('CE',787,'CS',772),
('CS',784,'CS',702),
('CS',612,'CE',787),
('EE',632,'EE',662)

SELECT * FROM pr2.Prerequisites

INSERT INTO pr2.ProjectorInfo(ProjectorText) VALUES
('BASIC/NO'),
('SMARTBOARD/NO'),
('BASIC/YES'),
('SMARTBOARD/YES');

SELECT * FROM pr2.ProjectorInfo

INSERT INTO pr2.SemesterInfo (Semester, Year, FirstDay, LastDay) VALUES
(1, 2023, '20230110', '20230615'),
(2, 2023, '20230701', '20231220'),
(1, 2024, '20240110', '20240620'),
(2, 2024, '20240701', '20241220');

INSERT INTO pr2.SemesterInfo(Semester,Year,FirstDay,LastDay)VALUES
(1,2016,'20160618','20161218')

INSERT INTO pr2.SemesterInfo(Semester,Year,FirstDay,LastDay)VALUES
(2,2016,'20160116','20160518')

SELECT * FROM pr2.SemesterInfo

INSERT INTO pr2.SemesterText(SemesterText) VALUES
('FALL'),
('SPRING'), 
('SUMMER')

SELECT * FROM pr2.SemesterText

INSERT INTO pr2.StudentAreaOfStudy (AreaOfStudyID, StudentID, AreaID, IsMajor) VALUES
(100, 1, '01-CSE', 'Yes'),
(101, 2, '02-BBA', 'No'),
(102, 3, '03-EEE', 'Yes'),
(103, 4, '04-ENG', 'No'),
(104, 5, '05-LAW', 'Yes'),
(105, 6, '06-BIO', 'No');

SELECT * FROM pr2.StudentAreaOfStudy

INSERT INTO pr2.StudentGradingStatus (StudentGradingStatus) VALUES ('Graded');
INSERT INTO pr2.StudentGradingStatus (StudentGradingStatus) VALUES ('Ungraded');

SELECT * FROM pr2.StudentGradingStatus

INSERT INTO pr2.StudentInfo (PersonID, StudentStatusID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 2),
(6, 1);

SELECT * FROM pr2.StudentInfo

INSERT INTO pr2.StudentStatus (StudentStatus) VALUES 
('Full-Time'),
('Part-Time'),
('Deferred'),
('Expelled');

SELECT * FROM pr2.StudentStatus

INSERT INTO pr2.TeachingAssignment (EmployeeID, CourseScheduleID) VALUES
('01-AB', 13),
('02-SI', 19),
('03-FA', 20),
('04-NS', 21),
('05-TA', 22),
('06-RI', 27);

SELECT * FROM pr2.TeachingAssignment

