{% snapshot silver_historical_employees %}

{{
    config(
      target_database=env_var('SQLSERVER_DB'),
      target_schema='silver_historical',
      unique_key='employee_id',
      strategy='check',
      check_cols=['department', 'salary', 'job_title']
    )
}}

select
    *
from {{ ref('silver_current_employees') }}

{% endsnapshot %}
