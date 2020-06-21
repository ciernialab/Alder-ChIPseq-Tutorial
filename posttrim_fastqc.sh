#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=PostTrimFastqc
#SBATCH --output=PostTrimFastqc.out
#SBATCH --time=2:00:00

#######################################################################################
mkdir -p output/posttrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastqc"

fastqc trimmed/${sample}_1.paired.fastq.gz --outdir output/posttrim

fastqc trimmed/${sample}_2.paired.fastq.gz --outdir output/posttrim

echo ${sample} "finished fastqc"


done


#######################################################################################


#######################################################################################
#combine
#######################################################################################

multiqc output/posttrim --filename output/PosttrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive
