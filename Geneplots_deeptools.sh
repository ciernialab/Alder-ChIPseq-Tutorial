#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=TSSplot
#SBATCH --output=TSSplot.out
#SBATCH --time=5:00:00


########################################################################################
#plot for signal over TSS regions of mouse genes
########################################################################################
#H3K27ac
##########################################################################################
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw UCSCbrowsertracks/WT_H3K27ac_Repl1.bw UCSCbrowsertracks/WT_H3K27ac_Repl2.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o Deeptools/mouseTSS.H3K27ac.tab.gz --skipZeros --binSize 10 --outFileSortedRegions Deeptools/H3K27acTSS_out.bed 

# plot
plotProfile -m Deeptools/mouseTSS.H3K27ac.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out Deeptools/profile_H3K27ac.pdf --averageType mean --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" 


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/mouseTSS.H3K27ac.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "KO" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out Deeptools/Heatmap.mouseTSS.H3K27ac.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

############################################################################################

########################################################################################
#H3K9ac
##########################################################################################
computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bw UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl1.bw UCSCbrowsertracks/WT_H3K9ac_Repl2.bw UCSCbrowsertracks/WT_H3K9ac_Repl3.bw UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl1.bw UCSCbrowsertracks/WT_Input_Repl2.bw UCSCbrowsertracks/WT_Input_Repl3.bw UCSCbrowsertracks/WT_Input_Repl4.bw UCSCbrowsertracks/WT_Input_Repl5.bw -p 20 -o Deeptools/mouseTSS.H3K9ac.tab.gz --skipZeros --binSize 10 --outFileSortedRegions Deeptools/H3K9acTSS_out.bed 

# plot
plotProfile -m Deeptools/mouseTSS.H3K9ac.tab.gz  --numPlotsPerRow 2 --regionsLabel "Mouse RefSeq Genes" --plotFileFormat "pdf" -out Deeptools/profile_H3K9ac.pdf --averageType mean --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" 


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/mouseTSS.H3K9ac.tab.gz --regionsLabel "Mouse Refeq Genes" --plotFileFormat "pdf" --samplesLabel "KO" "KO" "WT" "WT" "WT" "KOInput" "KOInput" "WTInput" "WTInput" "WTInput" "WTInput" "WTInput" -out Deeptools/Heatmap.mouseTSS.H3K9ac.pdf --averageType mean --perGroup --colorMap RdBu --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

############################################################################################
