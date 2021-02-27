# Preprocessing
Snakemake preprocessing workflow for the Mytilus genome resequencing.

Heavy files are not included to avoid taking uncessary space but the folder architecture is left.

## Build the Singularity image

Use Singularity with version 3+.

`sudo singularity build container/preprocessing_container.sif container/preprocessing_container.def`

## Launch part of pipeline locally for example

```
conda activate snake_env
snakemake --use-singularity --singularity-args "-B ..." \
--use-conda --conda-prefix mamba \
-j {cores} preprocessing
```

## Launch the pipeline on a Slurm cluster

Use the files `cluster_ifb_preproc.slurm` and `cluster_ifb_quality.slurm`