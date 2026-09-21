-- tests/assert_events_have_valid_employees.sql
-- This test fails if there are events tied to an employee_id that doesn't exist.

select 
    evt.employee_id
from {{ ref('silver_current_events') }} as evt
left join {{ ref('silver_current_employees') }} as emp
    on evt.employee_id = emp.employee_id
where emp.employee_id is null 
  and evt.employee_id is not null
