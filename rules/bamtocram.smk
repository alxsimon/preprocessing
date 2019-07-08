rule bamtocram:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        protected("results/{exp}/{sample}/{sample}.preproc.cram")
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

rule indexcram:
    input:
        "results/{exp}/{sample}/{sample}.preproc.cram"
    output:
        protected("results/{exp}/{sample}/{sample}.preproc.cram.crai")
    threads:
        config['threads']
    shell:
        "samtools index -@ {threads} {input}"
