# Alder-ChIPseq-Tutorial
Tutorial for processing ChIP-seq PE files

This tutorial is for downloading published PE ChIPSeq files from GEO and processing them for QC, aligning, peak calling and differential analysis.  The tutorial is setup to run on the DMCBH Alder computing cluster using bash scripts. 

## 1. Getting Setup on Alder: Making a bash_profile
  - Go to your home directory: cd ~/
  - Open a text editor and make/edit your .bash_profile
    ```
     cd ~/
     nano .bash_profile
    ``` 
  -either replace or add lines as shown in the bash_profile.txt document  <br/>
  -you must source your changes before they will take effect in the current terminal session  <br/>
  -your bash profile will then load each time you start a new session<br/>
  ``` 
    source ~/.bash_profile
  ``` 
  -check your path variable with:
   ``` 
    echo $PATH
  ``` 
 ## 2. Getting Setup on Alder: Configuring SRA Toolkit
  When run for first time:
   ``` 
    prefetch
  ``` 
  
  You may get the following message:
  
  ``` 
    This sra toolkit installation has not been configured.
    Before continuing, please run: vdb-config --interactive
    For more information, see https://www.ncbi.nlm.nih.gov/sra/docs/sra-cloud/
  ``` 
  Run:
 
 ``` 
    vdb-config —interactive
 ``` 
  
  This should open a dialogue box. Don’t change anything and hit "X" to exit
 
  ``` 
    prefetch
 ``` 
  
Should now return
 
 ``` 
  Usage:
  prefetch [options] <SRA accession> [...]
 ```
 ## 3. Getting Setup on Alder: Getting Genome Indexes
 This tutorial uses Bowtie2 to align the paired-end ChIPseq fastq files to the mouse genome Ensembl build for mm10 <br/> Bowtie2 requires BT2 index files that can be retrieved from Illumina igenomes: https://support.illumina.com/sequencing/sequencing_software/igenome.html
 
 BT2 index files for mm10 are currently stored in /alder/data/cbh/ciernia-data/genomes/bowtie2indexes/<br/>
 They are ready to use and you DO NOT NEED TO RUN THE FOLLOWING CODE for mouse<br/>
 If you want to obtain index files for other species this is how the mouse indexes were setup:
 
  ``` 
    wget -c http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/Ensembl/GRCm38/Mus_musculus_Ensembl_GRCm38.tar.gz
 ```
 The following was then added to the bash_profile document in the home directory to tell bowtie2 where to look for the index files:
 
    export BT2_MM10=/alder/data/cbh/ciernia-data/genomes/bowtie2indexes/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index

## 4. Getting Setup on Alder: Installing HOMER
This has already been done for you. But in case it does not work this is how the install was done. <br/>
From within /alder/data/cbh/ciernia-data/pipeline-tools/    <br/>
Run the following:

    wget -c http://homer.ucsd.edu/homer/configureHomer.pl

    perl configureHomer.pl -install

Then add this to your bash_profile:
    
    PATH=$PATH:/alder/data/cbh/ciernia-data/pipeline-tools/.//bin/

Simply typing "findMotifs.pl" should work before running Homer

### Installing HOMER genomes

    perl configureHomer.pl -list
    
Mouse, Human and rat have been added:

    perl configureHomer.pl -install mm10
    perl configureHomer.pl -install hg18
    perl configureHomer.pl -install rn6

### Loading in mm10 promoter set
  mouse promoter set ready in homer suite is mm9, need to load in mm10 version yourself
  how to do it manually:

