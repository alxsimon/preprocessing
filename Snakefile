# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - 12 M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)
#   - 20 individuals low-coverage with a 2nd run of Novaseq (Novaseq_2)
#   - 54 individuals low-coverage from Robert Ellis

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

include: "rules/common_preproc.smk"
include: "rules/fastp.smk"
include: "rules/mapping.smk"
include: "rules/markduplicates.smk"
include: "rules/indel_realignment.smk"
include: "rules/final_cram.smk"

rule preprocessing:
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


include: "rules/samtools_stats.smk"
include: "rules/mosdepth.smk"
include: "rules/multiqc_fastp.smk"
include: "rules/multiqc_mapping.smk"

rule quality:
    input:
        "results/multiqc/multiqc_mapping.html",
        "results/multiqc/multiqc_fastp.html",
        "results/max_coverage"


rule get_cov_threshold:
    input:
        expand("results/Mgallo/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq_2),
        expand("results/ellis/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_ellis)
    output:
        "results/max_coverage"
    params:
        coverage_quantile = config['coverage_quantile']
    script:
        "scripts/get_cov_threshold.py"