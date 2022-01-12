#!bin/bash

###RNA-Seq Pipeline

###Required Software: fastqc; trim_galore-0.5.0, cutadapt-1.18, subread

###Step 1 Manual quality cheking with fastqc gui

./fastqc #command to open fastqc gui from the same working directory

###Step 2 prior quality filtering raw fastq reads using trim_galore
##Example command; here my directory name: "/data/mhoque/03.transcriptomics/01.vcac_rna/01.raw_reads"; output folder: 02.clean_reads

trim_galore -j 32 --paired -q 30 --gzip --no_report_file -o /data/mhoque/03.transcriptomics/01.vcac_rna/02.clean_reads /data/mhoque/03.transcriptomics/01.vcac_rna/01.raw_reads/VCWT1_S1_R1_001.fastq.gz /data/mhoque/03.transcriptomics/01.vcac_rna/01.raw_reads/VCWT1_S1_R2_001.fastq.gz

#Executing command with for loop

for R1 in /data/mhoque/03.transcriptomics/01.vcac_rna/01.raw_reads/*R1*; do R2=${R1//R1_001.fastq.gz/R2_001.fastq.gz}; trim_galore -j 32 --paired -q 30 --gzip --no_report_file -o /data/mhoque/03.transcriptomics/01.vcac_rna/02.clean_reads $R1 $R2; done

###Step 3 building reference index with subread; my working directory: "/data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_subread_index"; index name: N16961 

subread-buildindex -o /data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_subread_index/N16961 /data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_subread_index/N16961.fasta


###Step 4 alignement with reference
##Example command; here my output folder: "/data/mhoque/03.transcriptomics/01.vcac_rna/05.aligned_bam/01.vc"

subread-align -T 32 -t 0 -i /data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_subread_index/N16961 -r /data/mhoque/03.transcriptomics/01.vcac_rna/02.clean_reads/VCWT1_S1_R1_001_val_1.fq.gz -R /data/mhoque/03.transcriptomics/01.vcac_rna/02.clean_reads/VCWT1_S1_R2_001_val_2.fq.gz -o /data/mhoque/03.transcriptomics/01.vcac_rna/05.aligned_bam/01.vc/wt1.bam

#Executing command with for loop

for R1 in /data/mhoque/03.transcriptomics/01.vcac_rna/02.clean_reads/*R1*; do R2=${R1//R1_001_val_1.fq.gz/R2_001_val_2.fq.gz}
fname=$(basename $R1); subread-align -T 32 -t 0 -i /data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_subread_index/N16961 -r $R1 -R $R2 -o /data/mhoque/03.transcriptomics/01.vcac_rna/05.aligned_bam/01.vc/${fname}.bam; done

###Step 5 counting reads; here my output folder "/data/mhoque/03.transcriptomics/01.vcac_rna/06.count_files"
featureCounts -T 32 -B -p -t CDS -g gene_id -a /data/mhoque/03.transcriptomics/01.vcac_rna/03.reference/01.vc_bowtie_index/N16961.gtf -o /data/mhoque/03.transcriptomics/01.vcac_rna/06.count_files/vc_rna_counts_vcac.txt *.bam



