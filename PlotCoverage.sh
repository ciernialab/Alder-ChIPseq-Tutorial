#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=PlotCoverage
#SBATCH --output=PlotCoverage.out
#SBATCH --time=5:00:00

#######################################################################################
#Coverage Plots
#To see how many bp in the genome are actually covered by (a good number) of sequencing reads, we use plotCoverage which generates two diagnostic plots that help us decide whether we need to sequence deeper or not. It samples 1 million bp, counts the number of overlapping reads and can report a histogram that tells you how many bases are covered how many times. Multiple BAM files are accepted, but they all should correspond to the same genome assembly.

#######################################################################################

#H3K27ac
plotCoverage --bamfiles aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO KO WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K27ac_Coverage.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --extendReads --plotFileFormat pdf

#H3K9ac
plotCoverage --bamfiles aligned/SRR6326786_dedup.bam aligned/SRR6326788_dedup.bam aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO WT WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K9ac_Coverage.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --extendReads --plotFileFormat pdf

 