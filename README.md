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




 
