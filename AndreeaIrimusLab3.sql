-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE VolunteersForFestival
GO

-- ======================================================================
-- Description:	This procedure adds a column to the table InfoVolunteers.
-- ======================================================================
CREATE PROCEDURE sp_AddColumn
AS
ALTER TABLE InfoVolunteers
ADD Age INT;
SELECT * FROM InfoVolunteers
GO

EXEC sp_AddColumn

-- =========================================================================
-- Description:	This procedure removes a column to the table InfoVolunteers.
-- =========================================================================
CREATE PROCEDURE sp_RemoveColumn
AS
ALTER TABLE InfoVolunteers
DROP COLUMN Age;
SELECT * FROM InfoVolunteers
GO

EXEC sp_RemoveColumn

-- =============================================================================
-- Description:	This procedure adds a default constraint to the table LocatedAt.
-- =============================================================================
CREATE PROCEDURE sp_AddDefaultConstraint
AS
ALTER TABLE LocatedAt
ADD CONSTRAINT df_6 DEFAULT 6 for ShiftHrs;
SELECT * FROM LocatedAt
GO

EXEC sp_AddDefaultConstraint

-- ================================================================================
-- Description:	This procedure removes a default constraint to the table LocatedAt.
-- ================================================================================
CREATE PROCEDURE sp_RemoveDefaultConstraint
AS
ALTER TABLE LocatedAt
DROP CONSTRAINT df_6;
SELECT * FROM LocatedAt
GO

EXEC sp_RemoveDefaultConstraint


-- ================================================
-- Description:	This procedure creates a new table.
-- ================================================
CREATE PROCEDURE sp_CreateTable
AS
CREATE TABLE Food (
Fid INT PRIMARY KEY IDENTITY,
Vid INT,
FoodType nchar(50) DEFAULT 'Sandwhich');
SELECT * FROM Food
GO

EXEC sp_CreateTable

-- ==========================================
-- Description:	This procedure drops a table.
-- ==========================================
CREATE PROCEDURE sp_DropTable
AS
DROP TABLE Food;
GO 

EXEC sp_DropTable

-- =================================================================
-- Description:	This procedure adds a foreign key to the table Food.
-- =================================================================
CREATE PROCEDURE sp_AddFK
AS
ALTER TABLE Food
ADD CONSTRAINT fk_FoodVolunteer FOREIGN KEY(Vid) REFERENCES InfoVolunteers(Vid);
SELECT * FROM Food
GO

EXEC sp_AddFK

-- ======================================================================
-- Description:	This procedure removes a foreign key from the table Food.
-- ======================================================================
CREATE PROCEDURE sp_RemoveFK
AS
ALTER TABLE Food
DROP CONSTRAINT fk_FoodVolunteer;
SELECT * FROM Food
GO

EXEC sp_RemoveFK


CREATE TABLE DBVersion
(
DBVid INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
VersionNr INT
)

DROP TABLE DBVersion

CREATE PROCEDURE sp_UpdateDBVersion
@newVersion INT
AS
INSERT INTO DBVersion(VersionNr) VALUES (@newVersion)
GO


-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE VolunteersForFestival
GO

-- ======================================================================
-- Description:	This procedure adds a column to the table InfoVolunteers.
-- ======================================================================
CREATE PROCEDURE sp_AddColumn
AS
ALTER TABLE InfoVolunteers
ADD Age INT;
SELECT * FROM InfoVolunteers
GO

EXEC sp_AddColumn

-- =========================================================================
-- Description:	This procedure removes a column to the table InfoVolunteers.
-- =========================================================================
CREATE PROCEDURE sp_RemoveColumn
AS
ALTER TABLE InfoVolunteers
DROP COLUMN Age;
SELECT * FROM InfoVolunteers
GO

EXEC sp_RemoveColumn

-- =============================================================================
-- Description:	This procedure adds a default constraint to the table LocatedAt.
-- =============================================================================
CREATE PROCEDURE sp_AddDefaultConstraint
AS
ALTER TABLE LocatedAt
ADD CONSTRAINT df_6 DEFAULT 6 for ShiftHrs;
SELECT * FROM LocatedAt
GO

