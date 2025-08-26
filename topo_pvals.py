import pandas as pd
import mne
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import ttest_ind

pd.set_option('display.max_columns', None)

side = 'greater'

def t_test(x, y, alternative = 'both-sided'):
    _, double_p = ttest_ind(x, y, equal_var= False)
    if alternative == 'both-sided':
        pval = double_p
    elif alternative == 'greater':
        if np.mean(x) > np.mean(y):
            pval = double_p / 2
        else:
            pval = 1.0 - double_p / 2
    elif alternative == 'less':
        if np.mean(x) < np.mean(y):
            pval = double_p / 2
        else:
            pval = 1.0 - double_p / 2
    return pval

def create_data():
    df = pd.read_csv('dataNeuroM.csv').drop(['Aciertos', 'Aciertos_Cat', 'ID', 'ELO'], axis=1)
    df['ELO_Cat'] = df.ELO_Cat.map(lambda x : 'Expert' if x == 'Bueno' else 'Novice')

    df_expe = df.loc[df.ELO_Cat == 'Expert', :]
    df_novi = df.loc[df.ELO_Cat == 'Novice', :]

    s_expe = pd.Series([t_test(df_expe.loc[df_expe.Condicion == 'Blanco', :].iloc[:, i],
                               df_expe.loc[df_expe.Condicion == 'Ambiental', :].iloc[:, i],
                               alternative=side) for i in range(len(df.columns) - 2)],
                       index=df.columns[:-2])
    s_novi = pd.Series([t_test(df_novi.loc[df_novi.Condicion == 'Blanco', :].iloc[:, i],
                               df_novi.loc[df_novi.Condicion == 'Ambiental', :].iloc[:, i],
                               alternative=side) for i in range(len(df.columns) - 2)],
                       index=df.columns[:-2])

    df = pd.concat([s_novi, s_expe], axis=1).T
    df.to_csv('topotplot_ttest.csv', index=False)
    print(df)

create_data()

channels = ['Fz', 'C3', 'Cz', 'C4', 'Pz', 'PO7', 'Oz', 'PO8']

# 0 Expert Ambiental
# 1 Expert Blanco
# 2 Novice Ambiental
# 3 Novice Blanco

df_all_bands = pd.read_csv('topotplot_ttest.csv')
print(df_all_bands)
# s_expe = pd.Series((df_all_bands.iloc[1, :] - df_all_bands.iloc[0, :]), index = df_all_bands.columns)
# s_novi = pd.Series((df_all_bands.iloc[3, :] - df_all_bands.iloc[2, :]), index = df_all_bands.columns)x

# s_expe = pd.Series(ttest_ind(df_all_bands.iloc[0, :], df_all_bands.iloc[1, :]), index = df_all_bands.columns)
# s_novi = pd.Series(ttest_ind(df_all_bands.iloc[2, :], df_all_bands.iloc[3, :]), index = df_all_bands.columns)

# df_all_bands = pd.concat([s_novi, s_expe], axis=1).T

minmax = (df_all_bands.min().min(), 0.05)
fig, axes = plt.subplots(2, 5, dpi=1000)

for i, band in enumerate(['Delta', 'Theta', 'Alpha', 'Beta', 'Gamma']):
    df_all = df_all_bands.loc[:, [x for x in df_all_bands.columns if x.split('_')[0] == band]]
    df_all.columns = [x.split('_')[1] for x in df_all.columns]

    # biosemi160 : Chess
    # biosemi32  : NeuroH
    # biosemi256 : BRAIN-MCE

    for j, group in enumerate(['Novice', 'Expert']):
        df = df_all.iloc[j, :]
        df.index = channels

        montage = mne.channels.make_standard_montage("biosemi160")
        n_channels = len(montage.ch_names)
        data = df.reindex(montage.ch_names)

        info = mne.create_info(ch_names=montage.ch_names, sfreq=250, ch_types='eeg')
        evoked = mne.EvokedArray(np.array(data).reshape(-1, 1), info)
        evoked.set_montage(montage)

        mne.viz.plot_topomap(np.squeeze(evoked.data), evoked.info, cmap='viridis', axes=axes[j][i], show=False, vlim=minmax)
        if j == 0:
            axes[j][i].set_title(band)

# cbar = fig.colorbar(axes[0][0].images[0], ax=axes, orientation='horizontal', shrink=0.8, pad=0.05)
cbar = fig.colorbar(axes[1][3].images[0], ax=axes, orientation='horizontal', shrink = 0.5)
cbar.set_label('p-value ({})'.format(side))
# plt.tight_layout()
# plt.show()

axes[0][0].set_ylabel('Novice', rotation=0, ha='right', va='center')
axes[1][0].set_ylabel('Expert', rotation=0, ha='right', va='center')

plt.savefig('figures/pvals_topoplot_{}.png'.format(side), dpi=1000, bbox_inches='tight')

