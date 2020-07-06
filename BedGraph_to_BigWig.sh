#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=BigWig
#SBATCH --output=BigWig.out
#SBATCH --time=2:00:00

#######################################################################################
#convert to bigwigs
#######################################################################################
#convert to bigwig
#The input bedGraph file must be sorted, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sorted.bedGraph

#remove track line (now at the end of sorted files)
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sorted.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sorted.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sorted.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sorted.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw
 
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sorted.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sorted.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw

#WT
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph > UCSCbrowsertracks/WT_H3K27ac_Repl1.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_H3K27ac_Repl1.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_H3K27ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph > UCSCbrowsertracks/WT_H3K27ac_Repl2.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_H3K27ac_Repl2.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_H3K27ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl2.bw

#input KO
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_Input_Rep2.bedGraph > UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw


#input WT
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl1.bedGraph > UCSCbrowsertracks/WT_Input_Repl1.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_Input_Repl1.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl2.bedGraph > UCSCbrowsertracks/WT_Input_Repl2.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_Input_Repl2.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl2.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl3.bedGraph > UCSCbrowsertracks/WT_Input_Repl3.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_Input_Repl3.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl3.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl3.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl4.bedGraph > UCSCbrowsertracks/WT_Input_Repl4.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_Input_Repl4.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl4.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl4.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl5.bedGraph > UCSCbrowsertracks/WT_Input_Repl5.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_Input_Repl5.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl5.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl5.bw

#H3K9ac
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl1.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl1.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl1.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl2.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl2.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl2.bw

sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl3.sort.bedGraph
sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl3.sorted.bedGraph
bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl3.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl3.bw
