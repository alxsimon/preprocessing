rule fastp:
    input:
        unpack(get_raw_fastq)
    output:
        clean_R1 = temp("output/{exp}/{sample}/{sample}_{RG}_R1.clean.fastq.gz"),
        clean_R2 = temp("output/{exp}/{sample}/{sample}_{RG}_R2.clean.fastq.gz"),
        report_html = "output/{exp}/{sample}/fastp_report_{sample}_{RG}.html",
        report_json = "output/{exp}/{sample}/fastp_report_{sample}_{RG}.json"
    params:
        complexity_threshold = config['fastp_complexity_threshold'],
        adapter_sequence_R1 = lambda wildcards: config['adapters'][wildcards.exp]['read1'],
        adapter_sequence_R2 = lambda wildcards: config['adapters'][wildcards.exp]['read1'],
        P = config['fastp_P']
    log:
        "logs/{exp}/fastp_stdout_{sample}_{RG}.log"
    threads:
        config['threads']
    shell:
        "fastp "
        "-i {input.fq1} "
        "-I {input.fq2} "
        "-o {output.clean_R1} "
        "-O {output.clean_R2} "
        "-w {threads} "
        "--correction "
        "--low_complexity_filter "
        "--complexity_threshold {params.complexity_threshold} "
        "--html {output.report_html} "
        "--json {output.report_json} "
        "--report_title {wildcards.sample} "
        "--adapter_sequence {params.adapter_sequence_R1} "
        "--adapter_sequence_r2 {params.adapter_sequence_R2} "
        "--overrepresentation_analysis "
        "-P {params.P} |& tee {log}"
