rule index_ref_genome_bwa:
    input:
        config['ref_fasta']
    output:
        expand(config['ref_fasta'] + ".{extensions}",
            extensions = ["amb", "ann", "bwt.2bit.64", "pac", "0123"])
    log:
        "logs/bwa_ref_indexing.log"
    threads: 1
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        bwa-mem2 index \
        {input} |& tee {log}
        """

rule bwa_map:
    input:
        clean_R1 = "output/{exp}/{sample}/{sample}_{RG}_R1.clean.fastq.gz",
        clean_R2 = "output/{exp}/{sample}/{sample}_{RG}_R2.clean.fastq.gz",
        ref_bwaindex = expand(config['ref_fasta'] + ".{extensions}",
            extensions = ["amb", "ann", "bwt.2bit.64", "pac", "0123"])
    output:
        temp("output/{exp}/{sample}/{sample}_{RG}.mapped.bam")
    params:
        k = config['bwa_k'],
        B = config['bwa_B'],
        O = config['bwa_O'],
        L = config['bwa_L'],
        ref = config['ref_fasta'],
        rg_string = lambda wildcards: get_rg_string(wildcards)
    threads:
        config['threads']
    log:
        "logs/{exp}/bwa_mem_stderr_{sample}_{RG}.log"
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        bwa-mem2 mem \
        -t {threads} \
        -k {params.k} \
        -B {params.B} \
        -O {params.O} \
        -L {params.L} \
        -R \"{params.rg_string}\" \
        -M \
        {params.ref} \
        {input.clean_R1} {input.clean_R2} \
        2> {log} \
        | samtools view -b -@ {threads} -o {output}
        """
