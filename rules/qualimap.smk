rule qualimap:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        "output/{exp}/{sample}/qualimap/qualimapReport_{sample}.html"
    params:
        outdir = "output/{exp}/{sample}/qualimap"
    log:
        "logs/{exp}/qualimap_{sample}.log"
    threads:
        config['threads']
    shell:
        "qualimap bamqc "
        "-bam {input} "
        "-nt {threads} "
        "-outdir {params.outdir} > {log} "
        "&& mv {params.outdir}/qualimapReport.html {output}"
