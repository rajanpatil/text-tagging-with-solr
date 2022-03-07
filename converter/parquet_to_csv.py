import pandas as pd

parquet_file = "./sample.parquet"
csv_file = "./sample.csv"
df = pd.read_parquet(parquet_file)
df.to_csv(csv_file)
