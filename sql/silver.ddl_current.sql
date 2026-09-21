/* 

*/

-- Using same database. -----------------------------------------------
USE people_analytics;
GO

-- Department. --------------------------------------------------------
PRINT ('Creating department dimension table');
GO

DROP TABLE IF EXISTS silver.dim_department;
GO

CREATE TABLE silver.dim_department (
department_id INT IDENTITY(1,1) PRIMARY KEY, 
department NVARCHAR(100), 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created department dimension table');
GO


-- Locations. --------------------------------------------------------
PRINT ('Creating locations dimension table');
GO

DROP TABLE IF EXISTS silver.dim_location;
GO

CREATE TABLE silver.dim_location (
location_id INT IDENTITY(1,1) PRIMARY KEY, 
city NVARCHAR(200), 
country NVARCHAR(200), 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created locations dimension table');
GO


-- Job title. --------------------------------------------------------
PRINT ('Creating job title dimension table');
GO

DROP TABLE IF EXISTS silver.dim_job_title;
GO

CREATE TABLE silver.dim_job_title (
job_id INT IDENTITY(1,1) PRIMARY KEY, 
job_title NVARCHAR(200), 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created job title dimension table');
GO


-- Employees. --------------------------------------------------------
PRINT ('Creating employees dimension table');
GO

DROP TABLE IF EXISTS silver.dim_employees;
GO

CREATE TABLE silver.dim_employees (
employee_id INT PRIMARY KEY, 
first_name NVARCHAR(200), 
last_name NVARCHAR(200), 
gender VARCHAR(20), 
birth_date DATE, 
hire_date DATE, 
termination_date DATE, 
location_id INT, 
job_id INT, 
department_id INT, 
manager_id NVARCHAR(10), 
created_at DATETIME2, 
updated_at DATETIME2, 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created employees dimension table');
GO



-- Salary. --------------------------------------------------------
PRINT ('Creating salary fact table');
GO

DROP TABLE IF EXISTS silver.fact_salary;
GO

CREATE TABLE silver.fact_salary (
employee_id NVARCHAR(10) PRIMARY KEY, 
salary DECIMAL(9, 2), 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created salary fact table');
GO


-- Event type. --------------------------------------------------------
PRINT ('Creating event type dim table');
GO

DROP TABLE IF EXISTS silver.dim_event_type;
GO

CREATE TABLE silver.dim_event_type (
event_type_id INT IDENTITY(1,1) PRIMARY KEY, 
event_type NVARCHAR(50), 
dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created event type dim table');
GO


-- Fact_events. --------------------------------------------------------
PRINT ('Creating fact_events table');
GO

DROP TABLE IF EXISTS silver.fact_events;
GO

CREATE TABLE silver.fact_events (
        event_id           INT           NOT NULL,
        employee_id        VARCHAR(10)   NOT NULL,
        event_date         DATE,
        new_job_title      NVARCHAR(100) NULL,
        new_department     NVARCHAR(100) NULL,
        new_salary         INT NULL,
        created_at         DATETIME2, 
        dwh_date_created DATETIME2 DEFAULT SYSUTCDATETIME()
);
GO

PRINT ('Created fact_events table');
GO