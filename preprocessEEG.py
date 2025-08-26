# Author: Milton Candela (https://github.com/milkbacon)
# Date: Septembrer 2023

import os
import pandas as pd

fs = 250
# Remove the first 30 seconds, and also n last seconds, where n is the number of additional seconds > 690
for data in os.listdir('data/raw/csv'):

    df = pd.read_csv('data/raw/csv/{}'.format(data)).iloc[(fs * 30):, :8]
    if df.shape[0] > fs * 660:
        df = df.iloc[:(fs * 660), :].reset_index(drop=True)
        df.to_csv('data/raw/txt/{}.txt'.format(data[:3]), index=False, header=False)
        print(data, 'Processed!')
    else:
        print(data, 'Not Processed!')

# No tenemos datos: P09, P11, P19, P23, P32, P33
