import numpy as np
from scipy.interpolate import UnivariateSpline, CubicSpline
import pandas as pd
from scipy.stats import kurtosis

# Calculate peak curtosis based in the "manual_peak" file

# Define function for smoothing
def smooth_spline(x, y, smoothing_span):
    # spline = UnivariateSpline(x, y, s=1 - 1 / smoothing_span)
    cs = CubicSpline(x, y)
    smoothed_values = cs(x)
    return smoothed_values


df = pd.read_csv('dataNeuro.csv', index_col=0)
print(df)

smoothing_span = 2

kurtosis_values = {}
for subject in df.ID.unique():
    data = df[df.ID == subject].loc[:, 'Theta_C4'].reset_index(drop=True)
    smoothed_values = smooth_spline(np.arange(len(data)), data, smoothing_span)
    l = []
    for i in range(4):
        data_sub = smoothed_values[(i*150):(i+1)*150]
        l.append(kurtosis(data_sub))
    print(subject, l)
    kurtosis_values[subject] = np.median(l)

pd.Series(kurtosis_values.values(), index=kurtosis_values.keys()).to_csv('kurto.csv')
