# Preprocessing
Snakemake preprocessing workflow for the Mytilus admixed genomes

Heavy files are not included to avoid taking uncessary space but the folder architecture is left.

## Build the Singularity image

Use Singularity with version 3+.

`sudo singularity build container/preprocessing_container.sif container/preprocessing_container.def`

## Launch the pipeline

```
conda activate snake_env
snakemake -s preprocessing.snakefile --use-singularity -j {cores}

snakemake -s quality.snakefile --use-singularity -j {cores}
```
