/*

*/

USE people_analytics;
GO 

BEGIN TRY
    -- 1. Check if the table already exists before creating it
    IF OBJECT_ID('bronze.employees', 'U') IS NOT NULL
    BEGIN
        -- We manually throw an error so it jumps directly to the CATCH block
        THROW 50001, 'Table bronze.employees already exists.', 1;
    END

    CREATE TABLE bronze.employees (
        employee_id      NVARCHAR(10) PRIMARY KEY, 
        first_name       NVARCHAR(20) NOT NULL,
        last_name        NVARCHAR(20),
        gender           NVARCHAR(20),
        birth_date       DATE,
        hire_date        DATE,
        termination_date DATE,
        country          NVARCHAR(100),
        city             NVARCHAR(100),
        job_title        NVARCHAR(100),
        department       NVARCHAR(100),
        manager_id       NVARCHAR(10),
        salary           MONEY,
        created_at       DATETIME2,
        updated_at       DATETIME2, 
        load_date        DATETIME2
    );

    CREATE INDEX ix_bronze_employees_employee_id
    ON bronze.employees(employee_id);

    CREATE INDEX ix_bronze_employees_hire_date
    ON bronze.employees(hire_date);


    IF OBJECT_ID('bronze.events', 'U') IS NOT NULL
    BEGIN
        -- We manually throw an error so it jumps directly to the CATCH block
        THROW 50001, 'Table bronze.employees already exists.', 1;
    END

    -- Bronze events. 
    CREATE TABLE bronze.events (
        event_id           INT           NOT NULL,
        employee_id        VARCHAR(20)   NOT NULL,
        event_type         NVARCHAR(50),
        event_date         DATE,
        new_job_title      NVARCHAR(100) NULL,
        new_department     NVARCHAR(100) NULL,
        new_salary         NVARCHAR(100) NULL,
        created_at         DATETIME2, 
        load_date        DATETIME2
    );

    CREATE INDEX ix_bronze_events_employee_id
    ON bronze.events (employee_id);

    PRINT 'Table and indexes created successfully.';

END TRY
BEGIN CATCH
    -- Print the actual system error message
    PRINT ERROR_MESSAGE();
    
    PRINT 'Table creation failed or already exists.'; 
END CATCH;
GO