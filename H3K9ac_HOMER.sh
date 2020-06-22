#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=MakeTags_H3K9ac
#SBATCH --output=HOMERTagDirH3K9ac.out
#SBATCH --time=10:00:00

module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

###########################################################################################
#######################################################################################
#H3K9ac
#######################################################################################
#KO:
#SRR6326786	H3K9ac	HDAC1&2 microglial deletion
#SRR6326788	H3K9ac	HDAC1&2 microglial deletion
makeTagDirectory TagDirectory/Pooltag_H3K9ac_HDAC1_2KO aligned/SRR6326786_dedup.bam aligned/SRR6326788_dedup.bam

#find peaks with Wendlen paper parameters:
findPeaks TagDirectory/Pooltag_H3K9ac_HDAC1_2KO -style histone -size 250 -minDist 500 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/Homerpeaks_H3K9ac_HDAC1_2KO.txt

#######################################################################################

#WT
#SRR6326790	H3K9ac	wildtype
#SRR6326792	H3K9ac	wildtype
#SRR6326794	H3K9ac	wildtype

makeTagDirectory TagDirectory/Pooltag_H3K9ac_WT aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam

#find peaks with Wendlen paper parameters:
findPeaks TagDirectory/Pooltag_H3K9ac_WT -style histone -size 250 -minDist 500 -i TagDirectory/Pooltag_input_WT -o homer_regions/Homerpeaks_H3K9ac_WT.txt


##########################################################################################
#combine peaks
##########################################################################################

mergePeaks homer_regions/Homerpeaks_H3K9ac_HDAC1_2KO.txt homer_regions/Homerpeaks_H3K9ac_WT.txt > homer_regions/H3K9ac_all.peaks.txt
#######################################################################################
#KO vs WT H3K9ac DE
#######################################################################################

#quantify the reads at the initial putative peaks across each of the target and input tag directories using annotatePeaks.pl. 
#http://homer.ucsd.edu/homer/ngs/diffExpression.html
#generate raw counts file from each tag directory for each sample for the merged peaks:
#TagDirectory/tag_${sample} aligned/${sample}_dedup.bam #-sspe
annotatePeaks.pl homer_regions/H3K9ac_all.peaks.txt mm10 -raw -d TagDirectory/tag_SRR6326786 TagDirectory/tag_SRR6326788 TagDirectory/tag_SRR6326790 TagDirectory/tag_SRR6326792 TagDirectory/tag_SRR6326794 > countTable.H3K9ac.peaks.txt


# Finally, it calls getDiffExpression.pl and ultimately passes these values to the R/Bioconductor package DESeq2 to calculate enrichment values for each peak, returning only those peaks that pass a given fold enrichment (default: 2-fold) and FDR cutoff (default 5%).
#Once you have a raw count file containing a tab-delimited matrix of raw count files, you're ready to run getDiffExpression.pl. The getDiffExpression.pl program is executed with the following arguments:
#getDiffExpression.pl <raw count file> <group code1> <group code2> [group code3...] [options] > diffOutput.txt

#example for the RNAseq file prepared from above
#getDiffExpression.pl countTable.rna.txt Mock Mock WNT WNT > diffOutput.txt

getDiffExpression.pl countTable.H3K9ac.peaks.txt Hdac12KO Hdac12KO Hdac12KO WT WT -simpleNorm > H3K9ac_diffpeaksOutput.txt



