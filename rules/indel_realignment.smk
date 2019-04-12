rule fai_dict_ref:
    input:
        config['ref_fasta']
    output:
        config['ref_fasta'] + ".fai",
        config['ref_fasta'][:-3] + ".dict"
    shell:
        "samtools faidx {input} "
        "&& gatk CreateSequenceDictionary -R {input}"

# Because the index option of MarkDuplicatesSpark does not seem to work
rule index_before:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.bam"
    output:
        temp("output/{exp}/{sample}/{sample}.mapped.dedup.bam.bai")
    params:
        compression = 1,
    threads:
        config['threads']
    shell:
        "samtools index "
        "-@ {threads} "
        "{input}"

rule target_intervals:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.bam",
        bai = "output/{exp}/{sample}/{sample}.mapped.dedup.bam.bai",
        ref_fai = config['ref_fasta'] + ".fai",
        ref_dict = config['ref_fasta'][:-3] + ".dict"
    output:
        temp("output/{exp}/{sample}/{sample}_forIndelRealigner.intervals")
    params:
        ref = config['ref_fasta']
    log:
        "logs/{exp}/targetintervals_{sample}.log"
    shell:
        "java -jar /opt/tools/gatk3/GenomeAnalysisTK.jar "
	    "-T RealignerTargetCreator "
	    "-R {params.ref} "
	    "-I {input.bam} "
	    "-o {output} |& tee {log}"

rule indel_realignment:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.bam",
        bai = "output/{exp}/{sample}/{sample}.mapped.dedup.bam.bai",
        target = "output/{exp}/{sample}/{sample}_forIndelRealigner.intervals"
    output:
        bam = temp("output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"),
        bai = temp("output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bai")
    params:
        ref = config['ref_fasta']
    log:
        "logs/{exp}/indel_realignment_{sample}.log"
    shell:
        "java -jar /opt/tools/gatk3/GenomeAnalysisTK.jar "
	    "-T IndelRealigner "
	    "-R {params.ref} "
        "-targetIntervals {input.target} "
	    "-I {input.bam} "
	    "-o {output.bam} |& tee {log}"

rule sort_index_final:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"
    output:
        bam = protected("results/{exp}/{sample}/{sample}.preproc.bam"),
        bai = protected("results/{exp}/{sample}/{sample}.preproc.bai")
    params:
        compression = 6,
        m = config['samtools_sort_m']
    threads:
        config['threads']
    shell:
        # Sort
        "samtools sort "
        "-m {params.m} "
        "-O BAM "
        "-l {params.compression} "
        "-@ {threads} "
        "-o {output.bam} "
        "{input} "
        # index
        "&& samtools index "
        "-@ {threads} "
        "{output.bam}"
