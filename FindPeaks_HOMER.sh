#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=FindPeaks
#SBATCH --output=FindPeaks.out
#SBATCH --time=10:00:00

module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

##########################################################################################
#Make peaks for pooled tag directories
#1. using Wendeln paper settings
#2. using Gosselin paper settings
########################################################################################
#H3K27ac Wendlen
#######################################################################################
mkdir homer_regions/
#HDAC1/2KO MG:
#SRR6326785
#SRR6326800
#SRR6326801

makeTagDirectory TagDirectory/Pooltag_H3K27ac_HDAC12KO aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam

#SRR6326787	input
#SRR6326789	input

makeTagDirectory TagDirectory/Pooltag_input_HDAC1_2KO aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam

#SRR6326796	H3K27ac
#SRR6326798	H3K27ac

makeTagDirectory TagDirectory/Pooltag_H3K27ac_WT aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam

#SRR6326791	input	wildtype
#SRR6326793	input	wildtype
#SRR6326795	input	wildtype
#SRR6326797	input	wildtype
#SRR6326799	input	wildtype

makeTagDirectory TagDirectory/Pooltag_input_WT aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam
#######################################################################################
#HDAC1/2KO:
findPeaks TagDirectory/Pooltag_H3K27ac_HDAC12KO -style histone -size 250 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.txt

#WT
findPeaks TagDirectory/Pooltag_H3K27ac_WT -style histone -size 250 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt


########################################################################################
#H3K27ac Gosselin
#######################################################################################

#HDAC1/2 KO: 3 replicates
findPeaks TagDirectory/Pooltag_H3K27ac_HDAC12KO -style histone -size 500 -minDist 1000 -region -tbp 3 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.txt

#HDAC1/2 WT: 2 replicates
findPeaks TagDirectory/Pooltag_H3K27ac_WT -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksGosselin_H3K27ac_WT.txt

#######################################################################################
#H3K9ac
#######################################################################################
#KO:
#SRR6326786	H3K9ac	HDAC1&2 microglial deletion
#SRR6326788	H3K9ac	HDAC1&2 microglial deletion
makeTagDirectory TagDirectory/Pooltag_H3K9ac_HDAC1_2KO aligned/SRR6326786_dedup.bam aligned/SRR6326788_dedup.bam


#WT
#SRR6326790	H3K9ac	wildtype
#SRR6326792	H3K9ac	wildtype
#SRR6326794	H3K9ac	wildtype

makeTagDirectory TagDirectory/Pooltag_H3K9ac_WT aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam


########################################################################################
#H3K9ac Wendlen
#######################################################################################
#HDAC1/2KO:
findPeaks TagDirectory/Pooltag_H3K9ac_HDAC1_2KO -style histone -size 250 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.txt

#WT
findPeaks TagDirectory/Pooltag_H3K9ac_WT -style histone -size 250 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksWendlen_H3K9ac_WT.txt


########################################################################################
#H3K9ac Gosselin
#######################################################################################

#HDAC1/2 KO: 2 replicates
findPeaks TagDirectory/Pooltag_H3K9ac_HDAC1_2KO -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.txt

#HDAC1/2 WT: 3 replicates
findPeaks TagDirectory/Pooltag_H3K9ac_WT -style histone -size 500 -minDist 1000 -region -tbp 3 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksGosselin_H3K9ac_WT.txt



