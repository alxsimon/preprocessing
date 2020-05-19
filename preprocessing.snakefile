# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - 12 M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)
#   - 20 individuals low-coverage with a 2nd run of Novaseq (Novaseq_2)
#   - Individuals comming from different projects: 3 reference genomes (10X), 2 ancient DNA

# Be careful, results bam files need to be kept to run the quality pipeline

include: "rules/common_preproc.smk"

rule all:
    input:
        expand("results/Mgallo/{ind}/{ind}.preproc.cram", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.cram", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.cram", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.preproc.cram", ind = samples_novaseq_2),
        expand("results/Mgallo/{ind}/{ind}.preproc.cram.crai", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.cram.crai", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.cram.crai", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.preproc.cram.crai", ind = samples_novaseq_2)

include: "rules/fastp.smk"

include: "rules/mapping.smk"

include: "rules/markduplicates.smk"

include: "rules/indel_realignment.smk"

include: "rules/bamtocram.smk"
