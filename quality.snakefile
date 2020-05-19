# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)
#   - 20 individuals low-coverage with a 2nd run of Novaseq (Novaseq_2)

include: "rules/common_quality.smk"

rule all:
    input:
        "output/multiqc/multiqc_mapping.html",
        "output/multiqc/multiqc_fastp.html",
        "output/max_coverage"

include: "rules/qualimap.smk"

include: "rules/mosdepth.smk"

include: "rules/multiqc_fastp.smk"

include: "rules/multiqc_mapping.smk"

