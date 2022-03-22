create database VolunteersforFestival
go
use VolunteersForFestival
go

CREATE TABLE Departments(
	Did INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	DName nchar(50))

CREATE TABLE Locations(
    Lid INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	LName nchar(50),
	LActivity nchar(50))

CREATE TABLE Teams(
	Tid INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TName nchar(50))

CREATE TABLE Tasks(
    Tsid INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TsType nchar(50),
	TsStart time,
	TsStop time,
	TsStatus nchar(50))

CREATE TABLE TeamsDepartments(
   Tid INT FOREIGN KEY REFERENCES Teams(Tid),
   Did INT FOREIGN KEY REFERENCES Departments(Did),
   CONSTRAINT PK_TeamsDepartments PRIMARY KEY(Tid, Did),
   NbOfVolunteers INT)

CREATE TABLE LocatedAt(
   Tid INT FOREIGN KEY REFERENCES Teams(Tid),
   Lid INT FOREIGN KEY REFERENCES Locations(Lid),
   ShiftHrs INT,
   CONSTRAINT PK_LocatedAt PRIMARY KEY(Tid, Lid))

CREATE TABLE InfoVolunteers(
   Vid INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
   FullName nchar(50),
   DateofBirth date,
   Email nchar(50),
   Tid INT FOREIGN KEY REFERENCES Teams(Tid),
   Tsid INT FOREIGN KEY REFERENCES Tasks(Tsid))

--Inserting data into the tables
--Departments table
INSERT INTO Departments(DName) VALUES ('ACCESS')
INSERT INTO Departments(DName) VALUES ('RELATIONS&PR')
INSERT INTO Departments(DName) VALUES ('GUEST')
INSERT INTO Departments(DName) VALUES ('CHECK-IN')

SELECT * FROM Departments

--Locations table
INSERT INTO Locations(LName, LActivity) VALUES ('Main Stage','FestivalZone')
INSERT INTO Locations(LName, LActivity) VALUES ('The Lake','LeisureSpot')
INSERT INTO Locations(LName, LActivity) VALUES ('Gardens','FoodCourt&Bar')
INSERT INTO Locations(LName, LActivity) VALUES ('First Aid Point','Facility')
INSERT INTO Locations(LName, LActivity) VALUES ('NewPark','LeisureSpot')
INSERT INTO Locations(LName, LActivity) VALUES ('Spa','Facility')
INSERT INTO Locations(LName) VALUES ('Bathrooms')

SELECT * FROM Locations

--Teams table
INSERT INTO Teams(TName) VALUES ('Blue')
INSERT INTO Teams(TName) VALUES ('WildCats')
INSERT INTO Teams(TName) VALUES ('Purple')
INSERT INTO Teams(TName) VALUES ('Flowers')

SELECT * FROM Teams

--TeamsDepartments table
INSERT INTO TeamsDepartments(Tid,Did,NbOfVolunteers) VALUES (1,3,10)
INSERT INTO TeamsDepartments(Tid,Did,NbOfVolunteers) VALUES (4,2,9)
INSERT INTO TeamsDepartments(Tid,Did,NbOfVolunteers) VALUES (3,4,13)
INSERT INTO TeamsDepartments(Tid,Did,NbOfVolunteers) VALUES (2,1,16)
INSERT INTO TeamsDepartments(Tid,Did,NbOfVolunteers) VALUES (2,4,10)

SELECT * FROM TeamsDepartments

--Tasks table
INSERT INTO Tasks(TsType,TsStart,TsStop,TsStatus) VALUES ('CALL SPONSORS','12:00:00','13:00:00','IN PROGRESS')
INSERT INTO Tasks(TsType,TsStart,TsStop,TsStatus) VALUES ('SCAN BRACELETS','14:00:00','18:00:00','COMPLETE')
INSERT INTO Tasks(TsType,TsStart,TsStop,TsStatus) VALUES ('PICK UP ARTIST','08:00:00','09:00:00','COMPLETE')
INSERT INTO Tasks(TsType,TsStart,TsStop,TsStatus) VALUES ('CLEAN BACKSTAGE','07:00:00','10:00:00','IN PROGRESS')

