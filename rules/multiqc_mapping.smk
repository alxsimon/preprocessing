rule multiqc_mapping:
    input:
        expand("output/Mgallo/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_mgallo),
        expand("output/Hiseq/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_hiseq),
        expand("output/Novaseq/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_novaseq)
    output:
        "output/multiqc/multiqc_mapping.html"
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-n multiqc_mapping.html "
        "-o output/multiqc "
        "--interactive "
        "-m qualimap -m picard"
