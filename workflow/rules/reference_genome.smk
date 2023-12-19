rule download_edu_ref:
	output:
		"results/GCA_019925275.1/GCA_019925275.1_PEIMed_genomic.fna",
	params:
		acc = "GCA_019925275.1",
	conda:
		"../envs/preprocessing.yaml",
	shell:
		"""
		cd results
		datasets download genome accession {params.acc} \
		--include gff3,rna,cds,protein,genome,seq-report
		unzip ncbi_dataset.zip
		mv ncbi_dataset/data/{params.acc} ./
		rm -r ncbi_dataset.zip ncbi_dataset README.md
		"""
