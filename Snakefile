# Preprocessing workflow for Mytilus genomes datasets

import pandas as pd
import subprocess
import glob
import os.path

from snakemake.utils import min_version
min_version("5.27.4")

configfile: "configs/config.yaml"

singularity: config['container']

samples_tb = pd.read_csv(config['samples'], sep = '\t').set_index("ind", drop=False)

samples_hiseq = samples_tb[samples_tb['experiment'] == 'Hiseq']['ind'].tolist()
samples_novaseq = samples_tb[samples_tb['experiment'] == 'Novaseq']['ind'].tolist()
samples_mgallo = samples_tb[samples_tb['experiment'] == 'Mgallo']['ind'].tolist()
samples_novaseq_2 = samples_tb[samples_tb['experiment'] == 'Novaseq_2']['ind'].tolist()
samples_ellis = samples_tb[samples_tb['experiment'] == 'ellis']['ind'].tolist()
samples_SRA = samples_tb[samples_tb['experiment'] == 'SRA']['ind'].tolist()

include: "rules/common_preproc.smk"
include: "rules/fastp.smk"
include: "rules/mapping.smk"
include: "rules/markduplicates.smk"
include: "rules/indel_realignment.smk"
include: "rules/final_sort.smk"

rule preprocessing:
    input:
        expand("results/Hiseq/{ind}/{ind}.preproc.bam", ind=samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.bam", ind=samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.preproc.bam", ind=samples_novaseq_2),
        expand("results/ellis/{ind}/{ind}.preproc.bam", ind=samples_ellis),
        expand("results/SRA/{ind}/{ind}.preproc.bam", ind=samples_SRA),


# QC of preprocessing
include: "rules/samtools_stats.smk"
include: "rules/mosdepth.smk"
include: "rules/multiqc_fastp.smk"
include: "rules/multiqc_mapping.smk"

rule quality:
    input:
        "results/multiqc/multiqc_mapping.html",
        "results/multiqc/multiqc_fastp.html",
