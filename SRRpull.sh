#!/bin/bash
#
#SBATCH -c 2
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=SRAfetch
#SBATCH --output=SRAfetch.out
#SBATCH --time=12:00:00


#HDAC1&2 CHIPSEQ analysis
#pull SRA files from GEO: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107436
#######################################################################################
# run from HDAC1_2_ChIPseq directory
#puts data in shared data file for the experiment
#######################################################################################
mkdir -p SRA/

for sample in `cat SRR_Acc_List.txt`
do

cd ~/HDAC1_2_ChIPseq/SRA/

echo ${sample} "starting SRR pull"
prefetch ${sample}

#######################################################################################
#paired end sra > Fastq.gz
#######################################################################################
echo ${sample} "starting dump"

fastq-dump --origfmt --split-files --gzip ${sample}

echo ${sample} "done"
#######################################################################################

done
