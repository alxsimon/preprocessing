#!/usr/bin/env bash
# run snakemake on a slurm cluster

#SBATCH -J master-smk
#SBATCH -A mytilus
#SBATCH -p long
#SBATCH -t 10-00:00
#SBATCH --output master_snakemake.out
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --mem 8G
#SBATCH --mail-type END
#SBATCH --mail-user alexis.simon@normalesup.org
#SBATCH -D /shared/projects/mytilus/preprocessing

module load conda
source activate snakemake

[[ ! -e logs/cluster ]] && mkdir logs/cluster 

snakemake --use-singularity \
--jobs 60 --cluster-config configs/config_cluster.yaml \
-s preprocessing.snakefile \
--cluster "sbatch -A {cluster.account} -p {cluster.partition} \
-t {cluster.time} --nodes {cluster.nodes} \
--ntasks {cluster.ntasks} --mem {cluster.mem}G \
-D /shared/projects/mytilus/preprocessing \
--cpus-per-task {threads}" \
--groups fastp=group0 bwa_map=group0 markduplicates_1rg=group0 markduplicates_2rg=group0 \
sort_sam=group0 target_intervals=group0 indel_realignment=group0 sort_index_final=group0 \
bamtocram=group0 indexcram=group0
