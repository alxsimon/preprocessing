rule fai_ref:
    input:
        config['ref_fasta']
    output:
        config['ref_fasta'] + ".fai",
    threads: 1
    shell:
        "samtools faidx {input}"

rule dict_ref:
    input:
        config['ref_fasta']
    output:
        config['ref_fasta'][:config['ref_fasta'].rfind('.')] + ".dict"
    threads: 1
    shell:
        """
        set +eu && source /opt/conda_init.sh && conda activate gatk4
        gatk CreateSequenceDictionary -R {input}
        conda deactivate
        """

rule target_intervals:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam",
        bai = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bai",
        ref_fai = config['ref_fasta'] + ".fai",
        ref_dict = config['ref_fasta'][:-3] + ".dict"
    output:
        temp("output/{exp}/{sample}/{sample}_forIndelRealigner.intervals")
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/targetintervals_{sample}.log"
    threads: 1
    group: "group_indel"
    shell:
        """
        set +eu && source /opt/conda_init.sh && conda activate gatk3
        gatk3 -Xmx{params.java_mem}g \
	    -T RealignerTargetCreator \
	    -R {params.ref} \
	    -I {input.bam} \
	    -o {output} |& tee {log}
        conda deactivate
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
    group: "group_indel"
    shell:
        """
        set +eu && source /opt/conda_init.sh && conda activate gatk3
        gatk3 -Xmx{params.java_mem}g \
	    -T IndelRealigner \
	    -R {params.ref} \
        -targetIntervals {input.target} \
	    -I {input.bam} \
	    -o {output.bam} |& tee {log}
        conda deactivate
        """
