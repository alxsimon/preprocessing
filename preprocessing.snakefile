# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - 12 M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)
#   - 20 individuals low-coverage with a 2nd run of Novaseq (Novaseq_2)
#   - 54 individuals low-coverage from Robert Ellis
#   - Individuals comming from different projects: 3 reference genomes (10X), 2 ancient DNA

# Be careful, results bam files need to be kept to run the quality pipeline

import pandas as pd
import subprocess
import glob
import os.path

configfile: "configs/config_preproc.yaml"

singularity: config['container']

samples_tb = pd.read_csv(config['samples'], sep = '\t').set_index("ind", drop=False)

samples_hiseq = samples_tb[samples_tb['experiment'] == 'Hiseq']['ind'].tolist()
samples_novaseq = samples_tb[samples_tb['experiment'] == 'Novaseq']['ind'].tolist()
samples_mgallo = samples_tb[samples_tb['experiment'] == 'Mgallo']['ind'].tolist()
samples_novaseq_2 = samples_tb[samples_tb['experiment'] == 'Novaseq_2']['ind'].tolist()
samples_ellis = samples_tb[samples_tb['experiment'] == 'ellis']['ind'].tolist()

include: "rules/common_preproc.smk"

rule all:
    input:
        expand("results/Mgallo/{ind}/{ind}.preproc.cram", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.cram", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.cram", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.preproc.cram", ind = samples_novaseq_2),
        expand("results/ellis/{ind}/{ind}.preproc.cram", ind = samples_ellis),
        expand("results/Mgallo/{ind}/{ind}.preproc.cram.crai", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.cram.crai", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.cram.crai", ind = samples_novaseq),
        expand("results/ellis/{ind}/{ind}.preproc.cram.crai", ind = samples_ellis)

include: "rules/fastp.smk"

include: "rules/mapping.smk"

include: "rules/markduplicates.smk"

include: "rules/indel_realignment.smk"

include: "rules/final_cram.smk"
