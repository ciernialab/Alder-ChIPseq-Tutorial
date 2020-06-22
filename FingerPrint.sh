#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=FingerPrint
#SBATCH --output=FingerPrintPlot.out
#SBATCH --time=5:00:00

#######################################################################################
#PE fragment sizes
#This tool calculates the fragment sizes for read pairs given a BAM file from paired-end sequencing.Several regions are sampled depending on the size of the genome and number of processors to estimate thesummary statistics on the fragment lengths. Properly paired reads are preferred for computation, i.e., it will only use discordant pairs if no concordant alignments overlap with a given region. The default setting simply prints the summary statistics to the screen.

#######################################################################################

#H3K27ac
plotFingerprint -b aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO1 KO2 KO3 WT1 WT2 KOInput1 KOInput2 WTInput1 WTInput2 WTInput3 WTInput4 WTInput5 -o Deeptools/H3K27ac_Fingerprint.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf --outRawCounts H3K27ac.fingerprints.tab

#H3K9ac
plotFingerprint -b aligned/SRR6326786_dedup.bam aligned/SRR6326788_dedup.bam aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO1 KO2 WT1 WT2 WT3 KOInput1 KOInput2 WTInput1 WTInput2 WTInput3 WTInput4 WTInput5 -o Deeptools/H3K9ac_Fingerprint.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf --outRawCounts H3K9ac.fingerprints.tab


 