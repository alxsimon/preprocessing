import pandas as pd
import subprocess
import glob
import os.path

configfile: "config_quality.yaml"

singularity: config['container']

samples_tb = pd.read_csv(config['samples'], sep = '\t').set_index("sample", drop=False)

samples_hiseq = samples_tb[samples_tb['experiment'] == 'Hiseq']['sample'].tolist()
samples_novaseq = samples_tb[samples_tb['experiment'] == 'Novaseq']['sample'].tolist()
samples_mgallo = samples_tb[samples_tb['experiment'] == 'Mgallo']['sample'].tolist()
