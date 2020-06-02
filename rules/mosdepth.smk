rule mosdepth:
    input:
        "results/{exp}/{sample}/{sample}.preproc.cram"
    output:
        "results/{exp}/{sample}/{sample}.mosdepth.global.dist.txt"
    log:
        "logs/{exp}/mosdepth_{sample}.log"
    params:
        window = config['mosdepth_window'],
        prefix = "results/{exp}/{sample}/{sample}",
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

