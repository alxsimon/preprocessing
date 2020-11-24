#!/usr/bin/env bash
# run snakemake on a slurm cluster

#SBATCH -J master-smk
#SBATCH -A mytilus
#SBATCH -p long
#SBATCH -t 30-00:00
#SBATCH --output master_preproc.out
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
--jobs 100 --cluster-config configs/config_cluster.yaml \
--cluster "sbatch -A {cluster.account} -p {cluster.partition} \
-t {cluster.time} --nodes {cluster.nodes} \
--ntasks {cluster.ntasks} --mem {cluster.mem}G \
-D /shared/projects/mytilus/preprocessing \
--cpus-per-task {threads}" \
preprocessing
