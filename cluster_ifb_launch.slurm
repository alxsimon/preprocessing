#!/usr/bin/env bash
# run snakemake on a slurm cluster

#SBATCH -J master-smk
#SBATCH -A mytilus
#SBATCH -p long
#SBATCH -t 10-00:00
#SBATCH --output master_snakemake.out
#SBATCH --error master_snakemake.err
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4G
#SBATCH --mail-type END
#SBATCH --mail-user alexis.simon@normalesup.org
#SBATCH -D /shared/projects/mytilus/Preprocessing

module load slurm-drmaa
module load snakemake
#module load conda
#conda activate snakemake-5.3.0

snakemake --use-singularity --cluster-config config_cluster.json \
--drmaa " -A {cluster.account} -p {cluster.partition} -n {cluster.n} \
-t {cluster.time} --error {cluster.error} --nodes {cluster.nodes} \
--ntasks {cluster.ntasks} --mem {cluster.mem} \
-D /shared/projects/mytilus/Preprocessing \
--cpus-per-task {threads}"
