rule index_ref_genome_bwa:
    input:
        config['ref_fasta']
    output:
        expand(config['ref_fasta'] + ".{extensions}",
            extensions = ["amb", "ann", "bwt", "pac", "sa"])
    log:
        "logs/bwa_ref_indexing.log"
    threads: 1
    shell:
        "bwa index "
        "{input} |& tee {log}"

rule bwa_map:
    input:
        clean_R1 = "output/{exp}/{sample}/{sample}_{RG}_R1.clean.fastq.gz",
        clean_R2 = "output/{exp}/{sample}/{sample}_{RG}_R2.clean.fastq.gz",
        ref_bwaindex = expand(config['ref_fasta'] + ".{extensions}",
            extensions = ["amb", "ann", "bwt", "pac", "sa"])
    output:
        "output/{exp}/{sample}/{sample}_{RG}.mapped.bam"
    params:
        k = config['bwa_k'],
        L = config['bwa_L'],
        B = config['bwa_B'],
        O = config['bwa_O'],
        m = config['samtools_sort_m'],
        ref = config['ref_fasta'],
        rg_string = lambda wildcards, input: get_rg_string(input.clean_R1, wildcards.sample)
    threads:
        config['threads']
    log:
        "logs/{exp}/bwa_mem_stderr_{sample}_{RG}.log"
    shell:
        "bwa mem "
        "-t {threads} "
        "-k {params.k} "
        "-L {params.L} "
        "-B {params.B} "
        "-O {params.O} "
        "-R \"{params.rg_string}\" "
        "-M "
        "{params.ref} "
        "{input.clean_R1} {input.clean_R2} "
        "2> {log} "
        "| samtools view "
        "-b "
        "-@ {threads} "
        "-o {output}"
