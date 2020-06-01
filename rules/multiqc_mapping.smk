rule multiqc_mapping:
    input:
        # expand("output/Mgallo/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_mgallo),
        # expand("output/Hiseq/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_hiseq),
        # expand("output/Novaseq/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_novaseq),
        # expand("output/Novaseq_2/{ind}/qualimap/qualimapReport_{ind}.html", ind = samples_novaseq_2),
        expand("results/Mgallo/{ind}/{ind}.stats", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.stats", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.stats", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.stats", ind = samples_novaseq_2),
        expand("output/Mgallo/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_mgallo),
        expand("output/Hiseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_hiseq),
        expand("output/Novaseq/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq),
        expand("output/Novaseq_2/{ind}/mosdepth/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq_2)
    output:
        "output/multiqc/multiqc_mapping.html"
    threads:
        config['threads']
    shell:
        "multiqc . -f "
        "-c configs/multiqc_config.yaml "
        "-n multiqc_mapping.html "
        "-o results/multiqc "
        "--interactive "
        "-m samtools -m picard -m mosdepth"
