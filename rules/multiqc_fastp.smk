rule multiqc_fastp:
    input:
        "results/multiqc/multiqc_mapping.html"
    output:
        "results/multiqc/multiqc_fastp.html"
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-n multiqc_fastp.html "
        "-o output/multiqc "
        "--interactive "
        "-m fastp"
