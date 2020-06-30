#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=USCSC
#SBATCH --output=HOMERUSCC.out
#SBATCH --time=5:00:00

#######################################################################################
#makeUCSCfile <tag directory> -fragLength given > UCSCbrowsertracks/
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir UCSCbrowsertracks/
#######################################################################################
# H3K27ac
#######################################################################################

#make normalized bedgraphs:
#H3K27ac
#HDAC1/2KO MG:
#TagDirectory/tag_SRR6326785
#TagDirectory/tag_SRR6326800
#TagDirectory/tag_SRR6326801

makeUCSCfile TagDirectory/tag_SRR6326785 -fragLength given -name HDAC12KO_H3K27ac_Repl1 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl1.bedGraph



makeUCSCfile TagDirectory/tag_SRR6326800 -fragLength given -name HDAC12KO_H3K27ac_Repl2 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl2.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326801 -fragLength given -name HDAC12KO_H3K27ac_Repl3 > UCSCbrowsertracks/HDAC12KO_H3K27ac_Repl3.bedGraph



#KO input
#SRR6326787	input
#SRR6326789	input
makeUCSCfile TagDirectory/tag_SRR6326787 -fragLength given -name HDAC12KO_Input_Repl1 > UCSCbrowsertracks/HDAC12KO_Input_Repl1.bedGraph 



makeUCSCfile TagDirectory/tag_SRR6326789 -fragLength given -name HDAC12KO_Input_Repl2 > UCSCbrowsertracks/HDAC12KO_Input_Repl2.bedGraph


#######################################################################################
#wT MG:
#SRR6326796	H3K27ac
#SRR6326798	H3K27ac

makeUCSCfile TagDirectory/tag_SRR6326796 -fragLength given -name WT_H3K27ac_Repl1 > UCSCbrowsertracks/WT_H3K27ac_Repl1.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326798 -fragLength given -name WT_H3K27ac_Repl2 > UCSCbrowsertracks/WT_H3K27ac_Repl2.bedGraph



#WT input
#SRR6326791	input	wildtype
#SRR6326793	input	wildtype
#SRR6326795	input	wildtype
#SRR6326797	input	wildtype
#SRR6326799	input	wildtype

makeUCSCfile TagDirectory/tag_SRR6326791 -fragLength given -name WT_Input_Repl1 > UCSCbrowsertracks/WT_Input_Repl1.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326793 -fragLength given -name WT_Input_Repl2 > UCSCbrowsertracks/WT_Input_Repl2.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326795 -fragLength given -name WT_Input_Repl3 > UCSCbrowsertracks/WT_Input_Repl3.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326797 -fragLength given -name WT_Input_Repl4 > UCSCbrowsertracks/WT_Input_Repl4.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326799 -fragLength given -name WT_Input_Repl5 > UCSCbrowsertracks/WT_Input_Repl5.bedGraph


####################################################################################
#H3K9ac
#######################################################################################
#KO:
#SRR6326786	H3K9ac	HDAC1&2 microglial deletion
#SRR6326788	H3K9ac	HDAC1&2 microglial deletion
makeUCSCfile TagDirectory/tag_SRR6326786 -fragLength given -name HDAC12KO_H3K9ac_Repl1 > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl1.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326788 -fragLength given -name HDAC12KO_H3K9ac_Repl2 > UCSCbrowsertracks/HDAC12KO_H3K9ac_Repl2.bedGraph


#######################################################################################

#WT
#SRR6326790	H3K9ac	wildtype
#SRR6326792	H3K9ac	wildtype
#SRR6326794	H3K9ac	wildtype

makeUCSCfile TagDirectory/tag_SRR6326790 -fragLength given -name WT_H3K9ac_Repl1 > UCSCbrowsertracks/WT_H3K9ac_Repl1.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326792 -fragLength given -name WT_H3K9ac_Repl2 > UCSCbrowsertracks/WT_H3K9ac_Repl2.bedGraph


makeUCSCfile TagDirectory/tag_SRR6326794 -fragLength given -name WT_H3K9ac_Repl3 > UCSCbrowsertracks/WT_H3K9ac_Repl3.bedGraph


##########################################################################################


