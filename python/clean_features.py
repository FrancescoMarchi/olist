import pandas as pd

df = pd.read_csv("../data/raw_export.csv", sep=";")
print(len(df))
print(df.duplicated().sum())

df["order_purchase_timestamp"] = pd.to_datetime(df["order_purchase_timestamp"])

df["year_month"] = df["order_purchase_timestamp"].dt.to_period("M").astype(str)

order_sizes = df.groupby("order_id")["order_id"].transform("count")

print(order_sizes.head(10))
print(order_sizes.min(), order_sizes.max())

df["single_item_order"] = order_sizes == 1

print(df.shape)
print(df.head())
print(df.dtypes)
print(df["single_item_order"].value_counts())
print(df.duplicated().sum())