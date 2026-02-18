# Homework 4

## Question 1:
Given a dbt project with the following structure:

```
models/
├── staging/
│   ├── stg_green_tripdata.sql
│   └── stg_yellow_tripdata.sql
└── intermediate/
    └── int_trips_unioned.sql (depends on stg_green_tripdata & stg_yellow_tripdata)
```

If you run `dbt run --select int_trips_unioned`, what models will be built?

`int_trips_unioned only`

## Question 2:
You've configured a generic test like this in your `schema.yml`:

```yaml
columns:
  - name: payment_type
    data_tests:
      - accepted_values:
          arguments:
            values: [1, 2, 3, 4, 5]
            quote: false
```

Your model `fct_trips` has been running successfully for months. A new value `6` now appears in the source data.

What happens when you run `dbt test --select fct_trips`?

`dbt fails the test with non-zero exit code`

## Question 3:
After running your dbt project, query the `fct_monthly_zone_revenue` model.

What is the count of records in the `fct_monthly_zone_revenue` model?

```sql
SELECT COUNT(*) FROM fct_monthly_zone_revenue
```

## Question 4:
Using the `fct_monthly_zone_revenue` table, find the pickup zone with the **highest total revenue** (`revenue_monthly_total_amount`) for **Green** taxi trips in 2020.

Which zone had the highest revenue?

```sql
SELECT pickup_zone FROM `project-37461d80-d5a2-4760-9d3.dbt_prod.fct_monthly_zone_revenue`
  WHERE service_type = "Green" AND
    revenue_month BETWEEN DATETIME '2020-01-01 00:00:00' AND DATETIME '2025-12-31 23:59:59'
  GROUP BY pickup_zone
  ORDER BY SUM(revenue_monthly_total_amount) DESC
  LIMIT 1;
```

`East Harlem North`

## Question 5:
Using the `fct_monthly_zone_revenue` table, what is the **total number of trips** (`total_monthly_trips`) for Green taxis in October 2019?

```sql
SELECT SUM(total_monthly_trips) FROM `project-37461d80-d5a2-4760-9d3.dbt_prod.fct_monthly_zone_revenue`
  WHERE service_type = "Green" AND
    revenue_month BETWEEN DATETIME '2019-10-01 00:00:00' AND DATETIME '2019-10-31 23:59:59';
```

`384624`

## Question 6:
Create a staging model for the **For-Hire Vehicle (FHV)** trip data for 2019.

1. Load the [FHV trip data for 2019](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv) into your data warehouse
2. Create a staging model `stg_fhv_tripdata` with these requirements:
   - Filter out records where `dispatching_base_num IS NULL`
   - Rename fields to match your project's naming conventions (e.g., `PUlocationID` → `pickup_location_id`)

What is the count of records in `stg_fhv_tripdata`?

`43244693`