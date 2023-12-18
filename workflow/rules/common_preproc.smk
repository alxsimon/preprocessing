def get_pufield(fq1_path):
    pufield = subprocess.check_output("gzip -cd " + fq1_path +
    " | head -1 | cut -d ':' -f 3,4,10 | sed 's/:/./g'",
    shell = True, universal_newlines = True).strip()
    return(pufield)

def get_rg_string(wildcards):
    if wildcards.exp == "SRA":
        pufield = get_pufield("resources/raw_data/SRA/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_R1.fastq.gz")

    if wildcards.exp == "Hiseq":
        if wildcards.RG == "RG1":
            pufield = get_pufield("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg1'] + "_R1.fastq.gz")
        else:
            pufield = get_pufield("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg2'] + "_R1.fastq.gz")


    if wildcards.exp == "Novaseq":
        if wildcards.RG == "RG1":
            pufield = get_pufield("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg1'] + "_*_R1.fastq.gz")
        else:
            pufield = get_pufield("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg2'] + "_*_R1.fastq.gz")

    if wildcards.exp == "Novaseq_2":
        pufield = get_pufield("resources/raw_data/Novaseq_2/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S*_R1_001.fastq.gz")

    if wildcards.exp == "ellis":
        pufield = get_pufield("resources/raw_data/ellis/" +
            wildcards.sample +
            "/*" + wildcards.sample +
            "_r1.fq.gz")

    rg_string = "@RG\\tID:" + pufield + "\\tLB:LIB-" + wildcards.sample + \
    "\\tPU:" + pufield + "\\tPL:ILLUMINA\\tSM:" + wildcards.sample

    return rg_string


def get_raw_fastq(wildcards):
    # Function returning the raw fastq files depending on
    # the experiment and the individual wildcards considered.
    inputs = dict()
    if wildcards.exp == "SRA":
        inputs["fq1"] = ("resources/raw_data/SRA/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_R1.fastq.gz")
        inputs["fq2"] = ("resources/raw_data/SRA/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_R2.fastq.gz")

    if wildcards.exp == "Hiseq":
        if wildcards.RG == "RG1":
            inputs["fq1"] = glob.glob("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg1'] + "_R1.fastq.gz")
            inputs["fq2"] = glob.glob("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg1'] + "_R2.fastq.gz")
        else:
            inputs["fq1"] = glob.glob("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg2'] + "_R1.fastq.gz")
            inputs["fq2"] = glob.glob("resources/raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg2'] + "_R2.fastq.gz")

    if wildcards.exp == "Novaseq":
        if wildcards.RG == "RG1":
            inputs["fq1"] = glob.glob("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg1'] + "_*_R1.fastq.gz")
            inputs["fq2"] = glob.glob("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg1'] + "_*_R2.fastq.gz")
        else:
            inputs["fq1"] = glob.glob("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg2'] + "_*_R1.fastq.gz")
            inputs["fq2"] = glob.glob("resources/raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg2'] + "_*_R2.fastq.gz")
    
    if wildcards.exp == "Novaseq_2":
        inputs["fq1"] = glob.glob("resources/raw_data/Novaseq_2/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S*_R1_001.fastq.gz")
        inputs["fq2"] = glob.glob("resources/raw_data/Novaseq_2/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S*_R2_001.fastq.gz")

    if wildcards.exp == "ellis":
        inputs["fq1"] = glob.glob("resources/raw_data/ellis/" +
            wildcards.sample +
            "/*" + wildcards.sample +
            "_r1.fq.gz")
        inputs["fq2"] = glob.glob("resources/raw_data/ellis/" +
            wildcards.sample +
            "/*" + wildcards.sample +
            "_r2.fq.gz")

    return inputs


def get_all_fastp(w):
    read_groups = {
        'Hiseq': ['RG1', 'RG2'],
        'Novaseq': ['RG1', 'RG2'],
        'Novaseq_2': ['RG1'],
        'ellis': ['RG1'],
        'SRA': ['RG1']
    }
    R1 = [f"output/{w.exp}/{w.sample}/{w.sample}_{rg}_R1.clean.fastq.gz"
        for rg in ['RG1', 'RG2']
        if rg in read_groups[w.exp]]
    R2 = [f"output/{w.exp}/{w.sample}/{w.sample}_{rg}_R2.clean.fastq.gz"
        for rg in ['RG1', 'RG2']
        if rg in read_groups[w.exp]]
    return {'R1': R1, 'R2': R2}


def get_all_mito_contigs(w):
    path1 = 'results/mito_assembly/mitofinder/*/*/*_Final_Results/*_mtDNA_contig_[0-9].fasta'
    path2 = 'results/mito_assembly/mitofinder/*/*/*_Final_Results/*_mtDNA_contig.fasta'
    return glob.glob(path1) + glob.glob(path2)