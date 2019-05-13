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
#SBATCH --cpus-per-task 4
#SBATCH --mem 8G
#SBATCH --mail-type END
#SBATCH --mail-user alexis.simon@normalesup.org
#SBATCH -D /shared/projects/mytilus/Preprocessing

module load conda slurm-drmaa
source activate snakemake

snakemake --use-singularity \
--jobs 40 --cluster-config config_cluster.yaml \
-s Snakefile \
--cluster "sbatch -A {cluster.account} -p {cluster.partition} \
--error {cluster.error} --output {cluster.output} \
-t {cluster.time} --nodes {cluster.nodes} \
--ntasks {cluster.ntasks} --mem {cluster.mem}G \
-D /shared/projects/mytilus/Preprocessing \
--cpus-per-task {threads}"
