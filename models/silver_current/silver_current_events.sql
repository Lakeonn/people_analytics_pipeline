SELECT
    *
FROM {{ source('bronze', 'events') }}