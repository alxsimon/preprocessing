#!/usr/bin/env bash

for batch in {1..10}; do
  snakemake --profile workflow/profiles/default \
  -c 48 --batch preprocessing=${batch}/10 \
  $1 \
  preprocessing
done

# snakemake --use-singularity --use-conda \
# --singularity-args "-B /data2:/data2" \
# --rerun-incomplete \
# -c 64 --batch preprocessing=1/10 \
# $1 \
# preprocessing
