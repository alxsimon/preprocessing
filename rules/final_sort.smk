rule sort_index_final:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"
    output:
        bam = protected("results/{exp}/{sample}/{sample}.preproc.bam"),
        index = protected("results/{exp}/{sample}/{sample}.preproc.bam.bai")
    threads:
        4
    shell:
        """
        samtools sort -@ {threads} {input} > {output.bam}
        samtools index -@ {threads} {output.bam}
        """
    