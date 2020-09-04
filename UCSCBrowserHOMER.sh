#!/bin/bash
#
#SBATCH -c 12
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=UCSC
#SBATCH --output=HOMERUCSC.out
#SBATCH --time=12:00:00

#######################################################################################
#makeUCSCfile <tag directory-res 10 > -fragLength given -res 10 > UCSCbrowsertracks/
#10bp resolution
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir UCSCbrowsertracks/
echo "making bedGraphs"
#######################################################################################
# H3K27ac
#######################################################################################

#make normalized bedgraphs:
#H3K27ac
#HDAC1/2KO MG:
#TagDirectory/tag_SRR6326785
#TagDirectory/tag_SRR6326800
#TagDirectory/tag_SRR6326801

makeUCSCfile TagDirectory/tag_SRR6326785 -fragLength given -name HDAC12KO_H3K27ac_Repl1 -res 10 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326800 -fragLength given -name HDAC12KO_H3K27ac_Repl2 -res 10 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326801 -fragLength given -name HDAC12KO_H3K27ac_Repl3 -res 10 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph


#KO input
#SRR6326787	input
#SRR6326789	input
makeUCSCfile TagDirectory/tag_SRR6326787 -fragLength given -name HDAC12KO_Input_Repl1 -res 10 > UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326789 -fragLength given -name HDAC12KO_Input_Repl2 -res 10 > UCSCbrowsertracks/HDAC12KO_Input_Repl2.bedGraph

#######################################################################################
#wT MG:
#SRR6326796	H3K27ac
#SRR6326798	H3K27ac

makeUCSCfile TagDirectory/tag_SRR6326796 -fragLength given -name WT_H3K27ac_Repl1 -res 10 > UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326798 -fragLength given -name WT_H3K27ac_Repl2 -res 10 > UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph

#WT input
#SRR6326791	input	wildtype
#SRR6326793	input	wildtype
#SRR6326795	input	wildtype
#SRR6326797	input	wildtype
#SRR6326799	input	wildtype

makeUCSCfile TagDirectory/tag_SRR6326791 -fragLength given -name WT_Input_Repl1 -res 10 > UCSCbrowsertracks/WT_Input_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326793 -fragLength given -name WT_Input_Repl2 -res 10 > UCSCbrowsertracks/WT_Input_Repl2.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326795 -fragLength given -name WT_Input_Repl3 -res 10 > UCSCbrowsertracks/WT_Input_Repl3.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326797 -fragLength given -name WT_Input_Repl4 -res 10 > UCSCbrowsertracks/WT_Input_Repl4.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326799 -fragLength given -name WT_Input_Repl5 -res 10 > UCSCbrowsertracks/WT_Input_Repl5.bedGraph

####################################################################################
#H3K9ac
#######################################################################################
#KO:
#SRR6326786	H3K9ac	HDAC1&2 microglial deletion
#SRR6326788	H3K9ac	HDAC1&2 microglial deletion
makeUCSCfile TagDirectory/tag_SRR6326786 -fragLength given -name HDAC12KO_H3K9ac_Repl1 -res 10 > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326788 -fragLength given -name HDAC12KO_H3K9ac_Repl2 -res 10 > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph

#######################################################################################

#WT
#SRR6326790	H3K9ac	wildtype
#SRR6326792	H3K9ac	wildtype
#SRR6326794	H3K9ac	wildtype

makeUCSCfile TagDirectory/tag_SRR6326790 -fragLength given -name WT_H3K9ac_Repl1 -res 10 > UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326792 -fragLength given -name WT_H3K9ac_Repl2 -res 10 > UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph

makeUCSCfile TagDirectory/tag_SRR6326794 -fragLength given -name WT_H3K9ac_Repl3 -res 10 > UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph

##########################################################################################
#######################################################################################
#make into ucsc format
#sed -i 's/old-text/new-text/g' input.txt
echo "converting to UCSC format"
#######################################################################################
#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_Input_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_Input_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_Input_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_Input_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_Input_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_Input_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_Input_Repl3.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_Input_Repl3.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_Input_Repl4.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_Input_Repl4.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_Input_Repl5.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_Input_Repl5.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph

#######################################################################################
#######################################################################################
#convert to bigwigs
echo "making bigwigs"
#######################################################################################
#convert to bigwig
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bw

 #repl3
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bw

#WT repl1
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph > UCSCbrowsertracks/WT_H3K27ac_Repl1.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_H3K27ac_Repl1.sort.bedGraph

bedClip UCSCbrowsertracks/WT_H3K27ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl1.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_H3K27ac_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph > UCSCbrowsertracks/WT_H3K27ac_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_H3K27ac_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/WT_H3K27ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl2.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_H3K27ac_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K27ac_Repl2.bw

#input KO repl1
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_Input_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_Input_Repl2.bedGraph > UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_Input_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_Input_Repl2.bw


#input WT repl1
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl1.bedGraph > UCSCbrowsertracks/WT_Input_Repl1.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_Input_Repl1.sort.bedGraph

bedClip UCSCbrowsertracks/WT_Input_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl1.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl2.bedGraph > UCSCbrowsertracks/WT_Input_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_Input_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/WT_Input_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl12.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl12.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl2.bw

#repl3
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl3.bedGraph > UCSCbrowsertracks/WT_Input_Repl3.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_Input_Repl3.sort.bedGraph

bedClip UCSCbrowsertracks/WT_Input_Repl3.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl13.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl13.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl3.bw

#repl4
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl4.bedGraph > UCSCbrowsertracks/WT_Input_Repl4.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_Input_Repl4.sort.bedGraph

bedClip UCSCbrowsertracks/WT_Input_Repl4.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl14.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl14.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl4.bw

#repl5
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_Input_Repl5.bedGraph > UCSCbrowsertracks/WT_Input_Repl5.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_Input_Repl5.sort.bedGraph

bedClip UCSCbrowsertracks/WT_Input_Repl5.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl15.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_Input_Repl15.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_Input_Repl5.bw

#H3K9ac
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bw

#WT H3K9ac Repl 1
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl1.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl1.sort.bedGraph

bedClip UCSCbrowsertracks/WT_H3K9ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl1.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl1.bw

#repl2
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl2.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl2.sort.bedGraph

bedClip UCSCbrowsertracks/WT_H3K9ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl2.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl2.bw

#repl3
sort -k1,1 -k2,2n UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph > UCSCbrowsertracks/WT_H3K9ac_Repl3.sort.bedGraph

sed -i '$d' UCSCbrowsertracks/WT_H3K9ac_Repl3.sort.bedGraph

bedClip UCSCbrowsertracks/WT_H3K9ac_Repl3.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl3.sort2.bedGraph

bedGraphToBigWig UCSCbrowsertracks/WT_H3K9ac_Repl3.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/WT_H3K9ac_Repl3.bw

#zip bedgraphs
gzip UCSCbrowsertracks/*.bedGraph

echo "complete"