### use the mm10.tss file included above
  create custom promoter set for mm10 (can't use mm9)

    loadPromoters.pl -name mm10_promoters -org mouse -id refseq -genome mm10 -tss mm10.tss

## 5. Fetching Data from GEO
This tutorial analyzes a ChIPseq dataset from this paper: https://pubmed.ncbi.nlm.nih.gov/29548672/<br/>
The data is stored in NCBI GEO as SRR files which are highly compressed files that can be converted to fastq files using SRA Toolkit (configured above). <br/>
 The GEO entry can be found here: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107436<br/>
 
To find a comprehensive list of the SRR files, we use the Run Selector. <br/>
Navigate to the bottom of the page and click “send to” and select “Run Selector”, and then press “go”.<br/>
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA420076&o=acc_s%3Aa<br/>

Under the Select section click on the Metadata and List Accession to dowload the information on the experiment and the list of SRR files.<br/>
See screen shot image. <br/>
Use the SRR_Acc_List.txt as the samples list for the SRRpull.sh script

### make a directory for your experiment:

    mkdir HDAC1_2_ChIPseq
    
Make a copy of the SRR_Acc_List.txt file in your new directory, using the text editor. Paste in the SRR list to the SRR_Acc_List.txt using nano.
 
    cd HDAC1_2_ChIPseq
    nano SRR_Acc_List.txt
    
### run the SRRpull.sh script
The script is setup to be run from your experiment folder inside your home directory. <br/>
It makes a file in the ciernialab shared data folder on Alder: /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/<br/>
It then uses a loop to pull each SRR file in SRR_Acc_List.txt using prefetch <br/>
Because the files are PE we then need to add --split to the fastq-dump command to get the R1 and R2 fastq for each SRR entry<br/>
copy or make using nano the SRRpull.sh script. It should be inside your experiment folder.<br/>
Run the script as an sbatch submission to Alder:

    sbatch SRRpull.sh
    
Check that the script is running by checkin squeue
  
    squeue

It should say that the job SRAfetch is running
If you check the contents of the experiment folder, SRAfetch.out should have also been generated. Look inside this file (even while it is still running) to check the progress of the script. The sript prints when a samples starts, progress, and ends. SRAfetch.out also serves as a log to check for errors, etc. This is one of the main advantages of sbatch - the log!

    less SRAfetch.out
    
## 5. QC of the Fastq Files
We need to check the quality of the fastq files both before and after trimming. We use FastQC from https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Look at their tutorials to interpret the output files

The pretrim_fastqc.sh script makes an output file and a subfolder for pretrim .html files (one for each fastq file). We have to check both the foreward (R1) and reverse (R2) reads.

The script loops through each fastq and generates a quality resport for each fastq in the /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/ folder. 

It then combines the reports into one easy to read output using multiqc: PretrimFastQC_multiqc_report.html
PreTrimFastqc.out output log is also generated.

    sbatch pretrim_fastqc.sh
    
Check the PretrimFastQC_multiqc_report.html to help inform your trimming

## 6. Trimming fastq files
We need to remove adapters and poor quality reads before aligning.<br/>
Trimmomatic will look for seed matches of 16 bases with 2 mismatches allowed and will then extend and clip if a score of 30 for PE or 10 for SE is reached (~17 base match)<br/>
The minimum adapter length is 8 bases<br/>
T = keeps both reads even if only one passes criteria<br/>
Trims low quality bases at leading and trailing end if quality score < 15<br/>
Sliding window: scans in a 4 base window, cuts when the average quality drops below 15<br/>
Log outputs number of input reads, trimmed, and surviving reads in trim_log_samplename<br/>

It uses the file TruSeq3-PE.fa (comes with Trimmomatic download). <br/>
The program needs to know where this is stored. We set the path to thies file in the bash_profile with $ADAPTERS <br/>
To check the contents of the file:

    less $ADAPTERS/TruSeq3-PE.fa

Run the script

    sbatch Trim.sh
    
## 7. Repeat QC on post trim files
Repeat the QC on the post trim files and compare the output to the pretrim.

    sbatch posttrim_fastqc.sh

## 8. QC of the Fastq Files: Contamination Screening - Add Fastqscreen info here



## 9. Align to mm10 genome using Bowtie2
We now will align the trimmed fastq files to the mm10 genome using bowtie2. Bowtie2 needs to know where the index files are located. We specified this in our bash_profile. Check the location:

    ls $BT2_MM10
    
Run the script to align. This takes significant time and memory. Output logs are placed in output/bowtielogs <br/>


    sbatch Bowtie2alignment.sh

Check the multiqc output to look at alignment rates: bowtie2_multiqc_report.html

## 10. Filter aligned files
We need to convert sam files to bam and filter to remove PCR duplicates, remove unmapped reads and secondary alignments (multi-mappers), and remove unpaired reads <br/>
We use samtools to convert sam to bam and then samtools fixmate to remove unmapped reads and 2ndary alignments.<br/>
We then remove PCR duplicates using -F 0x400 and -f 0x2 to keep only propperly paired reads<br/>
We then indext the reads and collect additional QC metrics using picard tools and samtools flagstat <br/>
QC meterics are then collected into one report using multiqc.

Run the script:

    sbatch SamtoolsFiltering.sh
    
Check the multiqc: sam_multiqc_report.html


## 11. QC with Deeptools - add here

## 12. Peak Calling with HOMER
up until this point the pipeline is relatively standard for all PE ChIPseq experiments. The choice of peak callers and settings depends on what type of ChIP experiment you are performing (ie. histone marks vs. transcription factors). This dataset was for H3K27ac and H3K9ac, both classic histone acetylation marks that are analyzed nicely with HOMER using -style histone and some custom settings based on knowledge of how these two marks behave. If you are working with other ChIP datasets where the marks are either more or less peak like you need to make adjustments to the HOMER calls. See http://homer.ucsd.edu/homer/ngs/peaks.html for details.

###Make Tag Directories
The first step to running HOMER is to make Tag Directories: http://homer.ucsd.edu/homer/ngs/tagDir.html
We will make a folder Tag_Directories and then make tags for each sample WT and KO sample individually and all the input samples together. This is approach is specifically based for this experiment in which we have only 2-3 biological replicates per condition and input samples are not matched to individual samples. 

For the H3K27ac mark we have the following:  <br/>
HDAC1/2KO MG: <br/>
SRR6326785 <br/>
SRR6326800 <br/>
SRR6326801 <br/>

wT MG: <br/>
SRR6326796 <br/>
SRR6326798 <br/>

For the H3K9ac mark we have the following: <br/>
HDAC1/2KO MG: <br/>
SRR6326786 <br/>
SRR6326788  <br/>

WT MG: <br/>
SRR6326790 <br/>
SRR6326792 <br/> 
SRR6326794 <br/>

#For input samples: <br/>
KO MG: <br/>
SRR6326787 <br/>
SRR6326789 <br/>

WT MG: <br/>
SRR6326791 <br/>
SRR6326793 <br/>
#RR6326795 <br/>
SRR6326797 <br/>
SRR6326799 <br/>

There are several different approaches to analyze this data using HOMER. I have summarized the main points below but you should read the full HOMER ChIPseq documentation before running your own experiment. <br/>

From the HOMER website:http://homer.ucsd.edu/homer/ngs/peaksReplicates.html<br/>
There are two general (but related) approaches to identifying differential peaks. The first is to use the getDifferentialPeaksReplicates.pl command, which attempts to automate the steps described below into a single command to generate a peak file. The second is to prepare your own regions and read counts and then use getDiffExpression.pl directly to calculate the differential enrichment. <br/>

HOMER requires R/Bioconductor to be installed with packages for DESeq2 installed. <br/>
Each user must to this install by running the following code from in their home directory (cd ~/):

    module load R/3.6.1
    R
    
This will start the R program environment. In R, install DESeq2 using bioconductor: https://bioconductor.org/packages/release/bioc/html/DESeq2.html

    BiocManager::install("DESeq2")
    
This will install DESeq2 and all the dependencies. If asked to update any packages put "y". After the installation complete, exit. using "quite". You do not need to save the workspace ("n").  <br/>

## Approach #1: getDifferentialPeaksReplicates.pl
When identifying differential peaks between separate experiments, the program offers a way to include both the "background" ChIP-seq experiments as well as the input experiment by specifying them with either "-b" or "-i". The key difference between "-i" and "-b" directories is that the input directories ("-i") are used during the initial peak finding as controls to limit the feature detection and during the differential calculations with DESeq2, while the "-b" directories are used only during the differential calculations with DESeq2.  If both are specified (both -b and -i), the input directories are used during feature selection and the background directories are used during the differential calculation.  In general, if you have input experiments, you should use them with "-i". <br/>
For example, for our experiment if you wanted to directly compare HDAC1/2KO and WT microglia for H3K27ac using all the input controls the command would look like this:

    module load samtools/1.4
    module load jre/1.8.0_121
    module load R/3.6.1

    getDifferentialPeaksReplicates.pl -t TagDirectory/tag_SRR6326785 TagDirectory/tag_SRR6326800 TagDirectory/tag_SRR6326801 -b     TagDirectory/tag_SRR6326796 TagDirectory/tag_SRR6326798 -i TagDirectory/tag_SRR6326787 TagDirectory/tag_SRR6326789 TagDirectory/tag_SRR6326791 TagDirectory/tag_SRR6326793 TagDirectory/tag_SRR6326795 TagDirectory/tag_SRR6326797 TagDirectory/tag_SRR6326799 -genome mm10 -style histone -size 250 -minDist 500 -balanced > Repl.outputPeaks.txt


-style histone -size 250 -minDist 500: <br/>
"-size" specifies the width of peaks that will form the basic building blocks for extending peaks into regions.  Smaller peak sizes offer better resolution, but  larger peak sizes are usually more sensitive.  By default, "-style histone" evokes a peak size of 500. "-minDist", is usually used to specify the minimum distance between adjacent peaks. <br/>

You can also set -style to "factor" for transcription factors with small binding regions or "region" for broad histone marks. See http://homer.ucsd.edu/homer/ngs/peaks.html. Choosing the right style and settings often is trial and error and requires trying out several settings, looking at the data on the UCSC genome browser to see if the peaks match where you can see obvious peaks in the data and fine tuning the settings. <br/>

-balanced : Do not force the use of normalization factors to match total mapped reads.  This can be useful when analyzing differential peaks between similar data (for example H3K27ac) where we expect similar levels in all experiments. Applying this allows the data to essentially be quantile normalized during the differential calculation.<br/>


## Approach #2: Multi-Step with getDiffExpression.pl


 
