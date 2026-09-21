/*

*/

WITH unique_department AS (
    SELECT DISTINCT
        department
    FROM {{ ref('silver_historical_employees') }}
    WHERE department IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['department']) }} as department_id, 
    CAST(department AS NVARCHAR(100)) AS department, 
    cast('{{ modules.datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S") }}' as datetime2) as dwh_date_created
FROM unique_department;