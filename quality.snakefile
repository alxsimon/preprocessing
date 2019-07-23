# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)

include: "rules/common_quality.smk"

rule all:
    input:
        "output/multiqc/multiqc_mapping.html",
        "output/multiqc/multiqc_fastp.html",
        expand("output/Mgallo/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_mgallo),
        expand("output/Hiseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_hiseq),
        expand("output/Novaseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq)


include: "rules/qualimap.smk"

include: "rules/multiqc_fastp.smk"

include: "rules/multiqc_mapping.smk"

include: "rules/mosdepth.smk"
