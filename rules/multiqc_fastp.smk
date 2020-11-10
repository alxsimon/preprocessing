rule multiqc_fastp:
    input:
        "results/multiqc/multiqc_mapping.html"
    output:
        "results/multiqc/multiqc_fastp.html"
    params:
        outdir = lambda w, output: os.path.dirname(output[0])
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-n multiqc_fastp.html "
        "-o {params.outdir} "
        "--interactive "
        "-m fastp"
