#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=BamSum
#SBATCH --output=BamSummary.out
#SBATCH --time=10:00:00

#######################################################################################
#bam summary 
#######################################################################################
mkdir Deeptools

#H3K27ac
multiBamSummary bins --bamfiles aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO KO WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K27ac_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20 --centerReads

#H3K9ac
multiBamSummary bins --bamfiles aligned/SRR6326786_dedup.bam SRR6326788_dedup.bam aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO WT WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K9ac_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20 --centerReads 

 #Plot the correlation between samples as either a PCA or a Correlation Plot:
 
 #For H3K27ac:
     
     plotPCA -in Deeptools/H3K27ac_BamSum10kbbins.npz -o Deeptools/PCA_H3K27ac.pdf -T "PCA of Sequencing Depth Normalized Read Counts" --plotHeight 7 --plotWidth 9


    plotCorrelation -in Deeptools/H3K27ac_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_H3K27ac.pdf
    
# For H3K9ac:
     
     plotPCA -in Deeptools/H3K9ac_BamSum10kbbins.npz -o Deeptools/PCA_H3K9ac.pdf -T "PCA of Sequencing Depth Normalized Read Counts" --plotHeight 7 --plotWidth 9


    plotCorrelation -in Deeptools/H3K9ac_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_H3K9ac.pdf