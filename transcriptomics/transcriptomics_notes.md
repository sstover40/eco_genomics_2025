# [Transcriptomics Notebook]{.underline}

## Fall 2025 Ecological Genomics

## Author: Sarah Stover

These are my notes on our transcriptomics coding sessions!

### 10/07/25: looking at transcriptomic raw data files

I was assigned C2 files.

we looked for the transcriptomic raw data files in: `/gpfs1/cl/ecogen/pbio6800/Transcriptomics/RawData` using zcat <filename> \| head -n 4 
we could look at the first 4 lines of the file 
congrats! Everything looks good. moving on..

### 10/09/25: trimming and visualizing reads, mapping 

last week we did not have time to run our cleaning and trimming reads script due to file recognition issues.
but this week we did have more time. So we ran "bash"(<--since its not a batch job)

-`/users/s/s/sstover/projects/eco_genomics_2025/transcriptomics/myscripts/fastp_tonsa.sh`

side note: to create a global alias (permanent) go to your .bashrc file in the home directory
  ll -a ~/ 
  nano .bashrc 
  <name>=alias"command"
  
also ran salmon but nicole got there before me! Salmon makes K-mers 
Salmon does not consider length so as long as it is longer than the K-mer length it will try to map the reads

there are two thoughts: usually some people do not want to touch the primer reads or filter too much in case there are splice variants etc 
other people want to do the opposite 

###10/14/25: Exploring mapping rate and importing it into DEseq

we cd into `/gpfs1/cl/ecogen/pbio6800/Transcriptomics/Transcripts_quant` to look at the size and quantity of the transcripts 
`head quant.sf`

wc -l was about 119436 meaning that is the amount of transcripts that we have. 
we want to make sure the mapping rate is also ok across all samples:
`grep -r --include \*.log -e 'Mapping rate'`
or 
`grep -r --include "*.log" -e "Mapping rate" | sed -E 's|/logs/.*:.*Mapping rate = ([0-9.]+)%|\t\1|'`

this gave us a list of all the samples and their mapping rate. the mapping rate for all the samples was around 40% which is low. 
typically you want to have a mapping rate of 80% or greater. We discussed factors that could affect the mapping rate 
* contamination of reads from other taxa (Bacterial, human, algae) these would not map to the reference 
* low RNA quality or low RNA yield since the library prep was ultra-low RNA 
* could try with a head crop to get rid of primer reads, these may affect the mapping rate
* could also do a new de novo assembly from these reads (would need to annotate them) 

We made a list of sample files with their full path names: 
cd /gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant

`echo "sample,path" > /gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant/samples.csv
for dir in */; do
  sample_name=${dir%/}
  echo "${sample_name},/gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant/${sample_name}" >> /gpfs1/cl/ecogen/pbio6800/Transcriptomics/transcripts_quant/samples.csv
done`

Here is the file:`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydata/samples.csv`

We also made a counts_matrix to import into DESeq: 
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/myscripts/create_counts_matrix.r`

# DESeq2 start of our data analysis! 

###10/21/23 Import to DESeq2 and visualize (https://pespenilab.github.io/Ecological-Genomics/Fall2025/tutorials/EcoGen2025_Transcriptomics4_GeneExpressionAnalysis.html)

In today's class, we continued visualizing the dataset by making an MA plot, volcano plot, several heatmaps, and a Venn Diagram which are outlined in the RMarkdown file 
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydocs/DEseq2_tonsa_multigen.Rmd.` 
Each plot is meant to show us the following:

-   MA plot - Plotting the relationship between LFC and magnitude of expression.

-   Volcano plot - Plotting the relationship between LFC and significance of DGE in Generation 1, comparing control and treatment.

-   Heatmaps - Plotting relative expression on gene and sample level

    -   Heatmap 1: Plotting top 20 genes sorted by p-value.

    -   Heatmap 2: Plotting LFC and G1 significant genes and how they change across generations.

    -   Heatmap 3: Plotting LFC and G2 significant genes and how they change across generations.

-   Venn Diagram - Plotting overlap between genes differentially expressed between treatments across generations.

####10/23/25 - Functional enrichment analysis (https://pespenilab.github.io/Ecological-Genomics/Fall2025/tutorials/EcoGen2025_Transcriptomics5_FunctionalEnrichment.html)

Today, we began to run a Gene Ontology (GO) analysis and look for functional enrichment with various statistical tests. To do this we used TopGO 

We created a new RMarkdown file that took our DESeq outputs and put them in the proper format for analysis as well as got GO terms for our genes 
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydata/Genes_GO_terms_outputs.tsv`
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydata/topGOsig_for_REVIGO.txt`

First, we began by visualizing our data using several different plot types in this file: 
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydocs/DESeq2ToTopGo.Rmd`
we created a topGO plot and REVIGO plot.

###10/28/25 WGCNA (Weighted Gene Correlation Network Analysis)

today we are doing our WGCNA to look at functional enrichment and figure out what networks of genes may be involved in the phenotype we are
interested in. In this case it was ULT (Upper lethal temp) 

We created a new markdown file do do the WGCNA analysis
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydocs/DESeq2toWGCNA.Rmd`

copied the WCGNA trait data from the class netfile and put it in the mydata folder 
*`/gpfs1/s/s/sstover/projects/eco_genomics_2025/transcriptomics/mydata/WGCNA_TraitData.csv`

We filtered our DESeq2 data 
calculated pairwise correlations (differential expression of every gene against every gene)
created an adjacency matrix that quantified these correlations and then chose a soft-threshold power by visualizing...  (I used 24)
Made a scale-free topology index - this measured the relationships of the genes in the network 
detected modules using our soft-threshold power - this calculated eigengene values for our networks (I had 18 modules)
Tested for correlation with trait data (highest correlation was MEsalmon at 0.48) then visualized the 






