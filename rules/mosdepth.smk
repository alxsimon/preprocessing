rule mosdepth:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        "output/{exp}/{sample}/mosdepth/{sample}.mosdepth.global.dist.txt"
    log:
        "logs/{exp}/mosdepth_{sample}.log"
    params:
        window = config['mosdepth_window'],
        prefix = "output/{exp}/{sample}/mosdepth/{sample}"
    threads:
        config['threads']
    shell:
        "mosdepth "
        "-b {params.window} "
        "-t {threads} "
        "-n "
        "{params.prefix} "
        "{input} |& {log}"
