rule sort_index_final:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"
    output:
        cram = protected("results/{exp}/{sample}/{sample}.preproc.cram"),
        index = protected("results/{exp}/{sample}/{sample}.preproc.cram.crai")
    params:
        compression = 6,
        ref = config['ref_fasta']
    threads:
        4
    shell:
        """
        samtools view -@ {threads} -T {params.ref} -C {input} \
        | samtools sort -@ {threads} -l {params.compression} \
        -O cram -o {output.cram} --reference {params.ref} -
        
        samtools index -@ {threads} {output.cram}
        """
    