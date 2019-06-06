rule qualimap:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        "output/{exp}/{sample}/qualimap/qualimapReport_{sample}.html"
    params:
        outdir = "output/{exp}/{sample}/qualimap",
        java_mem = config['gatk_java_heap_mem']
    log:
        "logs/{exp}/qualimap_{sample}.log"
    threads:
        config['threads']
    shell:
        "qualimap bamqc "
        "--java-mem-size={params.java_mem}G "
        "-bam {input} "
        "-nt {threads} "
        "-outdir {params.outdir} > {log} "
        "&& mv {params.outdir}/qualimapReport.html {output}"
