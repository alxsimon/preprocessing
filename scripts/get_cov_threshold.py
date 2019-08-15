#!/usr/bin/python3

#import sys
from pathlib import PurePath
import pandas as pd

# input is a file containing a list of all mosdepth.global.dist.txt files

coverage_quantile = float(snakemake.params.coverage_quantile)


def get_max_cov(path, q):
    tb = pd.read_csv(path, sep="\t", header=None, names=['chrom', 'cov', 'p'])
    # chromosome, coverage, proportion of bases at this coverage
    tot = tb[tb.chrom == 'total']
    max_cov = min(tot[tot.p < q]['cov'])
    return(max_cov)


# with open(file_list, 'r') as f:
# for file in f.readlines():
with open(str(snakemake.output), 'w') as outfile:
    for file in snakemake.input:
        filepath = PurePath(file.strip())
        max_cov = get_max_cov(filepath, coverage_quantile)
        sample = filepath.stem.replace('.mosdepth.global.dist', '')
        outfile.write(sample + '\t' + str(max_cov))
