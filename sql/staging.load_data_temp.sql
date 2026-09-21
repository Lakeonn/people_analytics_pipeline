/*
This is a daily insert only. Temporary. 
It gets replaced each day. Full daily data would be stored in
bronze. 
*/

USE people_analytics;
GO

---------------------------------------------------------
-- STAGING: employees
---------------------------------------------------------

-- Truncating the table if it exists, and then bul inserting employees, into temp staging table. 
IF OBJECT_ID ('staging.employees', 'U') IS NOT NULL
	TRUNCATE TABLE staging.employees;
GO

BULK INSERT staging.employees
FROM "C:\Users\letov\Projects\people_analytics\data\raw\employees.csv"
WITH (
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	TABLOCK, 
	KEEPNULLS
);
GO


---------------------------------------------------------
-- STAGING: events
---------------------------------------------------------

IF OBJECT_ID ('staging.events', 'U') IS NOT NULL
	TRUNCATE TABLE staging.events;
GO

BULK INSERT staging.events
FROM "C:\Users\letov\Projects\people_analytics\data\raw\events.csv"
WITH (
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	TABLOCK, 
	KEEPNULLS
);
GO