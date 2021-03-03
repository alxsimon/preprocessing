rule index_mito_bwa:
    input:
        config['mito_ref']
    output:
        multiext(config['mito_ref'],
            ".amb", ".ann", ".bwt.2bit.64", ".pac", ".0123")
    log:
        "logs/bwa_mito_ref_indexing.log"
    threads: 1
    conda:
        "../envs/mito_assembly.yaml"
    shell:
        """
        bwa-mem2 index \
        {input} > {log} 2>&1
        """

rule map_to_mito_ref:
    input:
        unpack(get_all_fastp),
        ref_index = multiext(config['mito_ref'],
            ".amb", ".ann", ".bwt.2bit.64", ".pac", ".0123")
    output:
        temp(expand("results/mito_assembly/mapped/{{exp}}/{{sample}}_mapped_mito_{R}.fastq.gz",
            R=['R1', 'R2']))
    params:
        ref = config['mito_ref'],
        mem_sort = '8G'
    log:
        "logs/mito_assembly/bwa_{exp}_{sample}.log",
        "logs/mito_assembly/samtools_fastq_{exp}_{sample}.log"
    threads:
        config['threads']
    conda:
        "../envs/mito_assembly.yaml"
    shell:
        """
        bwa-mem2 mem -t {threads} \
        {params.ref} \
        <(cat {input.R1}) <(cat {input.R2}) \
        2> {log[0]} | \
        samtools view -u -F 4 | \
        samtools sort -l 0 -n -m {params.mem_sort} | \
        samtools fastq -@ {threads} -1 {output[0]} -2 {output[1]} \
        -0 /dev/null -s /dev/null 2> {log[1]}
        """

rule megahit_mito:
    input:
        expand("results/mito_assembly/mapped/{{exp}}/{{sample}}_mapped_mito_{R}.fastq.gz",
            R=['R1', 'R2'])
    output:
        directory("results/mito_assembly/megahit/{exp}/{sample}")
    log:
        "logs/mito_assembly/megahit_{exp}_{sample}.log"
    threads:
        config['threads']
    conda:
        "../envs/mito_assembly.yaml"
    shell:
        """
        megahit -t {threads} \
        -1 {input[0]} -2 {input[1]} \
        -o {output} \
        > {log} 2>&1
        """

rule mitofinder:
    input:
        rules.megahit_mito.output
    output:
        directory("results/mito_assembly/mitofinder/{exp}/{sample}")
    params:
        input_contigs = lambda w, input: f'{input[0]}/final.contigs.fa',
        job_name = lambda w: f'{w.sample}',
        ref_gb = config['mito_ref_gb']
    log:
        "logs/mito_assembly/mitofinder_{exp}_{sample}.log"
    container:
        "containers/MitoFinder.sif"
    shell:
        """
        mitofinder -r {params.ref_gb} \
        -j {params.job_name} \
        -a {params.input_contigs} \
        -o 5 --rename-contig "yes" --override \
        > {log} 2>&1 && \
        mv {params.job_name} {output}
        rm {params.job_name}_MitoFinder.log
        """

#=========================================
# Split, merge de novo assembled mitochondria

rule merge_filter_mito_contigs:
    input:
        expand("results/mito_assembly/mitofinder/Hiseq/{sample}", sample=samples_hiseq),
        expand("results/mito_assembly/mitofinder/Novaseq/{sample}", sample=samples_novaseq),
        expand("results/mito_assembly/mitofinder/Novaseq_2/{sample}", sample=samples_novaseq_2),
        expand("results/mito_assembly/mitofinder/ellis/{sample}", sample=samples_ellis),
        contigs = get_all_mito_contigs,
    output:
        "results/mito_assembly/sequences/mito_merged.fa",
        "results/mito_assembly/sequences/mito_merged.gff",
        "results/mito_assembly/sequences/mito_merged_filt.fa",
    params:
        min_len = 14000, # Consider only complete mitochondria
        in_gff = lambda w, input: [x.replace('.fasta', '.gff') for x in input.contigs],
    conda:
        "../envs/mito_assembly.yaml"
    shell:
        """
        cat {input.contigs} > {output[0]}
        cat {params.in_gff} > {output[1]}
        seqkit seq --min-len {params.min_len} {output[0]} > {output[2]}
        """

rule extract_mito_genes:
    input:
        fa = "results/mito_assembly/sequences/mito_merged_filt.fa",
        gff = "results/mito_assembly/sequences/mito_merged.gff"
    output:
        "results/mito_assembly/sequences/mito_merged_gene_{gene}.fa"
    conda:
        "../envs/mito_assembly.yaml"
    shell:
        """
        bedtools getfasta -s -fi {input.fa} \
        -bed <(grep '{wildcards.gene} gene' {input.gff}) | \
        seqkit replace -p ':.*$' -r '' | \
        seqkit replace -p '(.*)' -r '$1|{wildcards.gene}' \
        > {output}
        """

