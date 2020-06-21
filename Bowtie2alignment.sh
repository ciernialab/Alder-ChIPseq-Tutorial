#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=BT2
#SBATCH --output=BT2alignment.out
#SBATCH --time=16:00:00
#######################################################################################
###############################################################################

#######################################################################################
mkdir aligned
mkdir -p output/bowtielogs


for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting alignment"

#align trimmed reads using bowtie2
# --no-unal          suppress SAM records for unaligned reads
$BT2_HOME/bowtie2 -x $BT2_MM10/genome -1 trimmed/${sample}_1.paired.fastq.gz -2 trimmed/${sample}_2.paired.fastq.gz -S aligned/${sample}.sam -p 20 --no-unal --time 2> output/bowtielogs/${sample}_bowtie2log.log  

echo ${sample} "finished alignment"


done


#######################################################################################
#combine
#######################################################################################
multiqc output/bowtielogs --filename output/bowtie2_multiqc_report.html --ignore-samples Undetermined* --interactive
