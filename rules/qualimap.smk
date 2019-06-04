rule qualimap:
    input:
        "results/{exp}/{sample}/{sample}.preproc.bam"
    output:
        "output/{exp}/{sample}/qualimap/qualimapReport.html"
    params:
        outdir = "output/{exp}/{sample}/qualimap"
    threads:
        config['threads']
    shell:
        "qualimap "
        "-bam {input} "
        "-nt {threads} "
        "-outdir {params.outdir}"
