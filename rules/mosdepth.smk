rule mosdepth:
    input:
        "results/{exp}/{sample}/{sample}.preproc.cram"
    output:
        "output/{exp}/{sample}/mosdepth/{sample}.mosdepth.global.dist.txt"
    log:
        "logs/{exp}/mosdepth_{sample}.log"
    params:
        window = config['mosdepth_window'],
        prefix = "output/{exp}/{sample}/mosdepth/{sample}",
        ref = config['ref_fasta']
    threads:
        config['mosdepth_threads']
    shell:
        "MOSDEPTH_PRECISION=5 "
        "mosdepth "
        "-f {params.ref} "
        "-t {threads} "
        "{params.prefix} "
        "{input} "
        "|& tee {log}"

rule get_cov_threshold:
    input:
        expand("output/Mgallo/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind=samples_mgallo),
        expand("output/Hiseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind=samples_hiseq),
        expand("output/Novaseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq),
        expand("output/Novaseq_2/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind=samples_novaseq_2)
    output:
        "output/max_coverage"
    params:
        coverage_quantile = config['coverage_quantile']
    script:
        "../scripts/get_cov_threshold.py"
