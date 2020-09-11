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
--error {cluster.error} --output {cluster.output} \
-t {cluster.time} --nodes {cluster.nodes} \
--ntasks {cluster.ntasks} --mem {cluster.mem}G \
-D /shared/projects/mytilus/preprocessing \
--cpus-per-task {threads}"
