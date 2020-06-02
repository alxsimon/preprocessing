rule multiqc_mapping:
    input:
        expand("results/Mgallo/{ind}/{ind}.stats", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.stats", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.stats", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.stats", ind = samples_novaseq_2),
        expand("results/Mgallo/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq_2)
    output:
        "results/multiqc/multiqc_mapping.html"
    threads:
        config['threads']
    shell:
        "multiqc results/ output/*/*/duplicate_metrics_*" 
        "-f "
        "-c configs/multiqc_config.yaml "
        "-n multiqc_mapping.html "
        "-o results/multiqc "
        "--interactive "
        "-m samtools -m picard -m mosdepth"
