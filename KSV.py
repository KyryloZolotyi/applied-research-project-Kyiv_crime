import pandas as pd
import numpy as np

df = pd.read_csv('kyiv_cam.csv', sep = ";")

df.dropna(inplace = True)

df.drop_duplicates(inplace = True)

df['Districts'] = np.where(df['District'].str.contains('Дніпровський'), 'Dniprovskyi distr.',
                           np.where(df['District'].str.contains('Печер'), 'Pechersk distr.',
                           np.where(df['District'].str.contains('Оболон'), 'Obolon distr.',
                           np.where(df['District'].str.contains('Шевченк'), 'Shevchenkivskyi distr.',
                           np.where(df['District'].str.contains('Голос'), 'Holosiivskyi distr.',
                           np.where(df['District'].str.contains('Солом'), 'Solomianskyi distr.',
                           np.where(df['District'].str.contains('Шулявка'), 'Solomianskyi distr.',
                           np.where(df['District'].str.contains('Святошин'), 'Sviatoshynskyi distr.',
                           np.where(df['District'].str.contains('Дарницький'), 'Darnytskyi distr.',
                           np.where(df['District'].str.contains('Деснянський'), 'Desnianskyi distr.',
                           np.where(df['District'].str.contains('Подільський'), 'Podilskyi distr.',
                                    'Other distr.')))))))))))

df = df.drop('District', axis=1)

print(df)

df.to_csv('kyiv_cam_modified1.csv', sep=';', index=False)



