#!bin/bash

###Required Software: fastqc; trim_galore-0.5.0, cutadapt-1.18, breseq 

###Step 1 Manual quality cheking with fastqc gui

./fastqc #command to open fastqc gui from the same working directory

###Step 2 prior quality filtering raw fastq reads using trim_galore

trim_galore -j 32 --paired -q 30 --gzip --no_report_file -o clean_reads D3A1_S1_R1_001.fastq.gz D3A1_S1_R2_001.fastq.gz

###Example command for populations samples

breseq -j 4 -p --polymorphism-frequency-cutoff 0.1 --polymorphism-reject-indel-homopolymer-length 0 --polymorphism-reject-surrounding-homopolymer-length 0 --polymorphism-bias-cutoff 0 --polymorphism-minimum-coverage-each-strand 0 -r GCA_002892855.1_ASM289285v1_genomic.gbff D3A1_S1_R1_001_val_1.fq.gz D3A1_S1_R2_001_val_2.fq.gz -o breseq_output/D3A1

###Example command for single isolates samples

breseq -j 4 -p --polymorphism-frequency-cutoff 0.1 -r GCA_002892855.1_ASM289285v1_genomic.gbff SD3A1_S1_R1_001_val_1.fq.gz SD3A1_S1_R2_001_val_2.fq.gz -o breseq_output/SD3A1


###breseq gdtool to merge all the output

#Whole populations
gdtools COMPARE -o all_pop.html -r GCA_002892855.1_ASM289285v1_genomic.gbff *.gd 

#Single isolates
gdtools COMPARE -o all_single.html -r GCA_002892855.1_ASM289285v1_genomic.gbff *.gd
