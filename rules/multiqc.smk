rule multiqc:
    input:
        expand("output/Mgallo/{ind}/qualimap/qualimapReport.html", ind = samples_mgallo),
        expand("output/Hiseq/{ind}/qualimap/qualimapReport.html", ind = samples_hiseq),
        expand("output/Novaseq/{ind}/qualimap/qualimapReport.html", ind = samples_novaseq),
        expand("output/{exp}/{sample}/smudgeplot/...")
    output:
        "output/multiqc.html"
    params:

    threads:
        config['threads']
    shell:
        "multiqc "
        "... "
