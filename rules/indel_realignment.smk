rule sort_index_before:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.bam"
    output:
        temp("output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam")
    params:
        compression = 1,
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
        "-o {output} "
        "{input} "
        # index
        "&& samtools index "
        "-@ {threads} "
        "{output}"

rule target_intervals:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam"
    output:
        temp("output/{exp}/{sample}/{sample}_forIndelRealigner.intervals")
    params:
        ref = config['ref_fasta']
    log:
        "output/{exp}/{sample}/targetintervals_{sample}.log"
    shell:
        "java -jar /opt/biotools/gatk3/GenomeAnalysisTK.jar "
	    "-T RealignerTargetCreator "
	    "-R {params.ref} "
	    "-I {input} "
	    "-o {output} |& tee {log}"

rule indel_realignment:
    input:
        bam = "output/{exp}/{sample}/{sample}.mapped.dedup.sorted.bam",
        target = "output/{exp}/{sample}/{sample}_forIndelRealigner.intervals"
    output:
        temp("output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam")
    params:
        ref = config['ref_fasta']
    log:
        "output/{exp}/{sample}/indel_realignment_{sample}.log"
    shell:
        "java -jar /opt/biotools/gatk3/GenomeAnalysisTK.jar "
	    "-T IndelRealigner "
	    "-R {params.ref} "
        "-targetIntervals {input.target} "
	    "-I {input.bam} "
	    "-o {output} |& tee {log}"

rule sort_index_final:
    input:
        "output/{exp}/{sample}/{sample}.mapped.dedup.realigned.bam"
    output:
        protected("output/{exp}/{sample}/{sample}.preproc.bam")
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
        "-o {output} "
        "{input} "
        # index
        "&& samtools index "
        "-@ {threads} "
        "{output}"
