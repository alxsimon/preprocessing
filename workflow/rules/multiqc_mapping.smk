rule multiqc_mapping:
    input:
        expand("results/Mgallo/{ind}/{ind}.stats", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.stats", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.stats", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.stats", ind = samples_novaseq_2),
        expand("results/ellis/{ind}/{ind}.stats", ind = samples_ellis),
        expand("results/SRA/{ind}/{ind}.stats", ind=samples_SRA),
        expand("results/Mgallo/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_mgallo),
        expand("results/Hiseq/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_hiseq),
        expand("results/Novaseq/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq),
        expand("results/Novaseq_2/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_novaseq_2),
        expand("results/ellis/{ind}/{ind}.mosdepth.global.dist.txt", ind = samples_ellis),
        expand("results/SRA/{ind}/{ind}.mosdepth.global.dist.txt", ind=samples_SRA),
    output:
        "results/multiqc/multiqc_mapping.html"
    params:
        outdir = lambda w, output: os.path.dirname(output[0]),
        config = "config/multiqc_config.yaml",
    threads:
        config['threads']
    conda:
        "../envs/qc.yaml"
    shell:
        "multiqc -f " 
        "results/*/*/*.mosdepth.global.dist.txt "
        "results/*/*/*.stats "
        "output/*/*/duplicate_metrics_* " 
        "-c {params.config} "
        "-n multiqc_mapping.html "
        "-o {params.outdir} "
        "--interactive "
        "-m samtools -m picard -m mosdepth"
