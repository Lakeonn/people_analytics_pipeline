WITH cte AS (
SELECT
    *, 
    ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY load_date DESC) AS rank
FROM {{ source('bronze', 'employees') }}
)

SELECT 
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
FROM cte
ORDER BY employee_id
WHERE rank = 1;