import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import pearsonr,spearmanr  

df = pd.read_csv('cte2_202501190643.csv', sep = ";")

corr1, p1_value = pearsonr(df["cam_per_km"], df["crime_per_km"])
corr2, p2_value = spearmanr(df["cam_per_km"], df["crime_per_km"])


print(f"Pearson correlation coefficient: {corr1:.3f}")
print(f"P - value: {p1_value:.5f}")
print(f"Spearman correlation coefficient: {corr2:.3f}")
print(f"P - value: {p2_value:.5f}")

#  Scatter Plot
plt.figure(figsize=(8, 6))
sns.scatterplot(x=df["cam_per_km"], y=df["crime_per_km"], alpha=0.7)
sns.regplot(x=df["cam_per_km"], y=df["crime_per_km"], scatter=False, color="black")
plt.xlabel("cam_density")
plt.ylabel("crime_density")
plt.title(f"corr between cameras and crimes")

plt.show()

