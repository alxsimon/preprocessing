# Preprocessing
Snakemake preprocessing workflow for the Mytilus admixed genomes

Heavy files are not included to avoid taking uncessary space but the folder architecture is left.

## Build the Singularity image

Done with Singularity version 3.1.1 but any version > 3 should be ok.

`sudo singularity build container/bioinfo_dm.sif container/bioinfo_dm.def`

## Launch the pipeline

`singularity exec container/bioinfo_dm.sif snakemake`

Works as the current working directory is mounted in the Singularity image and
becomes the working directory.
