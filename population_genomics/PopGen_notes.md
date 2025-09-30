# [Population Genomics Notebook]{.underline}

## Fall 2025 Ecological Genomics

## Author: Sarah Stover

These are my notes on our pop gen coding sessions!

### 09/11/25: Cleaning fastq reads of red spruce

we wrote a bashscript called "fastp.sh" within the my/scripts folder.Raw fastq files were located on the sharespace:

-   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/fastq/red_spruce`

The code copied a specific subset of spruce reads from ecogen folder, and using the program fastp, trimmed the adaptors, filtered raw reads for quality. Clean read outputs were loaded into the following directory on the class sharespace:

-   `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/cleanreads`

sample quality report files are located in:

-   `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myresults/fastp_reports`

results showed high quality seq, most Q scores were \>\>20, low amount of adaptor contamination was trimmed out. The first 12 bp were also trimmed out to get rid of barcodiing indices. Cleaned reads are now ready to proceed to the next step in the pipeline - mapping to the ref genome.

### 9/16/25: Mapping Clean reads to the ref genome

we wanted to run 3 scripts that would take our clean reads and align them to the reference genome.

1.  Mapping to the genome: `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts`

    INPUT: \``` /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/cleanreads` ``

    OUTPUT: `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`\`

    -   this is the mapping step, so taking the clean paired end reads and aligning them to the genome

2.  Converting SAM to BAM files and sorting the BAM files

    INPUT: \``` /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams` ``

    OUTPUT: `/gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams`\`

    -   this step converts the SAM files to BAM files (binary format), removing PCR duplicates and indexing for fast lookup

3.  getting the BAM stats to see how many reads were mapped successfully

    INPUT: \``` /gpfs1/cl/ecogen/pbio6800/PopulationGenomics/bams` ``

    OUTPUT: `` `users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myresults/2505.stats.txt` ``

    -   this step creates a file that has bwa alignment stats and the mean sequencing coverage

We were having problems running the mapping script (1) so we made a wrapper bash script for faster processing:

-   `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/bam_process_stats_wrap.sh`

need to run this before thursday! -DONE 

### 9/18/25: Review Bamstats and set up nucleotide diversity estimation using ANGSD

wrote a short bam script called:

* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/bamstats_review.r`

saw roughly 66% of reads mapped onto the genome in proper pairs 
obtained depth of coverage btwn 2-3x suggesting we should use low depth coverage analysis tools
ex. ANGSD (takes probability into account)

we wrote 3 scripts today to calculate nucleotide diversity using the program ANGSD

1. `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/ANGSD.sh`
* this file estimates genotype liklihood

2. `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/ANGSD_doTheta.sh`
* this file calculated the nucleotide diversity stats (ie. theta)

3. `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/diversity_wrap.sh`
* this file wraps the other two files above into one bashscript 

### 9/23/25: Exploring Nucleotide diversity in our population dataset 

After fixing our ANGSD_doTheta.sh file (the last line was missing part of the input name), we graphed some of the nucleotide diversity data in the following file 
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/mydocs/Nucleotide Diversity.Rmd`

### 9/25/25: Looking at pop diversity and pop structure across the Red spruce range 

We first wrote a script to calculate Fst: 
this used an input of black spruce data and my 2505 population of red spruce ANGSD data  
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/ANGSD_Fst.sh`
my Fst was 0.22045

Then, we ran PCAngsd using all samples (not just our population).
Genotype liklihood outputs are found in: 
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/ANGSD_RSBS_poly.sh`

We made a batch script called "PCAngsd_RSBS.sh", this script runs pcangsd using our genotype liklihoods, calculating eigen values for the PCA
This is specific to ANGSD because it uses the GL in the beagle file to start and then iteratively relaxing the assumption that the indiv come 
from the same populatons. The genotypes will depend on the structure of the population so it tries to cluster the indiv. based on the original 
clustering, does this until it finds the clusters with the allele freq that are most like the orginal groups. WE tell it how many eigenvalues (K - clustering) 
to use, K being the number of distinct ancestry groups. We used 2: Black spruce and red spruce 
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/PCAngsd.RSBS.sh`
Once the run finished,the following files were outputs in `myresults/ANGSD/PCA_Admix/`
* `RSBS_bam.list`
* `RSBS_poly.cov`
* `RSBS_poly.admix.2.Q`

Finally  we made an RMarkdown document visualizing the red spruce-black spruce genetic PCAs and admixture analysis.
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/PCA_Admix.Rmd`

### 9/30/25: playing around with the clustering and eigenvalues
we learned about how PCA axis are calculated and we changed the K or clustering groups to rerun the PCA. 
The VACC made me wait in line for too long but I originally changed the K variable in my `PCAngsd_RSBS.sh' file to 3. 
We also isolated the RS samples from the BS samples to re-plot the PCA without the black spruce samples to gage whether there was any introgression regions 
under selection. 
This is the new PCA script without Black spruce: 
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/myscripts/PCAngsd_RSfilt.sh`
This is the rmd file with the plots:
* `/users/s/s/sstover/projects/eco_genomics_2025/population_genomics/mydocs/RS_Selection.Rmd`

