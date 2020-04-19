# Preprocessing
Snakemake preprocessing workflow for the Mytilus admixed genomes

Heavy files are not included to avoid taking uncessary space but the folder architecture is left.

## Build the Singularity image

Use Singularity with version 3+.

`sudo singularity build container/preprocessing_container.sif container/preprocessing_container.def`

## Launch the pipeline

```
singularity exec container/preprocessing_container.sif \
snakemake -j {#CPUs} -s preprocessing.snakefile

singularity exec container/preprocessing_container.sif \
snakemake -j {#CPUs} -s quality.snakefile
```

Works as the current working directory is mounted in the Singularity image and becomes the working directory.
