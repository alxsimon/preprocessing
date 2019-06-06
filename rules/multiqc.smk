rule multiqc:
    input:
        expand("output/Mgallo/{ind}/qualimap/qualimapReport_Mgallo_{ind}.html", ind = samples_mgallo),
        expand("output/Hiseq/{ind}/qualimap/qualimapReport_Hiseq_{ind}.html", ind = samples_hiseq),
        expand("output/Novaseq/{ind}/qualimap/qualimapReport_Novaseq_{ind}.html", ind = samples_novaseq)
    output:
        "output/multiqc_report_preprocessing.html"
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-n output/multiqc_report_preprocessing.html "
        "-o output/multiqc_data"
