import os
import pandas as pd
# from brainflow import DataFilter
import numpy as np
from scipy.signal import welch
from sklearn.preprocessing import MinMaxScaler, StandardScaler
from scipy.integrate import simps

pd.set_option('display.max_columns', None)

# df_des = pd.read_csv('data/descriptive_data.csv').drop(['ELO_Ajst', 'Frecuencia', 'Cafes', 'Horas', 'Ansiedad', 'Nombre'], axis=1)
# df_des['ELO'] = df_des.ELO.ffill()
# df_des.loc[df_des.ID == 35, 'ELO'] = 1100

df_des = pd.read_csv('data/descriptive_data2.csv')

sequences = [[1, 2, 3, 4], [4, 3, 2, 1], [2, 1, 4, 3], [3, 4, 1, 2], [1, 4, 3, 2], [4, 1, 2, 3], [2, 4, 1, 3],
             [3, 1, 4, 2], [1, 3, 2, 4], [4, 2, 3, 1], [2, 3, 1, 4], [3, 2, 4, 1], [1, 3, 4, 2], [4, 2, 1, 3],
             [2, 4, 3, 1], [3, 1, 2, 4], [1, 2, 4, 3], [4, 3, 1, 2]]
order_to_seq = dict(zip(range(1, len(sequences) + 1), sequences))

frecuencia = {}

l_exe = ['FS', 'FM', 'DS', 'DM']
# l_exe = ['F', 'F', 'D', 'D']
freq_bands = {'Delta': [1, 4], 'Theta': [4, 8], 'Alpha': [8, 13], 'Beta': [13, 30], 'Gamma': [30, 49]}
channels = ['Fz', 'C3', 'Cz', 'C4', 'Pz', 'PO7', 'Oz', 'PO8']
channel_bands = [b + '_' + c for b in freq_bands.keys() for c in channels]

