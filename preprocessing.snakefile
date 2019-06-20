# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)

include: "rules/common_preproc.smk"

rule all:
    input:
        expand("results/Mgallo/{ind}/{ind}.preproc.bam", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.bam", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.bam", ind = samples_novaseq)

include: "rules/fastp.smk"

include: "rules/mapping.smk"

include: "rules/markduplicates.smk"

include: "rules/indel_realignment.smk"

include: "rules/bamtocram.smk"

if config['output_cram']:
    include: "rules/bamtocram.smk"
