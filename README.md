
# Alder-ChIPseq-Tutorial

Tutorial for processing ChIP-seq PE files

This tutorial is for downloading published PE ChIPSeq files from GEO and processing them for QC, aligning, peak calling and differential analysis.  The tutorial is setup to run on the DMCBH Alder computing cluster using bash scripts.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Alder-ChIPseq-Tutorial](#alder-chipseq-tutorial)
- [1. Getting Setup on Alder: Making a bash_profile](#1-getting-setup-on-alder-making-a-bashprofile)
- [2. Getting Setup on Alder: Configuring SRA Toolkit](#2-getting-setup-on-alder-configuring-sra-toolkit)
- [3. Getting Setup on Alder: Getting Genome Indexes](#3-getting-setup-on-alder-getting-genome-indexes)
- [4. Getting Setup on Alder: Installing Python Programs & HOMER](#4-getting-setup-on-alder-installing-python-programs-homer)
	- [Multiqc and Deeptools Install](#multiqc-and-deeptools-install)
	- [HOMER Install](#homer-install)
	- [Installing HOMER genomes](#installing-homer-genomes)
	- [Loading in mm10 promoter set](#loading-in-mm10-promoter-set)
- [5. Fetching Data from GEO](#5-fetching-data-from-geo)
	- [make a directory for your experiment:](#make-a-directory-for-your-experiment)
	- [run the SRRpull.sh script](#run-the-srrpullsh-script)
- [6. QC of the Fastq Files](#6-qc-of-the-fastq-files)
- [7. Trimming fastq files](#7-trimming-fastq-files)
- [8. Repeat QC on post trim files](#8-repeat-qc-on-post-trim-files)
- [9. QC of the Fastq Files: Contamination Screening](#9-qc-of-the-fastq-files-contamination-screening)
	- [setup of the Fastq_screen indexes (bowtie2)](#setup-of-the-fastqscreen-indexes-bowtie2)
- [10. Align to mm10 genome using Bowtie2](#10-align-to-mm10-genome-using-bowtie2)
- [11. Filter aligned files](#11-filter-aligned-files)
- [12. QC with Deeptools:](#12-qc-with-deeptools)
	- [1. Correlation between BAM files using multiBamSummary and plotCorrelation](#1-correlation-between-bam-files-using-multibamsummary-and-plotcorrelation)
	- [2. Coverage check (plotCoverage).](#2-coverage-check-plotcoverage)
	- [3. Check Fragment Sizes (bamPEFragmentSize)](#3-check-fragment-sizes-bampefragmentsize)
	- [4. GC-bias check (computeGCBias) - ADD later if needed](#4-gc-bias-check-computegcbias-add-later-if-needed)
	- [5. Assessing the ChIP strength.](#5-assessing-the-chip-strength)
	- [6. Convert to Read Depth Normalized BigWigs](#6-convert-to-read-depth-normalized-bigwigs)
	- [7. TSS Heatmap Plots](#7-tss-heatmap-plots)
- [13. Peak Calling with HOMER](#13-peak-calling-with-homer)
	- [Make Tag Directories](#make-tag-directories)
	- [Call Peaks and Find Differential Peaks Between Conditions](#call-peaks-and-find-differential-peaks-between-conditions)
		- [Approach #1: getDifferentialPeaksReplicates.pl](#approach-1-getdifferentialpeaksreplicatespl)
		- [Approach #2: Multi-Step with getDiffExpression.pl](#approach-2-multi-step-with-getdiffexpressionpl)
			- [Step 1:](#step-1)
			- [Step 2:](#step-2)
				- [using parameters from Wendeln:](#using-parameters-from-wendeln)
				- [using parameters from Gosselin:](#using-parameters-from-gosselin)
			- [Step 3:](#step-3)
			- [Step 4. UCSC Genome Browser Tracks (HOMER)](#step-4-ucsc-genome-browser-tracks-homer)
			- [Step 4B. UCSC Genome Browser My Hub](#step-4b-ucsc-genome-browser-my-hub)
			- [Step 5: Look at overlapping peaks with Upset plots](#step-5-look-at-overlapping-peaks-with-upset-plots)
			- [Step 6: Identifiy differential peaks statistically](#step-6-identifiy-differential-peaks-statistically)
				- [Considerations:](#considerations)
					- [Variance Stabilization/Normalized Read counts in output file:](#variance-stabilizationnormalized-read-counts-in-output-file)
					- [Normalization to Tag directory or gene totals](#normalization-to-tag-directory-or-gene-totals)
			- [Step 7: look at DE peaks on UCSC genome browser and see if they are reasonable](#step-7-look-at-de-peaks-on-ucsc-genome-browser-and-see-if-they-are-reasonable)
			- [Step 8: Make Deeplots heatmap and profile over DE peaks](#step-8-make-deeplots-heatmap-and-profile-over-de-peaks)

<!-- /TOC -->

# 1. Getting Setup on Alder: Making a bash_profile
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
# 2. Getting Setup on Alder: Configuring SRA Toolkit
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
    vdb-config --interactive
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
# 3. Getting Setup on Alder: Getting Genome Indexes
 This tutorial uses Bowtie2 to align the paired-end ChIPseq fastq files to the mouse genome Ensembl build for mm10 <br/> Bowtie2 requires BT2 index files that can be retrieved from Illumina igenomes: https://support.illumina.com/sequencing/sequencing_software/igenome.html

 BT2 index files for mm10 are currently stored in /alder/data/cbh/ciernia-data/genomes/bowtie2indexes/<br/>
 They are ready to use and you DO NOT NEED TO RUN THE FOLLOWING CODE for mouse<br/>
 If you want to obtain index files for other species this is how the mouse indexes were setup:

  ```
    wget -c http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/Ensembl/GRCm38/Mus_musculus_Ensembl_GRCm38.tar.gz
 ```
 The following was then added to the bash_profile document in the home directory to tell bowtie2 where to look for the index files:

    export BT2_MM10=/alder/data/cbh/ciernia-data/genomes/bowtie2indexes/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index

# 4. Getting Setup on Alder: Installing Python Programs & HOMER

## Multiqc and Deeptools Install
We will use Multiqc and Deeptools for analysis and plotting. From their home directory, each user must install them using pip:

    module load python/3.7.4
    pip3.7 install --user multiqc
    pip3.7 install --user deeptools

## HOMER Install
This has already been done for you. But in case it does not work this is how the install was done. <br/>
From within /alder/data/cbh/ciernia-data/pipeline-tools/    <br/>
Run the following:

    wget -c http://homer.ucsd.edu/homer/configureHomer.pl

    perl configureHomer.pl -install

Then add this to your bash_profile:

    PATH=$PATH:/alder/data/cbh/ciernia-data/pipeline-tools/.//bin/

Simply typing "findMotifs.pl" should work before running Homer

## Installing HOMER genomes

    perl configureHomer.pl -list

Mouse, Human and rat have been added:

    perl configureHomer.pl -install mm10
    perl configureHomer.pl -install hg18
    perl configureHomer.pl -install rn6

## Loading in mm10 promoter set
  mouse promoter set ready in homer suite is mm9, need to load in mm10 version yourself
  how to do it manually using the mm10.tss file included to create custom promoter set for mm10:

    loadPromoters.pl -name mm10_promoters -org mouse -id refseq -genome mm10 -tss mm10.tss

# 5. Fetching Data from GEO
This tutorial analyzes a ChIPseq dataset from this paper: https://pubmed.ncbi.nlm.nih.gov/29548672/<br/>
The data is stored in NCBI GEO as SRR files which are highly compressed files that can be converted to fastq files using SRA Toolkit (configured above). <br/>
 The GEO entry can be found here: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE107436<br/>

To find a comprehensive list of the SRR files, we use the Run Selector. <br/>
Navigate to the bottom of the page and click “send to” and select “Run Selector”, and then press “go”.<br/>
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA420076&o=acc_s%3Aa<br/>

Under the Select section click on the Metadata and List Accession to dowload the information on the experiment and the list of SRR files.<br/>
See screen shot image. <br/>
Use the SRR_Acc_List.txt as the samples list for the SRRpull.sh script

## make a directory for your experiment:

    mkdir HDAC1_2_ChIPseq

Make a copy of the SRR_Acc_List.txt file in your new directory, using the text editor. Paste in the SRR list to the SRR_Acc_List.txt using nano.

    cd HDAC1_2_ChIPseq
    nano SRR_Acc_List.txt

## run the SRRpull.sh script
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

# 6. QC of the Fastq Files
We need to check the quality of the fastq files both before and after trimming. We use FastQC from https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Look at their tutorials to interpret the output files

The pretrim_fastqc.sh script makes an output file and a subfolder for pretrim .html files (one for each fastq file). We have to check both the foreward (R1) and reverse (R2) reads.

The script loops through each fastq and generates a quality resport for each fastq in the /alder/data/cbh/ciernia-data/HDAC1_2_ChIPseq/SRA/ folder.

It then combines the reports into one easy to read output using multiqc: PretrimFastQC_multiqc_report.html
PreTrimFastqc.out output log is also generated.

    sbatch pretrim_fastqc.sh

Check the PretrimFastQC_multiqc_report.html to help inform your trimming

# 7. Trimming fastq files
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

# 8. Repeat QC on post trim files
Repeat the QC on the post trim files and compare the output to the pretrim.

    sbatch posttrim_fastqc.sh

# 9. QC of the Fastq Files: Contamination Screening
FastQ Screen is a simple application which allows you to search a large sequence dataset against a panel of different genomes to determine from where the sequences in your data originate. The program generates both text and graphical output to inform you what proportion of your library was able to map, either uniquely or to more than one location, against each of your specified reference genomes. The user should therefore be able to identify a clean sequencing experiment in which the overwhelming majority of reads are probably derived from a single genomic origin. <br/>

## setup of the Fastq_screen indexes (bowtie2)
<br/> http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/_build/html/index.html#requirements-summary <br/>

This was already done for you, but in case you need to make changes this is how it was setup.<br/>

Bowtie2 index files were downloaded to /alder/data/cbh/ciernia-data/pipeline-tools/FastQ-Screen-0.14.1/FastQ_Screen_Genomes
with the command run from inside /alder/data/cbh/ciernia-data/pipeline-tools/

    fastq_screen --get_genomes

The fastq_screen.conf file is then copied from the FastQ_Screen_Genomes folder to /alder/data/cbh/ciernia-data/pipeline-tools/FastQ-Screen-0.14.1<br/>

We then need to edit the fastq_screen.conf file using nano to tell the program where to find bowtie2. Uncomment the BOWTIE2 path line so that it says: <br/>

BOWTIE2 /alder/data/cbh/ciernia-data/pipeline-tools/bowtie2-2.4.1-linux-x86_64/bowtie2<br/>

From your experiment directory run the script to check your trimmed fastq files:<br/>

    sbatch Fastqscreen.sh

The output is found in output/FastqScreen_multiqc_report.html<br/>


# 10. Align to mm10 genome using Bowtie2
We now will align the trimmed fastq files to the mm10 genome using bowtie2. Bowtie2 needs to know where the index files are located. We specified this in our bash_profile. Check the location:

    ls $BT2_MM10

Run the script to align. This takes significant time and memory. Output logs are placed in output/bowtielogs <br/>


    sbatch Bowtie2alignment.sh

Check the multiqc output to look at alignment rates: bowtie2_multiqc_report.html

# 11. Filter aligned files
We need to convert sam files to bam and filter to remove PCR duplicates, remove unmapped reads and secondary alignments (multi-mappers), and remove unpaired reads <br/>
We use samtools to convert sam to bam and then samtools fixmate to remove unmapped reads and 2ndary alignments.<br/>
We then remove PCR duplicates using -F 0x400 and -f 0x2 to keep only propperly paired reads<br/>
We then indext the reads and collect additional QC metrics using picard tools and samtools flagstat <br/>
QC meterics are then collected into one report using multiqc.

Run the script:

    sbatch SamtoolsFiltering.sh

Check the multiqc: sam_multiqc_report.html


# 12. QC with Deeptools:
<br/>
https://deeptools.readthedocs.io/en/develop/content/example_usage.html#how-we-use-deeptools-for-chip-seq-analyses
<br/>

## 1. Correlation between BAM files using multiBamSummary and plotCorrelation
Together, these two modules perform a very basic test to see whether the sequenced and aligned reads meet your expectations. We use this check to assess reproducibility - either between replicates and/or between different experiments that might have used the same antibody or the same cell type, etc. For instance, replicates should correlate better than differently treated samples.<br/>

The coverage calculation is done for consecutive bins of equal size (10 kilobases by default). This mode is useful to assess the genome-wide similarity of BAM files. The bin size and distance between bins can be adjusted.<br/>

Exclude black list regions: A BED or GTF file containing regions that should be excluded from all analyses. Currently this works by rejecting genomic chunks that happen to overlap an entry. Consequently, for BAM files, if a read partially overlaps a blacklisted region or a fragment spans over it, then the read/fragment might still be considered. Please note that you should adjust the effective genome size, if relevant.<br/>

For PE reads are centered with respect to the fragment length. For paired-end data, the read is centered at the fragment length defined by the two ends of the fragment. For single-end data, the given fragment length is used. This option is useful to get a sharper signal around enriched regions.


multiBamSummary bins --bamfiles file1.bam file2.bam -o results.npz --blackListFileName -p 20 --centerReads --labels

    multiBamSummary bins --bamfiles aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO KO WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K27ac_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20 --centerReads


    multiBamSummary bins --bamfiles aligned/SRR6326786_dedup.bam aligned/RR6326788_dedup.bam aligned/SRR6326790_dedup.bam aligned/SRR6326792_dedup.bam aligned/SRR6326794_dedup.bam aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam --labels KO KO WT WT WT KOInput KOInput WTInput WTInput WTInput WTInput WTInput -o Deeptools/H3K9ac_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20 --centerReads

This takes a lot of memory so it is better if you run the above two commands using this script:

    sbatch BamSummary.sh


 Plot the correlation between samples as either a PCA or a Correlation Plot:

 For H3K27ac:

     plotPCA -in Deeptools/H3K27ac_BamSum10kbbins.npz -o Deeptools/PCA_H3K27ac.pdf -T "PCA of Sequencing Depth Normalized Read Counts" --plotHeight 7 --plotWidth 9


    plotCorrelation -in Deeptools/H3K27ac_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_H3K27ac.pdf

 For H3K9ac:

     plotPCA -in Deeptools/H3K9ac_BamSum10kbbins.npz -o Deeptools/PCA_H3K9ac.pdf -T "PCA of Sequencing Depth Normalized Read Counts" --plotHeight 7 --plotWidth 9


    plotCorrelation -in Deeptools/H3K9ac_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_H3K9ac.pdf

## 2. Coverage check (plotCoverage).
To see how many bp in the genome are actually covered by (a good number) of sequencing reads, we use plotCoverage which generates two diagnostic plots that help us decide whether we need to sequence deeper or not. It samples 1 million bp, counts the number of overlapping reads and can report a histogram that tells you how many bases are covered how many times. Multiple BAM files are accepted, but they all should correspond to the same genome assembly.

    sbatch PlotCoverage.sh

## 3. Check Fragment Sizes (bamPEFragmentSize)
For paired-end samples, we often additionally check whether the fragment sizes are more or less what we would expected based on the library preparation.

    sbatch bamPEFragmentSize.sh

## 4. GC-bias check (computeGCBias) - ADD later if needed
Many sequencing protocols require several rounds of PCR-based DNA amplification, which often introduces notable bias, due to many DNA polymerases preferentially amplifying GC-rich templates. Depending on the sample (preparation), the GC-bias can vary significantly and we routinely check its extent. When we need to compare files with different GC biases, we use the correctGCBias module. See the paper by Benjamini and Speed for many insights into this problem.

## 5. Assessing the ChIP strength.
https://deeptools.readthedocs.io/en/develop/content/tools/plotFingerprint.html <br/>
We do this quality control step to get a feeling for the signal-to-noise ratio in samples from ChIP-seq experiments. It is based on the insights published by Diaz et al. This tool samples indexed BAM files and plots a profile of cumulative read coverages for each. All reads overlapping a window (bin) of the specified length are counted; these counts are sorted and the cumulative sum is finally plotted.<br/>

This tool is based on a method developed by Diaz et al.. It determines how well the signal in the ChIP-seq sample can be differentiated from the background distribution of reads in the control sample. For factors that will enrich well-defined, rather narrow regions (e.g. transcription factors such as p300), the resulting plot can be used to assess the strength of a ChIP, but the broader the enrichments are to be expected, the less clear the plot will be. Vice versa, if you do not know what kind of signal to expect, the fingerprint plot will give you a straight-forward indication of how careful you will have to be during your downstream analyses to separate biological noise from meaningful signal.<br/>

An ideal [input][] with perfect uniform distribution of reads along the genome (i.e. without enrichments in open chromatin etc.) and infinite sequencing coverage should generate a straight diagonal line. A very specific and strong ChIP enrichment will be indicated by a prominent and steep rise of the cumulative sum towards the highest rank. This means that a big chunk of reads from the ChIP sample is located in few bins which corresponds to high, narrow enrichments typically seen for transcription factors.https://deeptools.readthedocs.io/en/latest/content/feature/plotFingerprint_QC_metrics.html <br/>

    sbatch FingerPrint.sh


## 6. Convert to Read Depth Normalized BigWigs
Use BamCoverage to convert BAM to bigWig (or bedGraph for that matter), with normalization, such that different samples can be compared despite differences in their sequencing depth. The effective genome size is set for mappable part of mm10. It makes a normalized bigwig file for each SRR. Blacklist regions are excluded and reads are extended and centered. Averages in 10bp bins across the genome.

    sbatch BamCoverageDeeptools.sh


## 7. TSS Heatmap Plots
Plot Normalized signal over the TSS with computeMatrix, plotHeatmap and plotProfile. You first need the coordinates of all the mm10 genes in bed format. To get these go to the UCSC genome browser and select mm10. Go to the table browser and download a bed file for the gene body. Load the bed file into your experiment folder on Alder.<br/>

Compute a coverage matrix for each bed file genes from your normalized bigwig files and then plot.https://deeptools.readthedocs.io/en/develop/content/tools/computeMatrix.html


    sbatch Geneplots_deeptools.sh


# 13. Peak Calling with HOMER
Up until this point the pipeline is relatively standard for all PE ChIPseq experiments. The choice of peak callers and settings depends on what type of ChIP experiment you are performing (ie. histone marks vs. transcription factors). This dataset was for H3K27ac and H3K9ac, both classic histone acetylation marks that are analyzed nicely with HOMER using -style histone and some custom settings based on knowledge of how these two marks behave. If you are working with other ChIP datasets where the marks are either more or less peak like you need to make adjustments to the HOMER calls. See http://homer.ucsd.edu/homer/ngs/peaks.html for details.

From two recent microglial ChIPseq papers:
From Wendeln 2018 (https://www.nature.com/articles/s41586-018-0023-4): Tag directories were created from bam files using ‘makeTagDirectory’ for individual samples and inputs, and peak calling was performed using ‘findpeaks -style histone’ with fourfold enrichment over background and input, a Poisson P value of 0.0001, and a peak width of 500 bp for H3K4me1 and 250 bp for H3K27ac.

From Goseelin 2017 (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5858585/):ChIP-seq Tag directories for the ChIP-seq experiments were combined into ex vivo and in vitro pools for each target in both mouse and human. The tag directories for the input DNA were likewise combined. Peaks were then called on the pooled tags with the pooled input DNA as background using HOMER’s “findPeaks” command with the following parameters for the PU.1 ChIP-seq: “-style factor -size 200 -minDist 200” and the following parameters for the H3K27ac and H3K4me2 ChIP-seq: “-style histone -size 500 -minDist 1000 -region.” The “-tbp” parameter was set to the number of replicates in the pool.

We can try both approaches and compare the results on the UCSC genome browser to see which peak calling conditions best capture the data.

## Make Tag Directories
The first step to running HOMER is to make Tag Directories: http://homer.ucsd.edu/homer/ngs/tagDir.html
We will make a folder Tag_Directories and then make tags for each sample WT and KO sample individually and all the input samples together. This is approach is specifically based for this experiment in which we have only 2-3 biological replicates per condition and input samples are not matched to individual samples.

For the H3K27ac mark we have the following:  <br/>
HDAC1/2KO MG: <br/>
SRR6326785 <br/>
SRR6326800 <br/>
SRR6326801 <br/>

WT MG: <br/>
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

For input samples: <br/>
KO MG: <br/>
SRR6326787 <br/>
SRR6326789 <br/>

WT MG: <br/>
SRR6326791 <br/>
SRR6326793 <br/>
SRR6326795 <br/>
SRR6326797 <br/>
SRR6326799 <br/>

To make a tag directory for each sample run:

      sbatch HOMER_MakeTags.sh

## Call Peaks and Find Differential Peaks Between Conditions

There are several different approaches to analyze this data using HOMER. I have summarized the main points below but you should read the full HOMER ChIPseq documentation before running your own experiment. <br/>

From the HOMER website:http://homer.ucsd.edu/homer/ngs/peaksReplicates.html<br/>
There are two general (but related) approaches to identifying differential peaks. The first is to use the getDifferentialPeaksReplicates.pl command, which attempts to automate the steps described below into a single command to generate a peak file. The second is to prepare your own regions and read counts and then use getDiffExpression.pl directly to calculate the differential enrichment. <br/>

HOMER requires R/Bioconductor to be installed with packages for DESeq2 installed. <br/>
Each user must to this install by running the following code from in their home directory (cd ~/):

    module load R/3.6.1
    R

This will start the R program environment. In R, install DESeq2 using bioconductor: https://bioconductor.org/packages/release/bioc/html/DESeq2.html

    BiocManager::install("DESeq2")

This will install DESeq2 and all the dependencies. If asked to update any packages put "y". After the installation is complete, you can exit R using "quit()" or "q()". You do not need to save the workspace ("n").  <br/>

### Approach #1: getDifferentialPeaksReplicates.pl
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


### Approach #2: Multi-Step with getDiffExpression.pl
The first approach works well with lots of replicates and high quality data, etc. We only have 2-3 replicates and so the following approach basically does the same thing as approach #1 but in individual steps that allow us to fine tune each step for our data. This is also the approache both the Wendln and Gosselin papers used.<br/>

#### Step 1:
Pool the target tag directories and input directories separately into pooled experiments and perform an initial peak identification using findPeaks. Pooling the experiments is generally more sensitive than trying to merge the individual peak files coming from each experiment (although this can be done using the "-use <peaks.txt...>" option if each directory already has a peak file associated with it).

    module load samtools/1.4
    module load jre/1.8.0_121
    module load R/3.6.1

For H3K27ac peaks make pooled tag directories for each condition:

Make tag directories for HDAC1&2 KO MG H3K27ac

    #HDAC1/2KO MG:
    #SRR6326785
    #SRR6326800
    #SRR6326801

    makeTagDirectory TagDirectory/Pooltag_H3K27ac_HDAC12KO aligned/SRR6326785_dedup.bam aligned/SRR6326800_dedup.bam aligned/SRR6326801_dedup.bam

Make tag directories for HDAC1&2 KO MG Input

    #SRR6326787	input
    #SRR6326789	input

    makeTagDirectory TagDirectory/Pooltag_input_HDAC1_2KO aligned/SRR6326787_dedup.bam aligned/SRR6326789_dedup.bam

Make tag directories for WT MG H3K27ac

    #SRR6326796	H3K27ac
    #SRR6326798	H3K27ac

    makeTagDirectory TagDirectory/Pooltag_H3K27ac_WT aligned/SRR6326796_dedup.bam aligned/SRR6326798_dedup.bam

Make tag directories for WT MG Input

    #SRR6326791	input	wildtype
    #SRR6326793	input	wildtype
    #SRR6326795	input	wildtype
    #SRR6326797	input	wildtype
    #SRR6326799	input	wildtype

    makeTagDirectory TagDirectory/Pooltag_input_WT aligned/SRR6326791_dedup.bam aligned/SRR6326793_dedup.bam aligned/SRR6326795_dedup.bam aligned/SRR6326797_dedup.bam aligned/SRR6326799_dedup.bam


#### Step 2:
Find peaks for each pooled H3K27ac directory compared to pooled input directory.

##### using parameters from Wendeln:

From Wendeln 2018 (https://www.nature.com/articles/s41586-018-0023-4): Tag directories were created from bam files using ‘makeTagDirectory’ for individual samples and inputs, and peak calling was performed using ‘findpeaks -style histone’ with fourfold enrichment over background and input, a Poisson P value of 0.0001, and a peak width of 500 bp for H3K4me1 and 250 bp for H3K27ac. <br/>

Since we don't have individual input files matched to samples like Wendeln did, we will used the pooledtag directories and call peaks using their settings. The fourfold enrichment over background and input, a Poisson P value of 0.0001 are the default values.<br/>

make a folder for homer_regions:

	mkdir homer_regions/

HDAC1/2 KO:

    findPeaks TagDirectory/Pooltag_H3K27ac_HDAC12KO -style histone -size 250 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.txt

HDAC1/2 WT:

    findPeaks TagDirectory/Pooltag_H3K27ac_WT -style histone -size 250 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt


##### using parameters from Gosselin:

From Gosselin 2017 (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5858585/):ChIP-seq Tag directories for the ChIP-seq experiments were combined into ex vivo and in vitro pools for each target in both mouse and human. The tag directories for the input DNA were likewise combined. Peaks were then called on the pooled tags with the pooled input DNA as background using HOMER’s “findPeaks” command with the following parameters for the PU.1 ChIP-seq: “-style factor -size 200 -minDist 200” and the following parameters for the H3K27ac and H3K4me2 ChIP-seq: “-style histone -size 500 -minDist 1000 -region.” The “-tbp” parameter was set to the number of replicates in the pool.<br/>

Here are some of the conditions that are different between the two approaches:<br/>
-region (extends start/stop coordinates to cover full region considered "enriched")<br/>
-minDist <#> (minimum distance between peaks, default: peak size x2)<br/>
-tbp <#> (Maximum tags per bp to count, 0 = no limit, default: auto)<br/>

HDAC1/2 KO: 3 replicates

    findPeaks TagDirectory/Pooltag_H3K27ac_HDAC12KO -style histone -size 500 -minDist 1000 -region -tbp 3 -i TagDirectory/Pooltag_input_HDAC1_2KO -o homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.txt

HDAC1/2 WT: 2 replicates

    findPeaks TagDirectory/Pooltag_H3K27ac_WT -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_input_WT -o homer_regions/HomerpeaksGosselin_H3K27ac_WT.txt

Run peak finding as a script for both H3K27ac (lines above) and H3K9ac:

	FindPeaks_HOMER.sh

#### Step 3:

Convert the peak files into bed files to load onto the UCSC genome browser.

Put the pos2bedmod.pl file in your experiment directory. Change the permssions by running this:

	chmod +x pos2bedmod.pl

Then run the following script to format all your peakfiles:

	Convert_to_bed.sh

What the script does:

Remove the extra # lines in the Homer output

    grep -v '^#' homer_regions/homer_regions/HomerpeaksGosselin_H3K27ac_WT.txt > homer_regions/tmp.txt

I modified one of the HOMER scripts that converts HOMER peak files to bed fils: use pos2bedmol.pl instead of pos2bed.pl <br/>
The only changes is that the modified version puts the findPeaks score in the 4th column of the bed file by changing this line in pos2bed.pl:<br/>
	#print $filePtr "$chr\t$start\t$end\t$line[0]\t$v\t$dir\n"; to this line: print $filePtr "$chr\t$start\t$end\t$line[7]\t$v\t$dir\n"

    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed

Since we aligned to the ensembl genes we have to add "chr" to the chormosome names to load unto the UCSC browser. Then remove the intermediate tmp files.

    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/HomerpeaksGosselin_H3K27ac_WT.bed


    rm homer_regions/tmp*


#### Step 4. UCSC Genome Browser Tracks (HOMER)
The basic strategy HOMER uses is to create a bedGraph formatted file that can then be uploaded as a custom track to the genome browser.  This is accomplished using the makeUCSCfile program.  To make a ucsc visualization file, type the following. To visualize the exact length of the reads, use "-fragLength given".<br/>

makeUCSCfile <tag directory> -o auto -fragLength given <br/>

i.e. makeUCSCfile PU.1-ChIP-Seq/ -o auto<br/>
(output file will be in the PU.1-ChIP-Seq/ folder named PU.1-ChIP-Seq.ucsc.bedGraph.gz)<br/>

The "-o auto" with make the program automatically generate an output file name (i.e. TagDirectory.ucsc.bedGraph.gz) and place it in the tag directory which helps with the organization of all these files.  The output file can be named differently by specifying "-o outputfilename" or by simply omitting "-o", which will send the output of the program to stdout (i.e. add " > outputfile" to capture it in the file outputfile).  It is recommended that you zip the file using gzip and directly upload the zipped file when loading custom tracks at UCSC.<br/>

To visualize the experiment in the UCSC Genome Browser, go to Genome Browser page and select the appropriate genome (i.e. the genome that the sequencing tags were mapped to).  Then click on the "add custom tracks" button (this will read "manage custom tracks" once at least one custom track is loaded).  Enter the file created earlier in the "Paste URLs or data" section and click "Submit".<br/>

There are two important parameters to consider during normalization of data.  First, the total read depth of the experiment is important, which is obvious.  The 2nd factor to consider is the length of the reads (this is new to v4.4).  The problem is that if an experiment has longer fragment lengths, it will generate additional coverage than an experiment with shorter fragment lengths.  In order to make sure there total area under the curve is the same for each experiment, experiments are normalized to a fixed number of reads as well as a 100 bp fragment length.  If reads are longer than 100 bp, they are 'down-normalized' a fractional amount such that they produce the same relative coverage of a 100 bp fragment length.  Experiments with shorter fragment lengths are 'up-normalized' a proportional amount (maximum of 4x or 25 bp).  This allows experiments with different fragment lengths to be comparable along the genome browser.<br/> Normalize the total number of reads to this number, default 1e7.  This means that tags from an experiment with only 5 million mapped tags will count for 2 tags apiece. This script also fixes the chromosome names to include "chr" and change the MT chromosome to M. It also makes bigwig files needed for making a browser hub described below.


    sbatch UCSCBrowserHOMER.sh


The bedGraph.gz files then then be loaded one at a time as custom tracks onto the UCSC genome browser. You can save the session and then look at them again later. However, this is very slow as you have to load each final individually. Instead, we can create a track hub, where all of our files can be loaded as a custom hub. <br/>

#### Step 4B. UCSC Genome Browser My Hub
We first have to convert our bedGraph and peak bed files into compressed formats: bigwig and bigBed. We can so this using the UCSC genome browser utilities. These tools are already installed in /alder/data/cbh/ciernia-data/pipeline-tools/UCSC/ using rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ ./ <br/>
The path was added to the bash_profile: PATH=$PATH:/alder/data/cbh/ciernia-data/pipeline-tools/UCSC and so the tools can be called by name. We also need the chromosome sizes for mm10. This can be retrieved from UCSC with: wget http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/mm10.chrom.sizes <br/>
A copy of this file is in /alder/data/cbh/ciernia-data/pipeline-tools/UCSC/ and can be called using $mm10chrsizes. This was all done using the UCSCBrowserHOMER.sh script run in Step 4A.

Now that we have our compressed files we can setup our track hub:<br/>
Track hubs require a webserver to host the files. We can use github to host all files < 25MB. Github supports byte-range access to files when they are accessed via the raw.githubusercontent.com style URLs. To obtain a raw URL to a file already uploaded on Github, click on a file in your repository and click the Raw button. The bigDataUrl field (and any other statement pointing to a URL like bigDataIndex, refUrl, barChartMatrixUrl, etc.) of your trackDb.txt file should use the "raw.githubusercontent.com" style URL. <br/> https://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html <br/>

Track hubs can now be specified in a single text file: http://genome.ucsc.edu/goldenPath/help/hgTracksHelp.html#UseOneFile <br/>
Once this text file is loaded onto github, you can get the RAW url for the text file and then check your hub works by pasting the url into the hub development took and clicking "Check Hub Settings".  http://genome.ucsc.edu/cgi-bin/hgHubConnect?#hubDeveloper
If your hub has no errors you can then click the "View on UCSC browser" to view your hub.<br/>

We have setup a hub using the TrackHubmm10.txt file. The link to this file is: https://raw.githubusercontent.com/ciernialab/Alder-ChIPseq-Tutorial/master/TrackHubmm10.txt <br/>
If you paste this link into the "My Hubs" entry area: http://genome.ucsc.edu/cgi-bin/hgHubConnect?#unlistedHubs you can view the hub. You can edit the hub, add tracks etc. Then just check the hub, reload it and go!


#### Step 5: Look at overlapping peaks with Upset plots
Code from:
https://github.com/stevekm/Bioinformatics/blob/a2a052029980369545085aadbd478e32c8ba6213/HOMER_mergePeaks_pipeline/peak_overlap_HOMER_mergePeak_pipeline.sh
This pipeline performs HOMER mergePeaks on a large amount of paired BED files, to find overlapping genomic regions. These overlaps are then visualized with Venn diagrams and UpSet plots.

This simple workflow uses the venn.txt output from HOMER's mergePeaks command to visualize the overlaps between different sets of peaks (such as .bed files from a ChIP-Seq experiment), using the UpSetR package for R version 3.3.0.

In this example, the venn.txt file would have been created by using a HOMER command such as this:

	mergePeaks homer_regions/HomerpeaksGosselin_H3K27ac_WT.bed homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.bed homer_regions/HomerpeaksWendlen_H3K27ac_WT.bed homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.bed -prefix mergepeaks -venn homer_regions/venn.H3K27ac.txt -matrix homer_regions/matrix.H3K27ac.txt


Pass the venn.H3K27ac.txt file to the multi_peaks_UpSet_plot.R script like this:


	Rscript --vanilla multi_peaks_UpSet_plot.R "SampleID" homer_regions/venn.H3K27ac.txt

The plot is saved to the same directory as the venn.H3K27ac.txt file. Repeat for H3K9ac.

	mergePeaks homer_regions/HomerpeaksGosselin_H3K9ac_WT.bed homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.bed homer_regions/HomerpeaksWendlen_H3K9ac_WT.bed homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.bed -prefix mergepeaks -venn homer_regions/venn.H3K27ac.txt -matrix homer_regions/matrix.H3K9ac.txt


	Rscript --vanilla multi_peaks_UpSet_plot.R "SampleID" homer_regions/venn.H3K9ac.txt

#### Step 6: Identifiy differential peaks statistically
Run the following script:

	sbatch DifferentialPeaks.sh

The script performs the following steps:

	mkdir DEpeaks/

Combine WT and KO peaks into one file for annotation using mergPeaks. <br/>
For H3K27ac peaks:<br/>

    mergePeaks homer_regions/HomerpeaksWendlen_H3K27ac_HDAC1_2KO.txt homer_regions/HomerpeaksWendlen_H3K27ac_WT.txt > homer_regions/HomerpeaksWendlen_H3K27ac_all.txt

    mergePeaks homer_regions/HomerpeaksGosselin_H3K27ac_HDAC1_2KO.txt homer_regions/HomerpeaksGosselin_H3K27ac_WT.txt > homer_regions/HomerpeaksGosselin_H3K27ac_all.txt

For H3K9ac peaks:<br/>

    mergePeaks homer_regions/HomerpeaksWendlen_H3K9ac_HDAC1_2KO.txt homer_regions/HomerpeaksWendlen_H3K9ac_WT.txt > homer_regions/HomerpeaksWendlen_H3K27ac_all.txt

    mergePeaks homer_regions/HomerpeaksGosselin_H3K9ac_HDAC1_2KO.txt homer_regions/HomerpeaksGosselin_H3K9ac_WT.txt > homer_regions/HomerpeaksGosselin_H3K27ac_all.txt

Quantify the reads at the initial putative peaks across each of the target and input tag directories using annotatePeaks.pl.
http://homer.ucsd.edu/homer/ngs/diffExpression.html. This generate raw counts file from each tag directory for each sample for the merged peaks.<br/>

IMPORTANT: Make sure you remember the order that your experiments and replicates where entered in for generating these commands.  Because experiment names can be cryptic, you will need to specify which experiments are which when running getDiffExpression.pl to assign replicates and conditions.<br/>

    	annotatePeaks.pl homer_regions/HomerpeaksWendlen_H3K27ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326785 TagDirectory/tag_SRR6326800 TagDirectory/tag_SRR6326801  TagDirectory/tag_SRR6326796 TagDirectory/tag_SRR6326798 > DEpeaks/countTable.Wendlen.H3K27ac_all.peaks.txt

	annotatePeaks.pl homer_regions/HomerpeaksGosselin_H3K27ac_all.txt mm10 -raw -d TagDirectory/tag_SRR6326785 TagDirectory/tag_SRR6326800 TagDirectory/tag_SRR6326801  TagDirectory/tag_SRR6326796 TagDirectory/tag_SRR6326798 > DEpeaks/countTable.Gosselin.H3K27ac_all.peaks.txt

	annotatePeaks.pl homer_regions/HomerpeaksWendlen_H3K9ac_all.peaks.txt mm10 -raw -d TagDirectory/tag_SRR6326786 TagDirectory/tag_SRR6326788 TagDirectory/tag_SRR6326790 TagDirectory/tag_SRR6326792 TagDirectory/tag_SRR6326794 > DEpeaks/countTable.Wendlen.H3K9ac.peaks.txt

	annotatePeaks.pl homer_regions/HomerpeaksGosselin_H3K9ac_all.peaks.txt mm10 -raw -d TagDirectory/tag_SRR6326786 TagDirectory/tag_SRR6326788 TagDirectory/tag_SRR6326790 TagDirectory/tag_SRR6326792 TagDirectory/tag_SRR6326794 > DEpeaks/countTable.Gosselin.H3K9ac.peaks.txt

Calls getDiffExpression.pl and ultimately passes these values to the R/Bioconductor package DESeq2 to calculate enrichment values for each peak, returning only those peaks that pass a given fold enrichment (default: 2-fold) and FDR cutoff (default 5%).<br/>

The getDiffExpression.pl program is executed with the following arguments:<br/>
getDiffExpression.pl <raw count file> <group code1> <group code2> [group code3...] [options] > diffOutput.txt<br/>

Provide sample group annotation for each experiment with an argument on the command line (in the same order found in the file, i.e. the same order given to the annotatePeaks.pl command when preparing the raw count file).<br/>

#####  Considerations:
###### Variance Stabilization/Normalized Read counts in output file:

http://homer.ucsd.edu/homer/ngs/diffExpression.html


By default, getDiffExpression.pl will perform a variance stabilization transform on your raw count data so that viewing the data is easier after the command is finished.  The idea behind variance stabilization is to "transform" the data such that variance in the read counts is relatively constant as a function of intensity.  This limits the "flare" of low expression variance that you normally see in log-transformed scatter plots when comparing one experiment versus another. By default the program will use DESeq2's rlog transform to create nicely normalized log2 read counts ("-rlog"). The program also supports DESeq2's VST transform (option "-vst"), which is faster and may be recommended if you are processing a lot of samples. In both cases the tranforms will be conducted with the design matrix specifying which samples are replicates (or paired in the batch definition). If you prefer read counts that are simply normalized to the total count in the raw count matrix, specify "-simpleNorm", or "-raw" to keep the data the same as the input data.<br/>

IMPORTANT NOTE: The rlog and vst transforms may have problems if there are no replicates or too few samples (i.e. only 2), so in these cases it is recommended to use "-simpleNorm" or "-raw".<br/>

###### Normalization to Tag directory or gene totals
Differential enrichment calculation normalizes to the total mapped reads in the tag directory instead of normalizing based on the matrix of gene expression values, specify "-norm2total". <br/>

The "-norm2total" option is very useful for ChIP-Seq when you do not expect the signal from each experiment to be comparable, like when comparing target vs. IgG experiemnts.  However, if you were comparing a type of experiment where you do expect similar signal (for example, H3K27ac levels might be assumed to be similar across conditions), it is not recommended that you use the "-norm2total" option.<br/>


    getDiffExpression.pl countTable.Wendlen.H3K27ac_all.peaks.txt Hdac12KO Hdac12KO Hdac12KO WT WT -simpleNorm > DEpeaks/Wendlen.H3K27ac_diffpeaksOutput.txt

    getDiffExpression.pl countTable.Gosselin.H3K27ac_all.peaks.txt Hdac12KO Hdac12KO Hdac12KO WT WT -simpleNorm > DEpeaks/Gosselin.H3K27ac_diffpeaksOutput.txt

    getDiffExpression.pl countTable.Wendlen.H3K9ac.peaks.txt Hdac12KO Hdac12KO WT WT WT -simpleNorm -simpleNorm > DEpeaks/Wendlen.H3K9ac_diffpeaksOutput.txt

    getDiffExpression.pl countTable.Gosselin.H3K9ac.peaks.txt Hdac12KO Hdac12KO WT WT WT -simpleNorm -simpleNorm > DEpeaks/Gosselin.H3K9ac_diffpeaksOutput.txt


#### Step 7: look at DE peaks on UCSC genome browser and see if they are reasonable
We will next examine the ouput of getDiffExpression.pl. If you open the DiffPeak.out log file you will find the following for each comparisons we did:<br/>

Wendlen.H3K27ac:<br/>
Using DESeq2 to calculate differential expression/enrichment...<br/>
        Output Stats Hdac12KO vs. WT:<br/>
                Total Genes: 472236<br/>
                Total Up-regulated in WT vs. Hdac12KO: 0 (0.000%) [log2fold>1, FDR<0.05]<br/>
                Total Dn-regulated in WT vs. Hdac12KO: 1 (0.000%) [log2fold<-1, FDR<0.05]<br/>


Gosselin.H3K27ac:<br/>
Using DESeq2 to calculate differential expression/enrichment...<br/>
        Output Stats Hdac12KO vs. WT:<br/>
                Total Genes: 221433<br/>
                Total Up-regulated in WT vs. Hdac12KO: 0 (0.000%) [log2fold>1, FDR<0.05]<br/>
                Total Dn-regulated in WT vs. Hdac12KO: 1 (0.000%) [log2fold<-1, FDR<0.05]<br/>

Wendlen.H3K9ac:<br/>
Using DESeq2 to calculate differential expression/enrichment...<br/>
        Output Stats Hdac12KO vs. WT:<br/>
                Total Genes: 475806<br/>
                Total Up-regulated in WT vs. Hdac12KO: 297 (0.062%) [log2fold>1, FDR<0.05]<br/>
                Total Dn-regulated in WT vs. Hdac12KO: 1072 (0.225%) [log2fold<-1, FDR<0.05]<br/>

Gosselin.H3K9ac:<br/>
Using DESeq2 to calculate differential expression/enrichment...<br/>
        Output Stats Hdac12KO vs. WT:<br/>
                Total Genes: 228263<br/>
                Total Up-regulated in WT vs. Hdac12KO: 852 (0.373%) [log2fold>1, FDR<0.05]<br/>
                Total Dn-regulated in WT vs. Hdac12KO: 2678 (1.173%) [log2fold<-1, FDR<0.05]<br/>

So it looks like more differences bewteen HDAC1/2KO and WT for H3K9ac regardless of the peak settings.The Gosselin peaks show more differential peaks, which is potentially expected as the peaks are larger. <br/>

We can open the DE peak files  and look at several top regions the UCSC genome browser. Do they look different?

#### Step 8: Make Deeplots heatmap and profile over DE peaks
