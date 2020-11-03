rule sort_index_final:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"
    output:
        cram = protected("results/{exp}/{sample}/{sample}.preproc.cram"),
        index = protected("results/{exp}/{sample}/{sample}.preproc.cram.crai")
    params:
        compression = 6,
        m = config['samtools_sort_m'],
        ref = config['ref_fasta']
    threads:
        config['threads']
    shell:
        """
        samtools view -@ {threads} -T {params.ref} -C {input} \
        | samtools sort -@ {threads} -l {params.compression} -m {params.m}G \
        -O cram -o {output.cram} --reference {params.ref} -
        
        samtools index -@ {threads} {output.cram}
        """
    