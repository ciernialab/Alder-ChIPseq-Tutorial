#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=BamCov
#SBATCH --output=BamCovDeeptools.out
#SBATCH --time=10:00:00

#######################################################################################
#fastqc and then combine reports into one html and save to outputs folder
#effective genome size is set for mappable part of mm10
#bamCoverage --bam aligned/SRR6326792_dedup.bam -o BigWigs/SRR6326792.bw --ignoreDuplicates --binSize 10 --effectiveGenomeSize 2652783500 --ignoreForNormalization chrM chrX chrY --extendReads -p 20 --centerReads --minFragmentLength 0 --maxFragmentLength 150 --blackListFileName $BL/mm10.blacklist.bed
#######################################################################################
mkdir BigWigs

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting"


bamCoverage --bam aligned/${sample}_dedup.bam -o BigWigs/${sample}.bw --ignoreDuplicates --binSize 10 --effectiveGenomeSize 2652783500 --ignoreForNormalization chrM chrX chrY --extendReads -p 20 --centerReads --minFragmentLength 0 --maxFragmentLength 150 --blackListFileName $BL/mm10.blacklist.bed


echo ${sample} "finished"


done



