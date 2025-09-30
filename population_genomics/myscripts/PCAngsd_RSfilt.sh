#!/bin/bash 


#---------  Slurm preamble, defines the job with #SBATCH statements

# Give your job a name that's meaningful to you, but keep it short
#SBATCH --job-name=PCAngsd_RS

# Name the output file: Re-direct the log file to your home directory
# The first part of the name (%x) will be whatever you name your job 
#SBATCH --output=/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/mylogs/%x_%j.out

# Which partition to use: options include short (<3 hrs), general (<48 hrs), or week
#SBATCH --partition=general

# Specify when Slurm should send you e-mail.  You may choose from
# BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sstover@uvm.edu

# Run on a single node with four cpus/cores and 8 GB memory
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G

# Time limit is expressed as days-hrs:min:sec; this is for 24 hours.
#SBATCH --time=24:00:00

#---------  End Slurm preamble, job commands now follow

# Start with the usual bash script header

# load modules

module purge
module load pcangsd/1.36.1

# Give yourself some notes

# Path to your input data (where the beagle file lives)

INPUT="/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/ANGSD"

# Make directory and set path to save your output (in your repo):

mkdir ~/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/PCA_ADMIX

OUT="/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myresults/ANGSD/PCA_ADMIX"

SUFFIX="allRS_poly"

# Make a copy of the list of bam files for all the red + black spruce samples and place in your repo. You'll need this later for making figures.

cp ${INPUT}/allRS_bam.list ${OUT}


# Set value of K and number of PCA eigenvalues (=K-1)
# K corresponds to the number of distinct ancestry groups you want to cluster genotypes into

K=3
E=$((K-1))

# Then, run PCA and admixture scores with pcangsd:

pcangsd -b ${INPUT}/${SUFFIX}.beagle.gz \
        -o ${OUT}/${SUFFIX}_K${K} \
        -e $E \
        --admix \
        --admix-K $K \
        --maf 0.05 \
        --selection \
        --selection-eig $E \
        --sites-save \
        --maf-save \
        --snp-weights \
        --threads 10
        

