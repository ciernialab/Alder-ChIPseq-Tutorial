# Alder-ChIPseq-Tutorial
Tutorial for processing ChIP-seq PE files

This tutorial is for downloading published PE ChIPSeq files from GEO and processing them for QC, aligning, peak calling and differential analysis. The tutorial is setup to run on the DMCBH Alder computing cluster using bash scripts. 

## 1. Getting Setup on Alder: Making a bash_profile
  - Go to your home directory: cd ~/
  - Open a text editor and make/edit your .bash_profile
    ```
     cd ~/
     nano .bash_profile
    ``` 
  -either replace or add lines as shown in the bash_profile.txt document
  -you must source your changes before they will take effect in the current terminal session
  -your bash profile will then load each time you start a new session
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
 This tutorial uses Bowtie2 to align the paired-end ChIPseq fastq files to the mouse genome Ensembl build for mm10
 Bowtie2 requires BT2 index files that can be retrieved from Illumina igenomes: https://support.illumina.com/sequencing/sequencing_software/igenome.html
 
 BT2 index files for mm10 are currently stored in /alder/data/cbh/ciernia-data/genomes/bowtie2indexes/
 They are ready to use and you DO NOT NEED TO RUN THE FOLLOWING CODE for mouse
 If you want to obtain index files for other species this is how the mouse indexes were setup:
 
  ``` 
    wget -c http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/Ensembl/GRCm38/Mus_musculus_Ensembl_GRCm38.tar.gz
 ```
 The following was then added to the bash_profile document in the home directory to tell bowtie2 where to look for the index files:
 
    export BT2_MM10=/alder/data/cbh/ciernia-data/genomes/bowtie2indexes/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index

## 4. Getting Setup on Alder: Installing HOMER
This has already been done for you. But in case it does not work this is how the install was done. From within /alder/data/cbh/ciernia-data/pipeline-tools/    Run the following:

    wget -c http://homer.ucsd.edu/homer/configureHomer.pl

    perl configureHomer.pl -install

Then add this to your bash_profile:
    
    PATH=$PATH:/alder/data/cbh/ciernia-data/pipeline-tools/.//bin/

Simply typing "findMotifs.pl" should work before running Homer

#Installing HOMER genomes

    perl configureHomer.pl -list
    
Mouse, Human and rat have been added:

    perl configureHomer.pl -install mm10
    perl configureHomer.pl -install hg18
    perl configureHomer.pl -install rn6

##Loading in mm10 promoter set
  mouse promoter set ready in homer suite is mm9, need to load in mm10 version yourself
  how to do it manually:

#use the mm10.tss file included above
#create custom promoter set for mm10 (can't use mm9)

    loadPromoters.pl -name mm10_promoters -org mouse -id refseq -genome mm10 -tss mm10.tss

## 5. Fetching Data from GEO
This tutorial analyzes a ChIPseq dataset from this paper: https://pubmed.ncbi.nlm.nih.gov/29548672/
The data is stored in NCBI GEO as SRR files which are highly compressed files that can be converted to fastq files using SRA Toolkit (configured above). 
 The GEO entry can be found here: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107436
 
To find a comprehensive list of the SRR files, we use the Run Selector. 
Navigate to the bottom of the page and click “send to” and select “Run Selector”, and then press “go”.
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA420076&o=acc_s%3Aa

Under the Select section click on the Metadata and List Accession to dowload the information on the experiment and the list of SRR files.




 
 
 
 
