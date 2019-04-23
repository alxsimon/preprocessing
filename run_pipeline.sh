#!/usr/bin/env bash

# Command lines to launch the preprocessing pipeline
# after having copied the prepared container image
# and the raw data to the local machine.

cd ~/Preprocessing

singularity exec container/bioinfo_dm.sif snakemake -j 60 --keep-going > logs/full_pipeline.log
