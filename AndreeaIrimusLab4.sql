USE VolunteersforFestival
GO


-- This function checks if the input is an int.
CREATE FUNCTION CheckINT(@n INT)
RETURNS INT AS 
BEGIN 
	DECLARE @no INT
	IF @n = 0
		SET @no = 0
	ELSE 
		SET @no = 1
	RETURN @no
END
GO

DROP FUNCTION CheckINT


-- This function checks if the input is a varchar.
CREATE FUNCTION CheckVARCHAR(@v VARCHAR(50))
RETURNS BIT AS
BEGIN 
	DECLARE @b BIT
	IF @v like '[a-z]%[a-z]'
		SET @b = 1
	ELSE 
	SET @b = 0
	RETURN @b
END
GO

DROP FUNCTION CheckVARCHAR


-- The stored procedure for insert.
SET IDENTITY_INSERT [dbo].[Locations] OFF

CREATE PROCEDURE insertLocation
	@Lid INT, 
	@LName VARCHAR(50), 
	@LActivity VARCHAR(50)
AS
BEGIN 
	SET NOCOUNT ON
	IF dbo.CheckVARCHAR(@LName) = 1 AND dbo.CheckVARCHAR(@LActivity) = 1 AND dbo.CheckINT(@Lid) = 1
	BEGIN 
	INSERT INTO Locations(Lid, LName, LActivity) VALUES (@Lid, @LName, @LActivity)
	PRINT 'Value added!'
	SELECT * FROM Locations
	END
	ELSE
	BEGIN
	PRINT 'The parameters are not correct!'
	SELECT * FROM Locations
	END
END
GO

DROP PROCEDURE insertLocation

SET IDENTITY_INSERT Locations ON

EXECUTE [dbo].[insertLocation]
	@Lid = 10,
	@LName = 'Tree House',
	@LActivity = 'FestivalZone'
GO

DELETE FROM Locations WHERE Lid=10

SELECT * FROM Locations

-- View: shows the name of the teams and the name of its the volunteers, along with the department 
-- in which they activate and where they are located.
CREATE VIEW ViewAll
AS
SELECT T.TName, V.FullName, D.DName, L.LName
FROM Teams T, InfoVolunteers V, Departments D, Locations L
WHERE T.Tid=V.Vid AND V.Vid=D.Did AND D.Did=L.Lid AND L.Lid=T.Tid
GO

SELECT * FROM ViewAll

DROP VIEW ViewAll


-- Trigger: first of all, we create the table logs, in which the date and the time of the triggering statement,
-- the trigger type(INSERT/UPDATE/DELETE), the name of the affected table and the number of added/modified/removed records 
-- will be kept.
CREATE TABLE Logs(
lid INT PRIMARY KEY IDENTITY,
TriggerDate Date,
TriggerType VARCHAR(50),
NameAffectedTable VARCHAR(50),
NoAMDRows INT
)

DROP TABLE Logs

-- We will denote the operations as follows: INS = insert, UPD = update, DEL = delete.

-- Now, let's create a trigger for the INSERT operation.
SET IDENTITY_INSERT [dbo].[Locations] OFF

CREATE TRIGGER InsLoc ON Locations FOR INSERT
AS
BEGIN
    INSERT INTO Logs VALUES (GETDATE(),'INS','Locations',@@ROWCOUNT)
END
GO

SET IDENTITY_INSERT Locations ON

SELECT * FROM Locations

EXECUTE [dbo].[insertLocation]
	@Lid = 7,
	@LName = 'Toilets',
	@LActivity = 'Facility'
GO


SELECT * FROM Logs

DROP TRIGGER InsLoc


-- Now, let's create a trigger for the UPDATE operation.
CREATE TRIGGER UpdLoc ON Locations FOR UPDATE
AS
BEGIN
    INSERT INTO Logs VALUES (GETDATE(),'UPD','Locations',@@ROWCOUNT)
END
GO


SELECT * FROM Locations

UPDATE Locations
SET LName='Lake'
WHERE LActivity in ('LeisureSpot')

SELECT * FROM Locations

SELECT * FROM Logs

DROP TRIGGER UpdLoc


-- Now, let's create a trigger for the DELETE operation.
CREATE TRIGGER DelLoc ON Locations FOR DELETE
AS
BEGIN
    INSERT INTO Logs VALUES (GETDATE(),'DEL','Locations',@@ROWCOUNT)
END 
GO

SELECT * FROM Locations

DELETE FROM Locations
WHERE Lid=10

SELECT * FROM Locations

SELECT * FROM Logs


DROP TRIGGER DelLoc


-- We create a nonclustered index.
IF EXISTS (SELECT NAME FROM sys.indexes WHERE NAME='MyNonClusteredIndex')
	DROP INDEX MyNonClusteredIndex ON Locations
GO
CREATE NONCLUSTERED INDEX MyNonClusteredIndex ON Locations(Lid,LName,LActivity)
GO

-- Nonclustered index scan
SELECT * FROM Locations ORDER BY LActivity

-- NonClustered index seek
SELECT L.LName,T.TName,LA.ShiftHrs
FROM ((Locations L
LEFT OUTER JOIN LocatedAt LA ON L.Lid=LA.Lid)
LEFT OUTER JOIN Teams T ON T.Tid=LA.Tid) 
WHERE LA.ShiftHrs<=6

-- Clustered index scan
SELECT Tid, AVG(NbOfVolunteers) AS AverageNumber
FROM TeamsDepartments
WHERE NbOfVolunteers<=13
GROUP BY Tid 
having AVG(NbOfVolunteers)<13 
ORDER BY Tid

-- Clustered index seek
SELECT T.TName,D.DName,TD.NbOfVolunteers
FROM ((Teams T
INNER JOIN TeamsDepartments TD ON T.Tid=TD.Tid)
INNER JOIN Departments D ON TD.Did=D.Did) 
WHERE TD.NbOfVolunteers<=13

-- Key lookup
SELECT * FROM TeamsDepartments where NbOfVolunteers>10

-- This checks all the indexes.
SELECT * FROM sys.indexes
