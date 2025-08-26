import pandas as pd
import numpy as np

def process_list(l):
    times = [0, 150, 300, 450, 600]
    l2 = []
    for i in range(4):
        vals = [val for val in l if times[i] < val < times[i + 1]]
        val = np.mean(vals)
        # val = vals[0]
        l2.append(val - times[i])
        print(times[i], times[i + 1], val)
    print(l2)
    return np.mean(l2)

s = pd.read_csv('kurto.csv', index_col=0)
l_peaks = []
with open('data/manual_peaks.txt', 'r') as file:
    for line in file:
        peak = process_list([int(val) for val in line[2:].lstrip().split(', ')])
        l_peaks.append(peak)

pd.Series(l_peaks, index=s.index).to_csv('peaks.csv')
