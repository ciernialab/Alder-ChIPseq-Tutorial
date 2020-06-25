#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=Pos2Bed
#SBATCH --output=Pos2Bed.out
#SBATCH --time=4:00:00

##########################################################################################
#Convert HOMER peak files to bed format for UCSC genome browser
########################################################################################
#H3K27ac Wendlen
#######################################################################################
#HDAC1/2KO:
grep -v '^#' homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.bed
   
    rm homer_regions/tmp*

#WT
   
    grep -v '^#' homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt > homer_regions/tmp.txt
    
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
    
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksWendlen_H3K27ac_WT.bed
    
    rm homer_regions/tmp*
    
########################################################################################
#H3K27ac Gosselin
#######################################################################################
#HDAC1/2KO:
grep -v '^#' homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.bed
   
    rm homer_regions/tmp*

#WT
  
    grep -v '^#' homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt > homer_regions/tmp.txt
    
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
    
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksGosselin_H3K27ac_WT.bed
    
    rm homer_regions/tmp*
    

########################################################################################
#H3K9ac Wendlen
#######################################################################################
#HDAC1/2KO:
grep -v '^#' homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.bed
   
    rm homer_regions/tmp*

#WT
  
    grep -v '^#' homer_regions/HomerpeaksWendlen_H3K9ac_WT.txt > homer_regions/tmp.txt
    
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
    
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksWendlen_H3K9ac_WT.bed
    
    rm homer_regions/tmp*
    
########################################################################################
#H3K9ac Gosselin
#######################################################################################
#HDAC1/2KO:
grep -v '^#' homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.bed
   
    rm homer_regions/tmp*

#WT
  
    grep -v '^#' homer_regions/HomerpeaksWendlen_H3K9ac_WT.txt > homer_regions/tmp.txt
    
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
    
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksGosselin_H3K9ac_WT.bed
    
    rm homer_regions/tmp*
    

