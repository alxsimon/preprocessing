rule fai_ref:
    input:
        config['ref_fasta']
    output:
        config['ref_fasta'] + ".fai",
    threads: 1
    conda:
        "../envs/preprocessing.yaml"
    shell:
        "samtools faidx {input}"

ref_dict = os.path.splitext(config['ref_fasta'])[0] + ".dict"

rule dict_ref:
    input:
        config['ref_fasta']
    output:
        ref_dict
    threads: 1
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        gatk CreateSequenceDictionary -R {input}
        """

rule target_intervals:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam",
        bai = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bai",
        ref_fai = config['ref_fasta'] + ".fai",
        ref_dict = ref_dict,
    output:
        temp("output/{exp}/{sample}/{sample}_forIndelRealigner.intervals")
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/targetintervals_{sample}.log"
    threads: 1
    conda:
        "../envs/preprocessing.yaml"
    group: "group_indel"
    shell:
        """
        gatk3 -Xmx{params.java_mem}g \
        -T RealignerTargetCreator \
        -R {params.ref} \
        -I {input.bam} \
        -o {output} > {log} 2>&1
        """

rule indel_realignment:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam",
        bai = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bai",
        target = "output/{exp}/{sample}/{sample}_forIndelRealigner.intervals"
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"),
        bai = temp("output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bai")
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/indel_realignment_{sample}.log"
    threads: 1
    conda:
        "../envs/preprocessing.yaml"
    group: "group_indel"
    shell:
        """
        gatk3 -Xmx{params.java_mem}g \
        -T IndelRealigner \
        -R {params.ref} \
        -targetIntervals {input.target} \
        -I {input.bam} \
        -o {output.bam} > {log} 2>&1
        """
