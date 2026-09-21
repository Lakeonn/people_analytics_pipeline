select
    -- dbt generates a unique surrogate key for each historical row using dbt_utils
    {{ dbt_utils.generate_surrogate_key(['employee_id', 'dbt_valid_from']) }} as employee_key,
    employee_id,
    first_name, 
    last_name, 
    gender, 
    birth_date, 
    hire_date, 
    termination_date, 
    manager_id, 
    created_at, 
    updated_at, 
    dbt_valid_from as row_effective_date,
    coalesce(dbt_valid_to, '9999-12-31') as row_expiration_date,
    case when dbt_valid_to is null then 1 else 0 end as is_current_record
from {{ ref('silver_historical_employees') }}