SELECT * FROM Tasks

--LocatedAt table
INSERT INTO LocatedAt(Tid,Lid,ShiftHrs) VALUES (1,1,7)
INSERT INTO LocatedAt(Tid,Lid,ShiftHrs) VALUES (2,3,6)
INSERT INTO LocatedAt(Tid,Lid,ShiftHrs) VALUES (3,2,5)
INSERT INTO LocatedAt(Tid,Lid,ShiftHrs) VALUES (4,4,6)
INSERT INTO LocatedAt(Tid,Lid,ShiftHrs) VALUES (1,2,7)

SELECT * FROM LocatedAt


--InfoVolunteers table
INSERT INTO InfoVolunteers(FullName,DateOfBirth,Email,Tid,Tsid) VALUES ('Anna Johnes','1997-08-26','annjohnes77@gmail.com',1,3)
INSERT INTO InfoVolunteers(FullName,DateOfBirth,Email,Tid,Tsid) VALUES ('George W.','2001-11-09','wgeorge23@gmail.com',2,4)
INSERT INTO InfoVolunteers(FullName,DateOfBirth,Email,Tid,Tsid) VALUES ('Britany Jensen','1999-01-08','brittj@gmail.com',3,2)
INSERT INTO InfoVolunteers(FullName,DateOfBirth,Email,Tid,Tsid) VALUES ('David Martins','2000-06-23','dave0623@gmail.com',4,1)
INSERT INTO InfoVolunteers(FullName,DateOfBirth,Email,Tid,Tsid) VALUES ('Diana G.','2002-07-25','diana25@gmail.com',2,4)

SELECT * FROM InfoVolunteers

--Updating data from tables
--Update the name of a team => Table = Teams
UPDATE Teams
SET TName='Stars'
WHERE TName LIKE 'B__%' AND Tid<=2

SELECT * FROM Teams

--Update the name of a department => Table = Departments
UPDATE Departments
SET DName='GUEST&BACKSTAGE'
WHERE Did=3

UPDATE Departments
SET DName='PR'
WHERE DName LIKE 'R__%' OR Did IN (2)

SELECT * FROM Departments

--Deleting data 
--Delete some locations => Table = Locations
DELETE FROM Locations
WHERE LActivity IS NULL

DELETE FROM Locations 
WHERE Lid BETWEEN 5 AND 6

SELECT * FROM Locations

--Select Queries
--Union => the teams having a number of volunteers less than or equal to 10 OR the temas from the Check-In department having a number of volunteers less than 16
--Tid=1,Tid=4,Tid=3
SELECT *
FROM TeamsDepartments
WHERE NbOfVolunteers<=10
UNION
SELECT *
FROM TeamsDepartments
WHERE Did=4 AND NbOfVolunteers<16

--Intersect => the volunteers which were born after 1997-08-26 AND also have the name starting with 'D' and having at least 5 letters
SELECT V1.FullName
FROM InfoVolunteers V1
WHERE V1.DateOfBirth>'1997-08-26'
INTERSECT
SELECT V2.FullName
FROM InfoVolunteers V2
WHERE V2.FullName LIKE 'D____%'
ORDER BY V1.FullName

--EXCEPT => the volunteers which were born on/before 2000-06-23, except those from the team corresponding with the id 1
SELECT V1.FullName
FROM InfoVolunteers V1
WHERE V1.DateOfBirth<='2000-06-23'
EXCEPT
SELECT V2.FullName
FROM InfoVolunteers V2
WHERE V2.Tid=1

--Inner Join => shows all the teams, in which department they activate and how many volunteers they have
--this query joins the tables: Teams, Departments and TeamsDepartments
SELECT T.TName,D.DName,TD.NbOfVolunteers
FROM ((Teams T
INNER JOIN TeamsDepartments TD ON T.Tid=TD.Tid)
INNER JOIN Departments D ON TD.Did=D.Did) 

