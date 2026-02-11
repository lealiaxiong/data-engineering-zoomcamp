# Module 3: Data Warehousing

## Homework

```sql
CREATE OR REPLACE EXTERNAL TABLE `project-37461d80-d5a2-4760-9d3.ny_taxi.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://project-37461d80-d5a2-4760-9d3-data-warehouse-demo-bucket/yellow_tripdata_2024-*.parquet']
);

CREATE OR REPLACE TABLE `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned` AS SELECT * FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.external_yellow_tripdata`;
```

### Question 1
What is count of records for the 2024 Yellow Taxi Data?

```sql
SELECT COUNT(*) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`;
```

`20332093`

### Question 2
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.

What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT COUNT(DISTINCT PULocationID) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.external_yellow_tripdata`;

SELECT COUNT(DISTINCT PULocationID) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`;
```

`0 MB for the External Table and 155.12 MB for the Materialized Table`

### Question 3
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

Why are the estimated number of Bytes different?

```sql
SELECT PULocationID FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`;

SELECT PULocationID, DOLocationID FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`;
```

`BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.`

### Question 4
How many records have a fare_amount of 0?

```sql
SELECT COUNT(*) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`
    WHERE fare_amount = 0;
```

`8333`

### Question 5
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

`Partition by tpep_dropoff_datetime and Cluster on VendorID`

```sql
CREATE OR REPLACE TABLE `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.external_yellow_tripdata`;
```

### Question 6
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

```sql
SELECT COUNT(DISTINCT VendorID) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01 00:00:00' AND '2024-03-15 23:59:59';

SELECT COUNT(DISTINCT VendorID) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_non_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01 00:00:00' AND '2024-03-15 23:59:59';
```

`310.24 MB for non-partitioned table and 26.84 MB for the partitioned table`

### Question 7
Where is the data stored in the External Table you created?

`GCP Bucket`

### Question 8
It is best practice in Big Query to always cluster your data:

`True`

### Question 9
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read?

```sql
SELECT COUNT(*) FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.yellow_tripdata_partitioned`;
```
`BigQuery does not need to read the data to determine the number of rows; the number of rows is stored as metadata.`