rule samtools_stats:
    input:
        "results/{exp}/{sample}/{sample}.preproc.cram"
    output:
        "results/{exp}/{sample}/{sample}.stats"
    params:
        ref = config['ref_fasta']
    log:
        "logs/{exp}/samtools_stats_{sample}.log"
    threads:
        config['threads']
    shell:
        "samtools stats "
        "-@ {threads} "
	    "--reference {params.ref} "
        "{input} > {output} 2> {log}"
