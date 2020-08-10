#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Pos2Bed_DEpeaks
#SBATCH --output=Pos2Bed_DEpeaks.out
#SBATCH --time=4:00:00

##########################################################################################
#EXPLANATION ON AWK, IF INTERESTED
########################################################################################

# awk is a unix tool for text processing. It parses files (like most unix tools) on a per line basis,
# which can makes it very useful.
# We can use the following command (which prints the number of columns/fields for each row/line, and only prints
# out the unique values so we don't get the output for all rows):

# awk '{print NF}' Wendlen.H3K27ac_diffpeaksOutput.txt | uniq

# to see that there are 2 unique column values. The header has 147 columns, and the rest of the file has 19.
# Since the field we want to filter by (the adjusted p-values) is the last column,
# this means the field we want to filter by is actually the 19th column

# Now, the NF variable (which means Number of Fields) can also be used to denote the last field.

# So there's a few ways we can sort. One way is to use NF:
# awk '{if($NF<0.05) {print}}'  ---> this runs a conditional based on the last field FOR EACH row, so the
# filtering will still work, since the field we want to filter (adjusted p values) is the last one

# we could also do awk '{if($19<=0.05) {print}}', which runs a conditional based on the 19th column.
# I chose this since it's more explicit. So the code is:

# awk '{if($19<=0.05) {print}}' DEpeaks/Wendlen.H3K27ac_diffpeaksOutput.txt > DEpeaks/FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.txt

# this says, using awk, for each line, if the value in the 19th column is <= 0.05, print the line
# and output the results into a new file titled "FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.txt"

##########################################################################################
#sort txt files by adjusted p value, filter for <0.05, and output to new file
########################################################################################

#H3K27ac Wendlen
awk '{if($19<=0.05) {print}}' DEpeaks/Wendlen.H3K27ac_diffpeaksOutput.txt > DEpeaks/FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.txt

#H3K27ac Gosselin
awk '{if($19<=0.05) {print}}' DEpeaks/Gosselin.H3K27ac_diffpeaksOutput.txt > DEpeaks/FDRfiltered.Gosselin.H3K27ac_diffpeaksOutput.txt

#H3K9ac Wendlen
awk '{if($19<=0.05) {print}}' DEpeaks/Wendlen.H3K9ac_diffpeaksOutput.txt > DEpeaks/FDRfiltered.Wendlen.H3K9ac_diffpeaksOutput.txt

#H3K9ac Gosselin
awk '{if($19<=0.05) {print}}' DEpeaks/Gosselin.H3K9ac_diffpeaksOutput.txt > DEpeaks/FDRfiltered.Gosselin.H3K9ac_diffpeaksOutput.txt



##########################################################################################
#Convert HOMER peak files to bed format for UCSC genome browser
########################################################################################
#H3K27ac Wendlen
#######################################################################################

grep -v '^#' DEpeaks/FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.txt > DEpeaks/tmp.txt

    perl pos2bedmod.pl DEpeaks/tmp.txt > DEpeaks/tmp.bed

    sed 's/^/chr/' DEpeaks/tmp.bed > DEpeaks/FDRfiltered.Wendlen.H3K27ac_diffpeaksOutput.bed

    rm DEpeaks/tmp*



########################################################################################
#H3K27ac Gosselin
#######################################################################################

grep -v '^#' DEpeaks/FDRfiltered.Gosselin.H3K27ac_diffpeaksOutput.txt > DEpeaks/tmp.txt

    perl pos2bedmod.pl DEpeaks/tmp.txt > DEpeaks/tmp.bed

    sed 's/^/chr/' DEpeaks/tmp.bed > DEpeaks/FDRfiltered.Gosselin.H3K27ac_diffpeaksOutput.bed

    rm DEpeaks/tmp*




########################################################################################
#H3K9ac Wendlen
#######################################################################################

grep -v '^#' DEpeaks/FDRfiltered.Wendlen.H3K9ac_diffpeaksOutput.txt > DEpeaks/tmp.txt

    perl pos2bedmod.pl DEpeaks/tmp.txt > DEpeaks/tmp.bed

    sed 's/^/chr/' DEpeaks/tmp.bed > DEpeaks/FDRfiltered.Wendlen.H3K9ac_diffpeaksOutput.bed

    rm DEpeaks/tmp*


########################################################################################
#H3K9ac Gosselin
#######################################################################################

grep -v '^#' DEpeaks/FDRfiltered.Gosselin.H3K9ac_diffpeaksOutput.txt > DEpeaks/tmp.txt

    perl pos2bedmod.pl DEpeaks/tmp.txt > DEpeaks/tmp.bed

    sed 's/^/chr/' DEpeaks/tmp.bed > DEpeaks/FDRfiltered.Gosselin.H3K9ac_diffpeaksOutput.bed

    rm DEpeaks/tmp*
