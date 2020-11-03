def get_pufield(fq1_path):
    pufield = subprocess.check_output("gzip -cd " + fq1_path +
    " | head -1 | cut -d ':' -f 3,4,10 | sed 's/:/./g'",
    shell = True, universal_newlines = True).strip()
    return(pufield)

def get_rg_string(wildcards):
    if wildcards.exp == "Mgallo":
        pufield = get_pufield("resources/raw_data/Mgallo/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S0_L001_R1_001.fastq.gz")

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
    if wildcards.exp == "Mgallo":
        inputs["fq1"] = ("resources/raw_data/Mgallo/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S0_L001_R1_001.fastq.gz")
        inputs["fq2"] = ("resources/raw_data/Mgallo/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S0_L001_R2_001.fastq.gz")

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
