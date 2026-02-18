CREATE OR REPLACE EXTERNAL TABLE `project-37461d80-d5a2-4760-9d3.ny_taxi.external_fhv_tripdata`
  OPTIONS (
    format = 'CSV',
    uris = ['gs://project-37461d80-d5a2-4760-9d3-dbt-demo-bucket/*.csv.gz']
  );

  CREATE OR REPLACE TABLE `project-37461d80-d5a2-4760-9d3.ny_taxi.fhv_tripdata` AS 
    SELECT * FROM `project-37461d80-d5a2-4760-9d3.ny_taxi.external_fhv_tripdata`;