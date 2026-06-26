window_size = {
    "5kb": 5_000,
}


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
            -w {params.window_size} -s {params.step_size} >{output}
        """


rule bedtools_multicov:
    input:
        bams=expand("results/Hiseq/{ind}/{ind}.preproc.bam", ind=samples_hiseq)
        + expand("results/Novaseq/{ind}/{ind}.preproc.bam", ind=samples_novaseq)
        + expand("results/Novaseq_2/{ind}/{ind}.preproc.bam", ind=samples_novaseq_2)
        + expand("results/ellis/{ind}/{ind}.preproc.bam", ind=samples_ellis),
        windows="output/genome_windows_5kb.bed",
    output:
        "results/coverages_5kb_win.bed",
        "results/coverages_sample_list.txt",
    params:
        min_mapQ = 20,
        sample_list = samples_hiseq + samples_novaseq + samples_novaseq_2 + samples_ellis,
    conda:
        "../envs/preprocessing.yaml"
    shell:
        """
        echo {params.sample_list} | tr '[:space:]' '\n' > {output[1]}
        bedtools multicov \
            -bams {input.bams} \
            -bed {input.windows} \
            -q {params.min_mapQ} \
            > {output[0]}
        """
