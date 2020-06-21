#!/bin/bash
#
#SBATCH -c 16
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=SAMFilter
#SBATCH --output=SAMFilter.out
#SBATCH --time=12:00:00
#######################################################################################
#######################################################################################
#sort with samtools and filter
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121 #this loads Java 1.8 working environment
module load R/3.6.1 #picard needs this

mkdir -p output/sam/

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting filtering"

#properly mapped and paired reads:

#pipe samtools: https://www.biostars.org/p/43677/

#flags:
# 0x1 template having multiple segments in sequencing
# 0x2 each segment properly aligned according to the aligner
# 0x4 segment unmapped
# 0x8 next segment in the template unmapped
# 0x10 SEQ being reverse complemented
# 0x20 SEQ of the next segment in the template being reversed
# 0x40 the ﬁrst segment in the template
# 0x80 the last segment in the template
# 0x100 secondary alignment
# 0x200 not passing quality controls
#0x400 PCR or optical duplicate

echo ${sample} "converting sam to bam"

#convert sam to bam and name sort for fixmate
#-@ 16 sets to 16 threads
samtools view -bS aligned/${sample}.sam | samtools sort -n -@ 16 - -o aligned/${sample}_tmp.bam

echo ${sample} "removing unmapped reads"

#Remove unmapped reads and secondary alignments from name sorted input
#samtools view -bS test.sam | samtools sort -n -@ 16 -o test_tmp.bam
samtools fixmate -r aligned/${sample}_tmp.bam aligned/${sample}_tmp2.bam


echo ${sample} "removing unpaired reads"
#coordinate sort, then filter:
#remove PCR duplicates:https://www.biostars.org/p/318974/
# -F INT   only include reads with none of the bits set in INT set in FLAG [0]
#so include none of 0x400
#keep only output propper pairs: https://broadinstitute.github.io/picard/explain-flags.html
# -f 0x2
#samtools sort -@ 16 test_tmp2.bam |samtools view -b -F 0x400 -f 0x2 -@ 16 - -o test_dedup.bam 
samtools sort -@ 16 aligned/${sample}_tmp2.bam |samtools view -b -F 0x400 -f 0x2 -@ 16 - -o aligned/${sample}_dedup.bam 

echo ${sample} "index"

#index
samtools index aligned/${sample}_dedup.bam 

echo ${sample} "QC metrics"

#fix mate information
#java -jar $PICARD FixMateInformation I=aligned/${sample}_dedup.bam O=output/sam/${sample}_fixmate.txt

#picard alignment summary
java -jar $PICARD CollectAlignmentSummaryMetrics I=aligned/${sample}_dedup.bam O=output/sam/${sample}_dedup_alignsum.txt

#find insert size
java -jar $PICARD CollectInsertSizeMetrics I=aligned/${sample}_dedup.bam H=output/sam/${sample}_histogram.pdf O=output/sam/${sample}_insertmetric.txt

#flagstat
samtools flagstat aligned/${sample}_dedup.bam > output/sam/${sample}_dedupFlagstat.txt


rm aligned/${sample}_tmp.bam
rm aligned/${sample}_tmp2.bam

echo ${sample} "finished filtering"


done

#######################################################################################
#combine
#######################################################################################
multiqc output/sam --filename output/sam_multiqc_report.html --ignore-samples Undetermined* --interactive
