# [Transcriptomics Notebook]{.underline}

## Fall 2025 Ecological Genomics

## Author: Sarah Stover

These are my notes on our transcriptomics coding sessions!

### 10/07/25: looking at transcriptomic raw data files

I was assigned C2 files.

we looked for the transcriptomic raw data files in: `/gpfs1/cl/ecogen/pbio6800/Transcriptomics/RawData` using zcat <filename> \| head -n 4 
we could look at the first 4 lines of the file 
congrats! Everything looks good. moving on..

### 10/09/25: trimming and visualizing reads

last week we did not have time to run our cleaning and trimming reads script due to file recognition issues.
but this week we did have more time. So we ran "bash" (\<--since its not a batch job)

-   `/users/s/s/sstover/projects/eco_genomics_2025/transcriptomics/myscripts/fastp_tonsa.sh`

side note: to create a global alias (permanent) go to your .bashrc file in the home directory
  ll -a ~/ 
  nano .bashrc 
  <name>=alias"command"
  
also ran salmon but nicole got there before me!