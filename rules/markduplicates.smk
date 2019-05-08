# Mark duplicates and indel realignements

rule markduplicates_1rg:
    input:
        "output/{exp}/{sample}/{sample}_RG1.mapped.bam"
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.bam"),
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}"
    wildcard_constraints:
        exp = "Mgallo"
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/markduplicates_stdout_{sample}.log"
    group: "marksort"
    threads: 1
    shell:
        """
        gatk --java-options "-Xmx{params.java_mem}g" MarkDuplicates \
        -I {input} \
        -O {output.bam} \
        -R {params.ref} \
        -M {output.metrics} \
        --ASSUME_SORT_ORDER "queryname" \
        --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
        --VALIDATION_STRINGENCY SILENT \
        --REMOVE_DUPLICATES true \
        --TMP_DIR /tmp/ \
        |& tee {log}
        """


rule markduplicates_2rg:
    input:
        expand("output/{{exp}}/{{sample}}/{{sample}}_{RG}.mapped.bam", RG = ["RG1", "RG2"])
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.bam"),
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}"
    wildcard_constraints:
        exp = "Hiseq|Novaseq"
    params:
        ref = config['ref_fasta'],
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/markduplicates_stdout_{sample}.log"
    group: "marksort"
    threads: 1
    shell:
        """
        gatk --java-options "-Xmx{params.java_mem}g" MarkDuplicates \
        -I {input[0]} \
        -I {input[1]} \
        -O {output.bam} \
        -R {params.ref} \
        -M {output.metrics} \
        --ASSUME_SORT_ORDER "queryname" \
        --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
        --VALIDATION_STRINGENCY SILENT \
        --REMOVE_DUPLICATES true \
        --TMP_DIR /tmp/ \
        |& tee {log}
        """

rule sort_sam:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.bam"
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam"),
        index = temp("output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bai")
    params:
        java_mem = config['gatk_java_heap_mem']
    group: "marksort"
    threads: 1
    shell:
        "gatk --java-options '-Xmx{params.java_mem}g' SortSam "
        "-I {input} "
        "-O {output.bam} "
        "-SO 'coordinate' "
        "--CREATE_INDEX true"