EXEC sp_AddDefaultConstraint

-- ================================================================================
-- Description:	This procedure removes a default constraint to the table LocatedAt.
-- ================================================================================
CREATE PROCEDURE sp_RemoveDefaultConstraint
AS
ALTER TABLE LocatedAt
DROP CONSTRAINT df_6;
SELECT * FROM LocatedAt
GO

EXEC sp_RemoveDefaultConstraint


-- ================================================
-- Description:	This procedure creates a new table.
-- ================================================
CREATE PROCEDURE sp_CreateTable
AS
CREATE TABLE Food (
Fid INT PRIMARY KEY IDENTITY,
Vid INT,
FoodType nchar(50) DEFAULT 'Sandwhich');
SELECT * FROM Food
GO

EXEC sp_CreateTable

-- ==========================================
-- Description:	This procedure drops a table.
-- ==========================================
CREATE PROCEDURE sp_DropTable
AS
DROP TABLE Food;
GO 

EXEC sp_DropTable

-- =================================================================
-- Description:	This procedure adds a foreign key to the table Food.
-- =================================================================
CREATE PROCEDURE sp_AddFK
AS
ALTER TABLE Food
ADD CONSTRAINT fk_FoodVolunteer FOREIGN KEY(Vid) REFERENCES InfoVolunteers(Vid);
SELECT * FROM Food
GO

EXEC sp_AddFK

-- ======================================================================
-- Description:	This procedure removes a foreign key from the table Food.
-- ======================================================================
CREATE PROCEDURE sp_RemoveFK
AS
ALTER TABLE Food
DROP CONSTRAINT fk_FoodVolunteer;
SELECT * FROM Food
GO

EXEC sp_RemoveFK


CREATE TABLE DBVersion
(
DBVid INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
VersionNr INT
)

CREATE PROCEDURE sp_UpdateDBVersion
@newVersion INT
AS
INSERT INTO DBVersion(VersionNr) VALUES (@newVersion)
GO


CREATE OR ALTER PROCEDURE sp_Main 
@version INT
AS
	IF(ISNUMERIC(@version)=0)
	BEGIN
		RAISERROR('The input you entered is not an integer.',16,1)
		RETURN -1
	END

	ELSE IF(@version<0)
	BEGIN
		RAISERROR('The number you entered is not positive.',16, 1)
		RETURN -1
	END


	ELSE IF(@version > 4)
	BEGIN
		RAISERROR('The number you enter must be between 0 and 4.', 16, 1)
		RETURN -1
	END
	
	ELSE
	BEGIN
		DECLARE @current INT
		SET @current = (SELECT TOP 1 VersionNr FROM DBVersion
						ORDER BY DBVid DESC)

		IF (@version = @current)
		BEGIN
			PRINT 'The database is already in this version.'
			RETURN -1
		END
		
		ELSE
		BEGIN
			WHILE(@version!= @current) 
			BEGIN
				IF (@version>@current)
				BEGIN
					SET @current = @current + 1  

					IF (@current=1)
					BEGIN
						EXEC sp_AddColumn
					END

					IF (@current=2)
					BEGIN
						EXEC sp_AddDefaultConstraint
					END
					 
					IF (@current=3)
					BEGIN
						EXEC sp_CreateTable
					END

					IF (@current=4)
					BEGIN
						EXEC sp_AddFK
					END
				
				IF (@version<@current)
				BEGIN 
					IF (@current=4)
					BEGIN
						EXEC sp_RemoveFK
					END

					IF (@current=3)
					BEGIN
						EXEC sp_DropTable
					END

					IF (@current=2)
					BEGIN
						EXEC sp_RemoveDefaultConstraint
					END
					IF (@current = 1)
					BEGIN 
						EXEC sp_RemoveColumn
					END
					SET @current = @current - 1

				END
			END
		END
		INSERT INTO DBVersion VALUES (@version)
		PRINT 'The database has been successfully updated to the chosen version.'
		PRINT @version
		END
	END
GO


EXEC sp_Main 0
EXEC sp_Main 1
EXEC sp_Main 2
EXEC sp_Main 3
EXEC sp_Main 4