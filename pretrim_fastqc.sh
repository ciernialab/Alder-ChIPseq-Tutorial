#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=PreTrimFastqc
#SBATCH --output=PreTrimFastqc.out
#SBATCH --time=2:00:00

#######################################################################################
#fastqc and then combine reports into one html and save to outputs folder

#######################################################################################
mkdir -p output/pretrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting"

fastqc SRA/${sample}_1.fastq.gz --outdir output/pretrim

fastqc SRA/${sample}_2.fastq.gz --outdir output/pretrim

echo ${sample} "finished"


done



#######################################################################################
#combine
#######################################################################################

multiqc output/pretrim --filename output/PretrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive
