window_size = {
    "5kb": 5_000,
}

chroms = [
    f"CM0753{i}.1" for i in range(30, 44)
]

rule make_windows_genome:
    input:
        f"{config['ref_fasta']}.fai",
    output:
        "output/genome_windows_{winsize}.bed",
    params:
        window_size=lambda w: window_size[w.winsize],
        step_size=lambda w: window_size[w.winsize],
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        bedtools makewindows -g <(cut -f 1-2 {input}) \
            -w {params.window_size} -s {params.step_size} > {output}
        """


rule bedtools_multicov:
    input:
        bams=expand("results/Hiseq/{ind}/{ind}.preproc.bam", ind=samples_hiseq)
        + expand("results/Novaseq/{ind}/{ind}.preproc.bam", ind=samples_novaseq)
        + expand("results/Novaseq_2/{ind}/{ind}.preproc.bam", ind=samples_novaseq_2)
        + expand("results/ellis/{ind}/{ind}.preproc.bam", ind=samples_ellis),
        windows="output/genome_windows_5kb.bed",
    output:
        "results/coverages_5kb_win_{chr}.bed",
    params:
        min_mapQ = 20,
        sample_list = samples_hiseq + samples_novaseq + samples_novaseq_2 + samples_ellis,
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        bedtools multicov \
            -bams {input.bams} \
            -bed <(grep -w "{wildcards.chr}" {input.windows}) \
            -q {params.min_mapQ} \
            > {output}
        """

rule all_cov:
    input:
        expand("results/coverages_5kb_win_{chr}.bed", chr=chroms),
    output:
        "results/coverages_sample_list.txt",
    params:
        sample_list = samples_hiseq + samples_novaseq + samples_novaseq_2 + samples_ellis,
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        echo {params.sample_list} | tr '[:space:]' '\n' > {output}
        """
