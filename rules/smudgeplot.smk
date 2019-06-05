rule smudgeplot:
    input:

    output:

    params:

    threads:
        config['threads']
    shell:
        "kmc ..."
        "smudgeplot ..."
