#!/bin/bash
#
#SBATCH -c 2
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=SRAfetch
#SBATCH --output=SRAfetch.out
#SBATCH --time=8:00:00


#HDAC1&2 CHIPSEQ analysis
#pull SRA files from GEO: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107436
#######################################################################################
# run from home directory
#puts data in shared data file for the experiment
#######################################################################################
mkdir -p /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting SRR pull"
prefetch /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/${sample}

#######################################################################################
#paired end sra > Fastq.gz
#######################################################################################
echo ${sample} "starting dump"

fastq-dump --origfmt --split-files --gzip /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/${sample}

echo ${sample} "done"
#######################################################################################

done