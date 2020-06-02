# Preprocessing workflow for Mytilus genomes datasets
# Three sequencing experiments are processed
#   - M. galloprovincialis genomes produced by Carlos Canchaya in high coverage (Mgallo)
#   - 48 individuals low-coverage with HiSeq (Hiseq)
#   - 96 individuals low-coverage with NovaSeq (Novaseq)
#   - 20 individuals low-coverage with a 2nd run of Novaseq (Novaseq_2)

include: "rules/common_quality.smk"

rule all:
    input:
        "results/multiqc/multiqc_mapping.html",
        "results/multiqc/multiqc_fastp.html",
        "output/max_coverage"

include: "rules/samtools_stats.smk"

include: "rules/mosdepth.smk"

include: "rules/multiqc_fastp.smk"

include: "rules/multiqc_mapping.smk"


rule get_cov_threshold:
    input:
        expand("results/Mgallo/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq_2)
    output:
        "output/max_coverage"
    params:
        coverage_quantile = config['coverage_quantile']
    script:
        "../scripts/get_cov_threshold.py"