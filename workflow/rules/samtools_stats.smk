rule samtools_stats:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        "results/{exp}/{sample}/{sample}.stats"
    params:
        ref = config['ref_fasta']
    log:
        "logs/{exp}/samtools_stats_{sample}.log"
    threads:
        config['threads']
    conda:
        "../envs/qc.yaml"
    shell:
        "samtools stats "
        "-@ {threads} "
        "{input} > {output} 2> {log}"
