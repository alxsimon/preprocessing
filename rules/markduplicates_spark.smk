# Mark duplicates and indel realignements

rule markduplicates_1rg:
    input:
        "output/{exp}/{sample}/{sample}_RG1.mapped.bam"
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.bam"),
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}.log"
    wildcard_constraints:
        exp = "Mgallo"
    params:
        ref = config['ref_fasta']
    log:
        "logs/{exp}/markduplicates_stdout_{sample}.log"
    threads:
        config['threads']
    shell:
        """
        set +e
        gatk MarkDuplicatesSpark \
        -I {input[0]} \
        -O {output.bam} \
        -R {params.ref} \
        --remove-all-duplicates true \
        -M {output.metrics} \
        --conf \"spark.executor.cores={threads}\" \
        |& tee {log}

        exitcode=$?
        if [ $exitcode -eq 1 ]
        then
            exit 1
        else
            exit 0
        fi

        rm -r output/{wildcards.exp}/{wildcards.sample}/{wildcards.sample}.mapped.dedup.bam.*
        """


rule markduplicates_2rg:
    input:
        expand("output/{{exp}}/{{sample}}/{{sample}}_{RG}.mapped.bam", RG = ["RG1", "RG2"])
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.bam"),
        metrics = "output/{exp}/{sample}/duplicate_metrics_{sample}.log"
    wildcard_constraints:
        exp = "Hiseq|Novaseq"
    params:
        ref = config['ref_fasta']
    log:
        "output/{exp}/{sample}/markduplicates_stdout_{sample}.log"
    threads:
        config['threads']
    shell:
        """
        set +e
        gatk MarkDuplicatesSpark \
        -I {input[0]} \
        -I {input[1]} \
        -O {output.bam} \
        -R {params.ref} \
        --remove-all-duplicates true \
        -M {output.metrics} \
        --conf \"spark.executor.cores={threads}\" \
        |& tee {log}

        exitcode=$?
        if [ $exitcode -eq 1 ]
        then
            exit 1
        else
            exit 0
        fi

        rm -r output/{wildcards.exp}/{wildcards.sample}/{wildcards.sample}.mapped.dedup.bam.*
        """
