# Mark duplicates and indel realignements

rule markduplicates_1rg:
    input:
        "output/{exp}/{sample}/{sample}_RG1.mapped.bam"
    output:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.bam",
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}"
    wildcard_constraints:
        exp = "Mgallo"
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/markduplicates_stdout_{sample}.log"
    threads:
        config['threads']
    shell:
        """
        source /conda_init.sh && conda activate gatk4
        gatk --java-options "-Xmx{params.java_mem}g" MarkDuplicatesSpark \
        -I {input} \
        -O {output.bam} \
        -R {params.ref} \
        --remove-all-duplicates true \
        -M {output.metrics} \
        --conf \"spark.executor.cores={threads}\" \
        |& tee {log}
        conda deactivate
        """


rule markduplicates_2rg:
    input:
        expand("output/{{exp}}/{{sample}}/{{sample}}_{RG}.mapped.bam", RG = ["RG1", "RG2"])
    output:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.bam",
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}"
    wildcard_constraints:
        exp = "Hiseq|Novaseq"
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/markduplicates_stdout_{sample}.log"
    threads:
        config['threads']
    shell:
        """
        source /conda_init.sh && conda activate gatk4
        gatk --java-options "-Xmx{params.java_mem}g" MarkDuplicatesSpark \
        -I {input[0]} \
        -I {input[1]} \
        -O {output.bam} \
        -R {params.ref} \
        --remove-all-duplicates true \
        -M {output.metrics} \
        --conf \"spark.executor.cores={threads}\" \
        |& tee {log}
        conda deactivate
        """
