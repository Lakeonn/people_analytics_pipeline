/*

*/

USE people_analytics;
GO

--DECLARE @LatestDate DATETIME2;
--SELECT @LatestDate = MAX(created_at) FROM bronze.employees;

-- Inserting data into employees table. 
INSERT INTO bronze.employees (
        employee_id, 
        first_name,
        last_name,
        gender,
        birth_date,
        hire_date,
        termination_date,
        country,
        city,
        job_title,
        department,
        manager_id,
        salary ,
        created_at,
        updated_at, 
        load_date
)

SELECT
    *, 
    GETDATE()
FROM staging.employees
WHERE created_at NOT IN (
    SELECT DISTINCT
        created_at
    FROM bronze.employees)
;
GO



-- Inserting data into events table. 
INSERT INTO bronze.events (
        event_id ,
        employee_id,
        event_type,
        event_date,
        new_job_title,
        new_department,
        new_salary,
        created_at, 
        load_date
)

SELECT 
    *, 
    GETDATE()
FROM staging.events
WHERE created_at NOT IN (
    SELECT DISTINCT
        created_at
    FROM bronze.events)
;
GO