rule multiqc_fastp:
    input:
        "output/multiqc/multiqc_mapping.html"
    output:
        "output/multiqc/multiqc_fastp.html"
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-n multiqc_fastp.html "
        "-o output/multiqc "
        "-m fastp"