def calc_bands(s, band):
    sr = 250
    window_size = 4

    wf = 3  # Windows function (0: No Window, 1: Hanning, 2: Hamming, 3: Blackman Harris)
    nfft = DataFilter.get_nearest_power_of_two(sr)
    over = DataFilter.get_nearest_power_of_two(sr) // 2

    # Assuming 6 s windows
    # a = np.zeros(shape=(s.shape[0], ))
    a = []
    for n in range(s.shape[0] // (nfft * 4)):
        # b = np.array(s.iloc[(w * sr):((w + 6) * sr)])

        # Calculate the PSD using the Welch method with specified window parameters
        psd = DataFilter.get_psd_welch(data=np.array(s[(n * nfft):((n    + 1) * nfft)]).astype(float),
                                       nfft=nfft, overlap=over, sampling_rate=sr, window=wf)

        # Calculate the average alpha power (e.g., for alpha frequency range of 8-13 Hz)
        power = DataFilter.get_band_power(psd, freq_bands[band][0], freq_bands[band][1])
        a.append(power)

        # s[(w * sr):((w + 6) * sr)] = a
        # a[(w * sr):((w + 6) * sr)] = b
        # w += 6
    return a

def calc_bands2(s, band, seconds):
    sampling_rate = 250

    def calculate_band_power(data):
        # Calculate PSD
        freqs, psd = welch(data, fs=sampling_rate, nperseg=window_size, axis=0)
        # psd = 10 * np.log10(psd)

        freq_res = freqs[1] - freqs[0]
        low, high = freq_bands[band]
        idx_band = np.logical_and(freqs >= low, freqs <= high)

        return simps(psd[idx_band], dx=freq_res)
        # band_indices = np.where((psd >= low) & (psd < high))[0]
        # return np.sum(psd[band_indices])

    # Calculate the number of windows
    window_size = seconds * sampling_rate  # 4 seconds * sampling rate
    num_windows = len(s) // window_size

    a = []
    # Iterate over 4-second windows and calculate PSD and Band Power
    for i in range(num_windows):
        start_index = i * window_size
        end_index = start_index + window_size

        # Extract data for the current window
        window_data = s[start_index:end_index]

        # Calculate PSD and Band Power for the window
        a.append(calculate_band_power(window_data))
    return a

def get_data():
    fs = 250
    window_second = 1
    nfft = DataFilter.get_nearest_power_of_two(fs)
    prime_time = lambda t: (fs * t) / nfft

    times = []
    test_times = [30, 30, 150, 150, 150, 150]
    for i in range(len(test_times)):
        past_time = 0
        for j in range(i - 1, -1, -1):
            past_time += prime_time(test_times[j])
        times.append(int(prime_time(test_times[i]) + past_time))
    times = [times[i] - times[i-1] if i != 0 else times[i] for i in range(len(times))]
    times = [int(x/window_second) for x in test_times]

    folder = 'data/csv_ICA'
    df = pd.DataFrame(columns=channel_bands + ['ID', 'Fase'])

    for csv_file in os.listdir(folder):
        print(csv_file)
        curr_id = int(csv_file[1:3])
        if curr_id in [26, 36]:
            continue

        curr_df = pd.read_csv(folder + '/' + csv_file, header=None)
        curr_df.columns = channels

        band_df = pd.DataFrame(columns=channel_bands)
        for channel in channels:
            for band in freq_bands.keys():
                band_df[band + '_' + channel] = calc_bands2(curr_df[channel], band, window_second)

        n_ord = int(df_des[df_des.ID == curr_id].Orden)
        l_ord = [l_exe[order_to_seq[n_ord].index(i + 1)] for i in range(len(l_exe))]
        band_df['Fase'] = times[0] * ['EO'] + times[1] * ['EC'] + times[2] * [l_ord[0]] \
                          + times[3] * [l_ord[1]] + times[4] * [l_ord[2]] + times[5] * [l_ord[3]]

        # scaler = MinMaxScaler().fit(band_df[band_df.Fase.isin(['EO'])].drop(['Fase'], axis=1))
        mu = band_df[band_df.Fase.isin(['EO'])].drop(['Fase'], axis=1).mean()
        band_df = band_df[~band_df.Fase.isin(['EO', 'EC'])]
        y = band_df.pop('Fase').reset_index(drop=True)
        band_df = (band_df - mu)/mu
        # band_df = pd.DataFrame(scaler.transform(band_df), columns=channel_bands)

        band_df['ID'] = curr_id
        band_df['Fase'] = y

        df = pd.concat([df, band_df], axis=0)

    return df.reset_index(drop=True)


df = get_data()
df.to_csv('dataNeuro.csv')
df = pd.read_csv('dataNeuro.csv', index_col=0)
# exit()

from math import log


def mean_pond(df, dist, ord):

    dist_dict = {'Expo': lambda x : np.exp(-x),
                 'Line': lambda x : -(1/5)*x+1,
                 'Loga': lambda x : (1/log(6))*np.log(-x+6),
                 'Tanh': lambda x : 0.5*np.tanh(-(x-2.5))+0.5,
                 'Sigm': lambda x : 2/(1+np.exp(x)),
                 'Norm': lambda x : x}

    sel_dist = dist_dict[dist]

    def mean_dist(x):
        t = np.linspace(0, 5, x.shape[0])
        return sum(np.multiply(sel_dist(t), x)) / sum(sel_dist(t))

    df_mean = pd.DataFrame(columns=df.columns)
    for curr_id in df.ID.unique():
        df_id = df[df.ID == curr_id]
        df_subject = pd.DataFrame(columns=channel_bands)

        n_ord = int(df_des[df_des.ID == curr_id].Orden)
        l_ord = [l_exe[order_to_seq[n_ord].index(i + 1)] for i in range(len(l_exe))]

        for curr_exe in l_ord:
            curr_df = df_id[df_id.Fase.isin([curr_exe])]

            # x = pd.DataFrame(curr_df.drop(['ID', 'Fase'], axis=1).apply(mean_dist, axis=0)).T
            x = pd.DataFrame(curr_df.drop(['ID', 'Fase'], axis=1).apply(np.median, axis=0)).T
            df_subject = pd.concat([df_subject, x], axis=0)

        if not ord:
            df_subject = pd.DataFrame(df_subject.apply(np.mean, axis=0)).T
            df_subject.columns = channel_bands
        # df_subject['Fase'] = l_ord
        df_subject['ID'] = curr_id
        df_mean = pd.concat([df_mean, df_subject], axis=0)

    if not ord:
        df_mean = df_mean.drop('Fase', axis=1)

    return df_mean.reset_index(drop=True)


dist_func = 'Norm'
df = mean_pond(df, dist_func, ord=False)
df = df.merge(df_des.drop(['Orden'], axis=1), how='inner', on='ID')
df['ELO_Cat'] = df.ELO.map(lambda x: 'Malo' if x < 1200 else 'Bueno')
df['Aciertos_Cat'] = df.Aciertos.map(lambda x: 'Malo' if x < 2 else 'Bueno')
print(df)
df.reset_index(drop=True).to_csv('dataNeuroM.csv', index=False)
exit()
df = pd.read_csv('dataNeuroM_Ord.csv')
# exit()

from collections import Counter
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import seaborn as sns
from sklearn.feature_selection import mutual_info_classif

from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix

var_analizar = 'Condicion'  # 'ELO_Cat'
var_control = 'ELO_Cat'

l_control = ['Malo', 'Bueno']

y = pd.Categorical(df[var_analizar])
x = df.drop(['ID', var_control, var_analizar, 'ELO'], axis=1)
s = pd.Series(data=mutual_info_classif(x, y), index=x.columns).sort_values(ascending=False)

spectral_colors = {'Delta': 'darkgrey', 'Theta': 'mediumslateblue', 'Alpha': 'lightcoral',
                   'Beta': 'cornflowerblue', 'Gamma': 'wheat'}

n_feat = 20
fig = plt.figure()
plt.bar(s.index[:n_feat], s[:n_feat], color=[spectral_colors[feat.split('_')[0]] for feat in s.index[:n_feat]])
plt.xlabel('Característica')
plt.ylabel("Mutual importance (MI)")
plt.title('Best {} feature using MI, mean={}, target={}'.format(n_feat, dist_func, var_analizar))
plt.xticks(rotation=90)
plt.legend(handles=[mpatches.Patch(color=spectral_colors[spectral_band], label=spectral_band) for spectral_band in freq_bands.keys()])
# fig.savefig('figures/mean/{}/{}_barplot_MI.png'.format(var_analizar, dist_func), bbox_inches='tight')

for var in l_control:
    df_sub = df[df[var_control] == var]

    y = df_sub.pop(var_analizar)
    x = df_sub.drop(['ID', var_control, 'ELO'], axis=1)
    print(Counter(y))

    x['Categoria'] = pd.Series(y)
    fig = plt.figure()
    ax = fig.gca()
    sns.scatterplot(x='Beta_Oz', y='Beta_Pz', data=x, alpha=0.2, hue='Categoria')
    plt.xlabel('Theta_C4')
    plt.ylabel('Gamma_C4')
    plt.title('Scatterplot mean {}, using MI, target={} [{}]'.format(dist_func, var_analizar, var))
    plt.legend()
    # plt.show()
    # plt.gcf().savefig('figures/mean/{}/{}_NormEO_MI_Scatter_{}.png'.format(var_analizar, dist_func, var), bbox_inches='tight')

y = df.pop(var_analizar)
x = df.drop(['ID', var_control, 'ELO'], axis=1)
print(Counter(y))

x['Categoria'] = pd.Series(y)
fig = plt.figure()
ax = fig.gca()
sns.scatterplot(x='Theta_C4', y='Gamma_C4', data=x, alpha=0.2, hue='Categoria')
plt.xlabel('Theta_C4')
plt.ylabel('Gamma_C4')
plt.title('Scatterplot mean {}, using MI, target={} [{}]'.format(dist_func, var_analizar, var))
plt.legend()
plt.show()