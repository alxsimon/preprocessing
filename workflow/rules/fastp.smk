rule fastp:
    input:
        unpack(get_raw_fastq)
    output:
        clean_R1 = "output/{exp}/{sample}/{sample}_{RG}_R1.clean.fastq.gz",
        clean_R2 = "output/{exp}/{sample}/{sample}_{RG}_R2.clean.fastq.gz",
        report_html = "output/{exp}/{sample}/{sample}_{RG}.fastp.html",
        report_json = "output/{exp}/{sample}/{sample}_{RG}.fastp.json"
    params:
        complexity_threshold = config['fastp_complexity_threshold'],
        adapter_fasta = config['adapter_fasta'],
        P = config['fastp_P']
    log:
        "logs/{exp}/fastp_stdout_{sample}_{RG}.log"
    threads:
        10 # uses up to 16 threads max
    conda:
        "../envs/preprocessing.yaml"
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
        "--adapter_fasta {params.adapter_fasta} "
        "--overrepresentation_analysis "
        "-P {params.P} > {log} 2>&1"
