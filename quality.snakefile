# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)

include: "rules/common.smk"

rule all:
    input:
        "output/multiqc.html"

include: "rules/qualimap.smk"

include: "rules/smudgeplot.smk"
