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
    threads:
        config['mosdepth_threads']
    shell:
        "mosdepth "
        "-b {params.window} "
        "-t {threads} "
        "--fast-mode "
        "-n "
        "{params.prefix} "
        "{input} |& {log}"
