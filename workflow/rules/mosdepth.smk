rule mosdepth:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam",
    output:
        "results/{exp}/{sample}/{sample}.mosdepth.global.dist.txt",
    log:
        "logs/{exp}/mosdepth_{sample}.log",
    params:
        prefix = "results/{exp}/{sample}/{sample}"
    threads:
        config['mosdepth_threads']
    conda:
        "../envs/qc.yaml"
    shell:
        "MOSDEPTH_PRECISION=5 "
        "mosdepth "
        "-t {threads} "
        "{params.prefix} "
        "{input} "
        "> {log} 2>&1"

