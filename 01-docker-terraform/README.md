# Module 1: Docker, SQL, and Terraform

## Homework

###  Question 1
What's the version of pip in the python:3.13 image?

Answer: `25.3`

### Question 2
Given `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

Answer: `postgres:5432`

### Preparing data for questions 3-6

- Downloaded the data:

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet
```
```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```
- Placed in `data/`
- Started PostgreSQL database and pgadmin using `docker-compose up`
- Ingested data using dockerized pipelines:
```bash
docker build -f Dockerfile.green_taxi_ingest -t green_taxi_ingest:v001 .
```
```bash
docker run -it \
    --network 01-docker-terraform_default \
    green_taxi_ingest:v001 \
        --pg-user=postgres \
        --pg-pass=postgres \
        --pg-host=postgres \
        --pg-port=5432 \
        --pg-db=ny_taxi \
        --target-table=green_taxi_data
```

```bash
docker build -f Dockerfile.zone_lookup_ingest -t zone_lookup_ingest:v001 .
```
```bash
docker run -it \
    --network 01-docker-terraform_default \
    zone_lookup_ingest:v001 \
        --pg-user=postgres \
        --pg-pass=postgres \
        --pg-host=postgres \
        --pg-port=5432 \
        --pg-db=ny_taxi \
        --target-table=zone_lookup
```

### Question 3: Counting short trips
For the trips in November 2025 (`lpep_pickup_datetime` between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?
```sql
SELECT COUNT(*) FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2025-11-01'
AND
lpep_pickup_datetime < '2025-12-01'
AND
trip_distance <= 1;
```
Answer: `8007`

### Question 4: Longest trip for each day
Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.
```sql
SELECT lpep_pickup_datetime FROM green_taxi_data
WHERE trip_distance < 100
ORDER BY trip_distance DESC
LIMIT 1;
```
Answer: `2025-11-14`

### Question 5: Biggest pickup zone
Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?
```sql
SELECT zone_lookup."Zone" FROM zone_lookup JOIN
    (
        SELECT "PULocationID" FROM green_taxi_data 
        WHERE lpep_pickup_datetime>='2025-11-18'
            AND lpep_pickup_datetime<'2025-11-19'
        GROUP BY "PULocationID"
        ORDER BY SUM(total_amount) DESC
        LIMIT 1
    ) t ON zone_lookup."LocationID"=t."PULocationID";
```
Answer: `East Harlem North`

### Question 6: Largest tip
For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?
```sql
SELECT zone_lookup."Zone" FROM zone_lookup JOIN
    (
        SELECT "DOLocationID" from green_taxi_data 
        WHERE "PULocationID"=(
            SELECT "LocationID" from zone_lookup
            WHERE "Zone"='East Harlem North'
        )
            AND lpep_pickup_datetime>='2025-11-01'
            AND lpep_pickup_datetime<'2025-12-01'
        ORDER BY tip_amount DESC
        LIMIT 1
    ) t on zone_lookup."LocationID"=t."DOLocationID"
```
Answer: `Yorkville West`

### Question 7: Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform

Answer: `terraform init, terraform apply -auto-approve, terraform destroy`