--Left Outer Join => shows all the locations, the teams which activate there and the duration of their shift
--this query joins the tables: Locations, Teams and LocatedAt
SELECT L.LName,T.TName,LA.ShiftHrs
FROM ((Locations L
LEFT OUTER JOIN LocatedAt LA ON L.Lid=LA.Lid)
LEFT OUTER JOIN Teams T ON T.Tid=LA.Tid) 

--Right Outer Join => shows all the tasks, the volunteers which partake in them and their team's name
--this query joins the tables: Tasks, Teams and InfoVolunteers
SELECT Ts.TsType,T.TName,V.FullName
FROM ((Tasks Ts
RIGHT OUTER JOIN InfoVolunteers V ON Ts.Tsid=V.Tsid)
RIGHT OUTER JOIN Teams T ON T.Tid=V.Tid)

--Full Outer Join => shows the teams, in which department they activate and how many volunteers they have
--this query joins the tables: Teams, Departments and TeamsDepartments
SELECT T.TName,D.DName,TD.NbOfVolunteers
FROM((Teams T
FULL OUTER JOIN TeamsDepartments TD ON T.Tid=TD.Tid)
FULL OUTER JOIN Departments D ON TD.Did=D.Did)

--the volunteers born before 2000-06-23 and they id of their team
SELECT V.FullName,V.Tid
FROM InfoVolunteers V
WHERE DateOfBirth<'2000-06-23' AND V.Tid IN (SELECT T.Tid FROM Teams T)

--the id of the teams with a shift of/longer than 6 hours
SELECT LA.Tid, LA.ShiftHrs
FROM LocatedAt LA
WHERE ShiftHrs>=6 and EXISTS (SELECT * FROM Teams T WHERE T.Tid=LA.Tid)

--groups the teams by how many volunteers they have
SELECT COUNT(*), NbOfVolunteers
FROM TeamsDepartments
GROUP BY NbOfVolunteers

--display the teams (id) having less than 11 volunteers
SELECT TD.Tid, MIN(TD.NbOfVolunteers) AS MinNr
FROM TeamsDepartments TD
WHERE TD.NbOfVolunteers <= 11
GROUP BY TD.Tid
HAVING COUNT(*) <= 10

--display the teams (id) having more than 11 volunteers
SELECT TD.Tid, MAX(TD.NbOfVolunteers) AS MaxNr
FROM TeamsDepartments TD
WHERE TD.NbOfVolunteers >= 11
GROUP BY TD.Tid
HAVING 16 >=  (SELECT COUNT(*)
			  FROM TeamsDepartments TD2
			  WHERE TD2.Tid = TD.Tid)

--the average number of volunteers
select AVG(TD.NbOfVolunteers) AS average
from TeamsDepartments TD

select T.Tid, AVG(TD.NbOfVolunteers)
from Teams T INNER JOIN TeamsDepartments TD ON T.Tid=TD.Tid
WHERE T.Tid<=2
GROUP BY T.Tid


SELECT T.Tid, T.TName, SUM(ShiftHrs) as TotalHours
FROM Teams T INNER JOIN LocatedAt LA ON T.Tid=LA.Tid
WHERE LA.ShiftHrs>6
GROUP BY T.Tid, T.TName
HAVING SUM(ShiftHrs) BETWEEN 6 AND 20

--order the volunteers by full name, ascending
SELECT FullName,DateOfBirth
FROM InfoVolunteers
ORDER BY FullName ASC

--order the locations by their activity, ascending
SELECT LName,LActivity
FROM Locations
ORDER BY LActivity

--youngest to oldest volunteer
SELECT FullName,DateOfBirth
FROM InfoVolunteers
ORDER BY DateOfBirth DESC

--order the departments by name, descending
SELECT DName
FROM Departments
ORDER BY DName DESC

--the first 3 records from the InfoVolunteers table
SELECT TOP 3 V.FullName, V.Email
FROM InfoVolunteers V
ORDER BY V.DateOfBirth

SELECT DISTINCT LActivity FROM Locations

SELECT * FROM Locations
ORDER BY LActivity

SELECT COUNT(*) FROM InfoVolunteers