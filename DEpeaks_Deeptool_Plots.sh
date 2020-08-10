#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=DEpeaks_deeptools
#SBATCH --output=DEpeaks_deeptools.out
#SBATCH --time=5:00:00


# This script is modified from the old script (Geneplots_deeptols.sh) by
# - creating a new directory
# - using the BED file from the DEpeak finding instead of the mm10refseq.bed
# - using the bigwig files created by UCSCBrowserHOMER.sh instead of the bigwig files in the BigWigs directory



########################################################################################
#create new directory to store files
########################################################################################

mkdir DEpeaks_Deeptools

########################################################################################
#plot DEpeaks using DEpeaks
########################################################################################
#H3K27ac Gosselin
##########################################################################################

# this was changed to include the bed file from the DEpeak finding
# the bigwig files from the UCSSCBroswerHOMER.sh script is used as well. Note how they match up exactly
# with the --samplesLabel labels listed in the plotProfile command. This is important
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R DEpeaks/FDRfiltered.Gosselin.H3K27ac_diffpeaksOutput.bed -S UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw UCSCbrowsertracks/WT_H3K27ac_Repl1.bw UCSCbrowsertracks/WT_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o DEpeaks_Deeptools/mouseTSS.H3K27ac_Gosselin.tab.gz --skipZeros --binSize 10 --outFileSortedRegions DEpeaks_Deeptools/H3K27acTSS_Gosselin_out.bed

# plot
plotProfile -m DEpeaks_Deeptools/mouseTSS.H3K27ac_Gosselin.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out DEpeaks_Deeptools/profile_H3K27ac_Gosselin.pdf --averageType mean --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m DEpeaks_Deeptools/mouseTSS.H3K27ac_Gosselin.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out DEpeaks_Deeptools/Heatmap.mouseTSS.H3K27ac_Gosselin.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean

############################################################################################

##########
#H3K27ac Wendlen
##########################################################################################
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R DEpeaks/FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.bed -S UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw UCSCbrowsertracks/WT_H3K27ac_Repl1.bw UCSCbrowsertracks/WT_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o DEpeaks_Deeptools/mouseTSS.H3K27ac_Wendlen.tab.gz --skipZeros --binSize 10 --outFileSortedRegions DEpeaks_Deeptools/H3K27acTSS_Wendlen_out.bed

# plot
plotProfile -m DEpeaks_Deeptools/mouseTSS.H3K27ac_Wendlen.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out DEpeaks_Deeptools/profile_H3K27ac_Wendlen.pdf --averageType mean --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m DEpeaks_Deeptools/mouseTSS.H3K27ac_Wendlen.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out DEpeaks_Deeptools/Heatmap.mouseTSS.H3K27ac_Wendlen.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean



########################################################################################
#H3K9ac Gosselin
##########################################################################################
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R DEpeaks/FDRfiltered.Gosselin.H3K9ac_diffpeaksOutput.bed -S UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl1.bw UCSCbrowsertracks/WT_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl3.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o DEpeaks_Deeptools/mouseTSS.H3K9ac_Gosselin.tab.gz --skipZeros --binSize 10 --outFileSortedRegions DEpeaks_Deeptools/H3K9acTSS_Gosselin_out.bed

# plot
plotProfile -m DEpeaks_Deeptools/mouseTSS.H3K9ac_Gosselin.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out DEpeaks_Deeptools/profile_H3K9ac_Gosselin.pdf --averageType mean --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m DEpeaks_Deeptools/mouseTSS.H3K9ac_Gosselin.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out DEpeaks_Deeptools/Heatmap.mouseTSS.H3K9ac_Gosselin.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean

############################################################################################

########################################################################################
#H3K9ac Wendlen
##########################################################################################
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R DEpeaks/FDRfiltered.Wendlen.H3K9ac_diffpeaksOutput.bed -S UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl1.bw UCSCbrowsertracks/WT_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl3.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o DEpeaks_Deeptools/mouseTSS.H3K9ac_Wendlen.tab.gz --skipZeros --binSize 10 --outFileSortedRegions DEpeaks_Deeptools/H3K9acTSS_Wendlen_out.bed 

# plot
plotProfile -m DEpeaks_Deeptools/mouseTSS.H3K9ac_Wendlen.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out DEpeaks_Deeptools/profile_H3K9ac_Wendlen.pdf --averageType mean --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m DEpeaks_Deeptools/mouseTSS.H3K9ac_Wendlen.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out DEpeaks_Deeptools/Heatmap.mouseTSS.H3K9ac_Wendlen.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean

############################################################################################
