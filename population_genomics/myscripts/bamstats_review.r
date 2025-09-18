# Reviewing our bamstats 

setwd("population_genomics/myresults/")

stats <- read.table("2505.stats.txt", header = TRUE, sep = "\t")

View(stats)

#this will tell you how many reads did not match with the genome or did not go into proper paired end reads 
stats$pctPaired = stats$Num_Paired/stats$Num_reads


