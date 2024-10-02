#!/usr/bin/env bash

for batch in {1..10}; do
  snakemake \
  --software-deployment-method conda apptainer \
  --apptainer-args "-B /data2:/data2" \
  --rerun-incomplete \
  -c 50 \
  --batch preprocessing=${batch}/10 \
  $1
  # -U results/Hiseq/JapSea-07/JapSea-07.preproc.bam \
done
