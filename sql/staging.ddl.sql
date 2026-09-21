/*
This creates the tables needed for the two csv files. 
Idempotency is ensure. This would drop the table, 
if it already exists, and then recreate it. 
*/

USE people_analytics;
GO 


---- Creating staging table for employees. 
DROP TABLE IF EXISTS staging.employees;
GO

CREATE TABLE staging.employees (
        employee_id      NVARCHAR(10) PRIMARY KEY, 
        first_name       NVARCHAR(200) NOT NULL,
        last_name        NVARCHAR(200),
        gender           NVARCHAR(20),
        birth_date       DATE,
        hire_date        DATE,
        termination_date DATE,
        country          NVARCHAR(200),
        city             NVARCHAR(200),
        job_title        NVARCHAR(200),
        department       NVARCHAR(100),
        manager_id       NVARCHAR(10),
        salary           MONEY,
        created_at       DATETIME2,
        updated_at       DATETIME2
    );
GO


-- Creating staging table for events. 
DROP TABLE IF EXISTS staging.events;
GO

CREATE TABLE staging.events (
        event_id           INT           NOT NULL,
        employee_id        VARCHAR(10)   NOT NULL,
        event_type         NVARCHAR(50),
        event_date         DATE,
        new_job_title      NVARCHAR(100) NULL,
        new_department     NVARCHAR(100) NULL,
        new_salary         NVARCHAR(50) NULL,
        created_at         DATETIME2
    );
GO