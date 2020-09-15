#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 00_RawData 01_CleanData

##############Part1 QC: Rawdata to CleanData###########################
fastp=~/bin/fastp
bwa=~/bin/bwa
samtools=~/bin/samtools
bedtools=~/bin/bedtools
Ref=./Sscrofa11.1/Sscrofa11.1.fa
RawData=./00_RawData
CleanData=./01_CleanData

#Before performing the metagenomic pipeline, copy the raw sequencing data into the directory '00_Rawdata'.
cd ${CleanData}
##QC Step1: filter low quality sequence by fastp 
${fastp} -i ${RawData}/${SampleID}_1.raw.fq.gz \
-o ${SampleID}.clean_R1.fastq.gz \
-I ${RawData}/${SampleID}_2.raw.fq.gz \
-O ${SampleID}.clean_R2.fastq.gz -h ${SampleID}.filt.html \
-j ${SampleID}.filt.json \
--cut_by_quality3 \
-W 4 -M 20 -n 5 -c -l 50 -w 3


##QC Step2: filt host sequence
#index of reference genome
${bwa} index -a bwtsw -p ../Sscrofa11.1 ../${Ref}

#mapping to reference
${bwa} mem -t 8 -T 30 \
${Ref} \
${SampleID}.clean_R1.fastq.gz ${SampleID}.clean_R2.fastq.gz \
-R '@RG\tID:${SampleID}_join\tPL:illumina\tSM:${SampleID}_join' | samtools view -S -b 

#extract unmapped sequence
${samtools} view -b -f 12 -F 256 ${SampleID}.bam >${SampleID}_filter_host.bam

#sorted the bam file
${samtools} sort -n ${SampleID}_filter_host.bam -o ${SampleID}_filter_host_sorted.bam 
 
#transform bam to fastq
${bedtools} bamtofastq -i ${SampleID}_filter_host_sorted.bam -fq ${SampleID}_filter_host_r1.fastq -fq2 ${SampleID}_filter_host_r2.fastq



#Generate Reports
${fastp} -A -G -Q -L \
-i ${SampleID}_filter_host_r1.fastq \
-I ${SampleID}_filter_host_r2.fastq \ 
-o ${SampleID}_final_R1.fastq.gz \ 
-O ${SampleID}_final_R2.fastq.gz \ 
-h ${SampleID}_final.html \ 
-j ${SampleID}_final.json 

#return to initial directory
cd ../

#get time end the job
echo "Job finished at:" `date`