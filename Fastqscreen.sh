#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=FastqScreen
#SBATCH --output=FastqScreen.out
#SBATCH --time=6:00:00

#######################################################################################
#fastq screen: http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/_build/html/index.html


#######################################################################################
mkdir -p output/fastq_screen

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastq screen"

fastq_screen --aligner bowtie2 trimmed/${sample}_1.paired.fastq.gz trimmed/${sample}_2.paired.fastq.gz --outdir output/fastq_screen


echo ${sample} "finished fastq screen"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/fastq_screen --filename output/FastqScreen_multiqc_report.html --ignore-samples Undetermined* --interactive
