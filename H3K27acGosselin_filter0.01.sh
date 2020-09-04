#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=H3K27ac.filter0.01
#SBATCH --output=H3K27ac.filter0.01.out
#SBATCH --time=4:00:00

# this script combines scripts from 2 separate script files to make running easier
# code is taken from Convert_DEpeaks_to_bed.sh, and DEpeaks_Deeptool_Plots.sh
# and only one example was shown using H3K27ac Gosselin

# similar to before, we can use awk to filter our file.
# awk '{print NF}' Wendlen.H3K27ac_diffpeaksOutput.txt | uniq

# Since the value we want to filter by (the non-adjusted p-value) is the column right before the
# FDR adjusted p-value, and we previously determined that to be column 19 (see previous Convert_DEpeaks_to_bed.sh
# for more details), we can just filter by column 18 here, and set the value to be <=0.01

##########################################################################################
#sort txt files by non-ajusted p value, filter for <=0.01, and output to new file
########################################################################################

#H3K27ac Gosselin
awk '{if($18<=0.01) {print}}' DEpeaks/Gosselin.H3K27ac_diffpeaksOutput.txt > DEpeaks/filtered0.01.Gosselin.H3K27ac_diffpeaksOutput.txt


##########################################################################################
#Convert HOMER peak files to bed format for UCSC genome browser
########################################################################################
#H3K27ac Gosselin
#######################################################################################

grep -v '^#' DEpeaks/filtered0.01.Gosselin.H3K27ac_diffpeaksOutput.txt > DEpeaks/tmp.txt

    perl pos2bedmod.pl DEpeaks/tmp.txt > DEpeaks/tmp.bed

    sed 's/^/chr/' DEpeaks/tmp.bed > DEpeaks/filtered0.01.Gosselin.H3K27ac_diffpeaksOutput.bed

    rm DEpeaks/tmp*


########################################################################################
#plot DEpeaks using DEpeaks
########################################################################################
#H3K27ac Gosselin
##########################################################################################

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R DEpeaks/filtered0.01.Gosselin.H3K27ac_diffpeaksOutput.bed -S UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw UCSCbrowsertracks/WT_H3K27ac_Repl1.bw UCSCbrowsertracks/WT_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o DEpeaks_Deeptools/DEpeaks.H3K27ac_Gosselin_filtered0.01.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions DEpeaks_Deeptools/H3K27acDEpeaks_Gosselin_filtered0.01_out.bed

# plot
plotProfile -m DEpeaks_Deeptools/DEpeaks.H3K27ac_Gosselin_filtered0.01.tab.gz  --numPlotsPerRow 2 --regionsLabel "Gosselin DE H3K27ac Peaks" --plotFileFormat "pdf" -out DEpeaks_Deeptools/profile_H3K27ac_Gosselin_filtered0.01.pdf --averageType mean --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m DEpeaks_Deeptools/DEpeaks.H3K27ac_Gosselin_filtered0.01.tab.gz --regionsLabel "Gosselin DE H3K27ac Peaks" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out DEpeaks_Deeptools/Heatmap.DEpeaks.H3K27ac_Gosselin_filtered0.01.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12
