#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=DiffPeaks
#SBATCH --output=DiffPeaks.out
#SBATCH --time=4:00:00

#######################################################################################
#merges peaks, annotates and calls DE peaks
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir DEpeaks/
#######################################################################################
#Combine WT and KO peaks into one file for annotation using mergPeaks.
#For H3K27ac peaks:

    mergePeaks homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.txt homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt > homer_regions/HomerpeaksWendlen_H3K27ac_all.txt
    
    mergePeaks homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.txt homer_regions/HomerpeaksGosselin_H3K27ac_WT.txt > homer_regions/HomerpeaksGosselin_H3K27ac_all.txt

#For H3K9ac peaks:

    mergePeaks homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.txt homer_regions/HomerpeaksWendlen_H3K9ac_WT.txt > homer_regions/HomerpeaksWendlen_H3K9ac_all.txt
    
    mergePeaks homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.txt homer_regions/HomerpeaksGosselin_H3K9ac_WT.txt > homer_regions/HomerpeaksGosselin_H3K9ac_all.txt

#Quantify the reads at the initial putative peaks across each of the target and input tag directories using annotatePeaks.pl. 
#http://homer.ucsd.edu/homer/ngs/diffExpression.html. This generate raw counts file from each tag directory for each sample for the merged peaks.

#IMPORTANT: Make sure you remember the order that your experiments and replicates where entered in for generating these commands.  Because experiment names can be cryptic, you will need to specify which experiments are which when running getDiffExpression.pl to assign replicates and conditions.
  
    annotatePeaks.pl homer_regions/HomerpeaksWendlen_H3K27ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326785 TagDirectory/tag_SRR6326800 TagDirectory/tag_SRR6326801  TagDirectory/tag_SRR6326796 TagDirectory/tag_SRR6326798 > DEpeaks/countTable.Wendlen.H3K27ac_all.peaks.txt

	annotatePeaks.pl homer_regions/HomerpeaksGosselin_H3K27ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326785 TagDirectory/tag_SRR6326800 TagDirectory/tag_SRR6326801  TagDirectory/tag_SRR6326796 TagDirectory/tag_SRR6326798 > DEpeaks/countTable.Gosselin.H3K27ac_all.peaks.txt
	
	annotatePeaks.pl homer_regions/HomerpeaksWendlen_H3K9ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326786 TagDirectory/tag_SRR6326788 TagDirectory/tag_SRR6326790 TagDirectory/tag_SRR6326792 TagDirectory/tag_SRR6326794 > DEpeaks/countTable.Wendlen.H3K9ac.peaks.txt

	annotatePeaks.pl homer_regions/HomerpeaksGosselin_H3K9ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326786 TagDirectory/tag_SRR6326788 TagDirectory/tag_SRR6326790 TagDirectory/tag_SRR6326792 TagDirectory/tag_SRR6326794 > DEpeaks/countTable.Gosselin.H3K9ac.peaks.txt

#Calls getDiffExpression.pl and ultimately passes these values to the R/Bioconductor package DESeq2 to calculate enrichment values for each peak, returning only those peaks that pass a given fold enrichment (default: 2-fold) and FDR cutoff (default 5%).

#The getDiffExpression.pl program is executed with the following arguments:
#getDiffExpression.pl <raw count file> <group code1> <group code2> [group code3...] [options] > diffOutput.txt

#Provide sample group annotation for each experiment with an argument on the command line (in the same order found in the file, i.e. the same order given to the annotatePeaks.pl command when preparing the raw count file).

  
    getDiffExpression.pl DEpeaks/countTable.Wendlen.H3K27ac_all.peaks.txt Hdac12KO Hdac12KO Hdac12KO WT WT -simpleNorm > DEpeaks/Wendlen.H3K27ac_diffpeaksOutput.txt
    
    getDiffExpression.pl DEpeaks/countTable.Gosselin.H3K27ac_all.peaks.txt Hdac12KO Hdac12KO Hdac12KO WT WT -simpleNorm > DEpeaks/Gosselin.H3K27ac_diffpeaksOutput.txt

    getDiffExpression.pl DEpeaks/countTable.Wendlen.H3K9ac.peaks.txt Hdac12KO Hdac12KO WT WT WT -simpleNorm > DEpeaks/Wendlen.H3K9ac_diffpeaksOutput.txt
    
    getDiffExpression.pl DEpeaks/countTable.Gosselin.H3K9ac.peaks.txt Hdac12KO Hdac12KO WT WT WT -simpleNorm > DEpeaks/Gosselin.H3K9ac_diffpeaksOutput.txt
