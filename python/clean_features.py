import pandas as pd

df = pd.read_csv("../data/raw_export.csv", sep=";")

df["order_purchase_timestamp"] = pd.to_datetime(df["order_purchase_timestamp"])

df["year_month"] = df["order_purchase_timestamp"].dt.to_period("M").astype(str)

order_sizes = df.groupby("order_id")["order_id"].transform("count")
df["single_item_order"] = order_sizes == 1

print(df.shape)
print(df.dtypes)

df.to_csv("../data/olist_cleaned.csv", index=False)