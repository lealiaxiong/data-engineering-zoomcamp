import polars as pl
from tqdm.auto import tqdm
import argparse

filepath = "data/green_tripdata_2025-11.parquet"
batch_size = 100000


def run(
    pg_user: str,
    pg_pass: str,
    pg_host: str,
    pg_port: int,
    pg_db: str,
    target_table: str,
):
    """
    Ingest data from parquet file into target table in postgresql database.
    """
    db_uri = f"postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}"
    lazy_df = pl.scan_parquet(filepath)

    for i, batch_df in tqdm(enumerate(lazy_df.collect_batches(chunk_size=batch_size))):
        # Create table on first iteration
        if i == 0:
            batch_df.head(0).write_database(
                table_name=target_table, connection=db_uri, if_table_exists="replace"
            )
        batch_df.write_database(
            table_name=target_table, connection=db_uri, if_table_exists="append"
        )

        print(f"\nInserted: {len(batch_df)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pg-user", default="postgres", help="PostgreSQL user")
    parser.add_argument("--pg-pass", default="postgres", help="PostgreSQL password")
    parser.add_argument("--pg-host", default="localhost", help="PostgreSQL host")
    parser.add_argument("--pg-port", default=5433, type=int, help="PostgreSQL port")
    parser.add_argument("--pg-db", default="ny_taxi", help="PostgreSQL database name")
    parser.add_argument(
        "--target-table", default="green_taxi_data", help="Target table name"
    )
    args = parser.parse_args()

    run(
        pg_user=args.pg_user,
        pg_pass=args.pg_pass,
        pg_host=args.pg_host,
        pg_port=args.pg_port,
        pg_db=args.pg_db,
        target_table=args.target_table,
    )
