# Module 2: Workflow Orchestration

## Homework

Question 1. Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

`134.5 MiB`

 Question 2. What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

 `green_tripdata_2020-04.csv`

 Question 3. How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

```sql
SELECT count(filename) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata` WHERE REGEXP_CONTAINS(filename, r"yellow_tripdata_2020")
```

`24,648,499`

Question 4. How many rows are there for the Green Taxi data for all CSV files in the year 2020?

```sql
SELECT count(filename) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.green_tripdata` WHERE REGEXP_CONTAINS(filename, r"green_tripdata_2020")
```

`1734051`

Question 5. How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

```sql
SELECT count(*) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata` WHERE filename = "yellow_tripdata_2021-03.csv"
```

`1925152`

Question 6. How would you configure the timezone to New York in a Schedule trigger?

`Add a timezone property set to America/New_York in the Schedule trigger configuration`