import pandas as pd
import subprocess
import glob

configfile: "config_preproc.yaml"

singularity: config['container']

samples_tb = pd.read_csv(config['samples'], sep = '\t').set_index("sample", drop=False)

samples_hiseq = samples_tb[samples_tb['experiment'] == 'Hiseq']['sample'].tolist()
samples_novaseq = samples_tb[samples_tb['experiment'] == 'Novaseq']['sample'].tolist()
samples_mgallo = samples_tb[samples_tb['experiment'] == 'Mgallo']['sample'].tolist()

def get_rg_string(fq1_path, ind):
    pufield = subprocess.check_output("gzip -cd " + fq1_path +
        " | head -1 | cut -d ':' -f 3,4,10 | sed 's/:/./g'",
        shell = True, universal_newlines = True).strip()
    rg_string = "@RG\\tID:" + pufield + "\\tLB:LIB-" + ind + \
        "\\tPU:" + pufield + "\\tPL:ILLUMINA\\tSM:" + ind
    return(rg_string)

def get_raw_fastq(wildcards):
    # Function returning the raw fastq files depending on
    # the experiment and the individual wildcards considered.
    inputs = dict()
    if wildcards.exp == "Mgallo":
        inputs["fq1"] = ("raw_data/Mgallo/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S0_L001_R1_001.fastq.gz")
        inputs["fq2"] = ("raw_data/Mgallo/" +
            wildcards.sample +
            "/" + wildcards.sample +
            "_S0_L001_R2_001.fastq.gz")

    if wildcards.exp == "Hiseq":
        if wildcards.RG == "RG1":
            inputs["fq1"] = glob.glob("raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg1'] + "_R1.fastq.gz")
            inputs["fq2"] = glob.glob("raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg1'] + "_R2.fastq.gz")
        else:
            inputs["fq1"] = glob.glob("raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg2'] + "_R1.fastq.gz")
            inputs["fq2"] = glob.glob("raw_data/Hiseq/" +
                wildcards.sample +
                "/*" + wildcards.sample + "*" +
                config['hiseq_rg2'] + "_R2.fastq.gz")

    if wildcards.exp == "Novaseq":
        if wildcards.RG == "RG1":
            inputs["fq1"] = glob.glob("raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg1'] + "_*_R1.fastq.gz")
            inputs["fq2"] = glob.glob("raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg1'] + "_*_R2.fastq.gz")
        else:
            inputs["fq1"] = glob.glob("raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg2'] + "_*_R1.fastq.gz")
            inputs["fq2"] = glob.glob("raw_data/Novaseq/" +
                wildcards.sample +
                "/" + wildcards.sample + "_*-" +
                config['novaseq_rg2'] + "_*_R2.fastq.gz")

    return inputs
