# Preprocessing
Snakemake preprocessing workflow for the Mytilus admixed genomes

Heavy files are not included to avoid taking uncessary space but the folder architecture is left.

## Build the Singularity image

Use Singularity with version 3+.

`sudo singularity build container/preprocessing_container.sif container/preprocessing_container.def`

## Launch the pipeline locally

```
conda activate snake_env
snakemake --use-singularity -j {cores} prerocessing
snakemake --use-singularity -j {cores} quality
```

## Launch the pipeline on a Slurm cluster

Use the files `cluster_ifb_preproc.slurm` and `cluster_ifb_quality.slurm`