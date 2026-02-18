SELECT 
    -- identifiers
    cast(dispatching_base_num as string) as dispatching_base_num,
    cast(pulocationid as integer) as pickup_location_id,
    cast(dolocationid as integer) as dropoff_location_id,

    -- timestamps (standardized naming)
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    cast(sr_flag as int) as sr_flag,
    cast(affiliated_base_number as string) as affiliated_base_number
FROM {{ source('raw_data', 'fhv_tripdata')}}
WHERE dispatching_base_num is not null