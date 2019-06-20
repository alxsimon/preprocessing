rule bamtocram:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        expand("results/Mgallo/{ind}/{ind}.preproc.cram", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.preproc.cram", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.preproc.cram", ind = samples_novaseq)
    log:
        "logs/{exp}/bamtocram_{sample}.log"
    params:
        ref = config['ref_fasta']
    threads:
        config['threads']
    shell:
        "samtools view "
        "-@ {threads} "
        "-T {params.ref} "
        "-C "
        "-o {output} "
        "{input} |& tee {log}"
