
import mne
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from collections import Counter

def create_data():
    df = pd.read_csv('dataNeuroM.csv')
    df['ELO_Cat'] = df.ELO_Cat.map(lambda x : 'Expert' if x == 'Bueno' else 'Novice')

    print(Counter(df.Condicion))
    print(Counter(df.ELO_Cat))

    print(Counter(df[df.ELO_Cat == 'Novice'].Condicion))
    print(Counter(df[df.ELO_Cat == 'Expert'].Condicion))

    df = df.drop(['Aciertos', 'Aciertos_Cat', 'ID', 'ELO'], axis=1).groupby(['ELO_Cat', 'Condicion']).agg('mean')
    df.to_csv('topoplot_data.csv', index=False)
    print(df)

create_data()

# 0 Expert Ambiental
# 1 Expert Blanco
# 0 Novice Ambiental
# 1 Novice Blanco

channels = ['Fz', 'C3', 'Cz', 'C4', 'Pz', 'PO7', 'Oz', 'PO8']
# channels = ['Fz', 'C3', 'C4', 'Cz', 'Pz', 'Oz', 'PO7', 'PO8']

df_all_bands = pd.read_csv('topoplot_data.csv')
df_all_bands.iloc[[0, 1, 2, 3]] = df_all_bands.iloc[[2, 3, 0, 1]].values
print(df_all_bands)

for band in ['Delta', 'Theta', 'Alpha', 'Beta', 'Gamma']:
    df_all = df_all_bands.loc[:, [x for x in df_all_bands.columns if x.split('_')[0] == band]]
    df_all.columns = [x.split('_')[1] for x in df_all.columns]

    groups = ['Novice', 'Expert']

    # minmax = (df_all.min().min(), df_all.max().max())
    fig, axes = plt.subplots(2, 2, dpi=1000)

    # biosemi160 : Chess
    # biosemi32  : NeuroH
    # biosemi256 : BRAIN-MCE

    for j, group in enumerate(groups):
        # 0: 0, 1
        # 1: 2, 3
        df = df_all.iloc[[j*2, j*2 + 1], :].T

        minmax = (df.min().min(), df.max().max())

        df.columns = ['Ambiental', 'White']
        df.index = channels

        montage = mne.channels.make_standard_montage("biosemi160")

        n_channels = len(montage.ch_names)
        data = df.reindex(montage.ch_names)

        info = mne.create_info(ch_names=montage.ch_names, sfreq=250, ch_types='eeg')
        evoked = mne.EvokedArray(np.array(data), info)
        evoked.set_montage(montage)

        for i in range(df.shape[1]):
            mne.viz.plot_topomap(evoked.data[:, i], evoked.info, cmap='viridis', axes=axes[j][i], show=False, vlim=minmax)
            if j == 0:
                axes[j][i].set_title(list(data.columns)[i])
        cbar = fig.colorbar(axes[j][0].images[0], ax=axes[j], orientation='vertical', shrink=0.8, pad=0.05)

    # cbar.set_label('Power')
    # plt.tight_layout()
    # plt.show()

    axes[0][0].set_ylabel('Novice', rotation=0, ha='right', va='center')
    axes[1][0].set_ylabel('Expert', rotation=0, ha='right', va='center')
    plt.savefig('figures/power_topoplot_{}.png'.format(band), dpi=1000, bbox_inches='tight')
    exit()

