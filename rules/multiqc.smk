rule multiqc:
    input:
        "output/{exp}/{sample}/qualimap/qualimapReport.html"
        "output/{exp}/{sample}/smudgeplot/..."
    output:
        "output/multiqc.html"
    params:

    threads:
        config['threads']
    shell:
        "multiqc "
        "... "
