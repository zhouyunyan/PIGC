#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 02_Assembly

##############Part2 Assembly: CleanData to Contigs###########################
megahit=~/bin/megahit
CleanData=./01_CleanData
Assembly=./02_Assembly
bowtie2build=~/bin/bowtie2-build
bowtie2=~/bin/bowtie2

mkdir ./02_Assembly/Contigs ./02_Assembly/unmapped
Contigs=./02_Assembly/Contigs
unmapped=./02_Assembly/unmapped

#single sample Assembly
${megahit} -1 ${CleanData}/${SampleID}_final_R1.fastq.gz \
-2 ${CleanData}/${SampleID}_final_R2.fastq.gz \
--min-count 2 \
--k-min 27 \
--k-max 87 \
--k-step 10 \
--num-cpu-threads 20 \
--min-contig-len 500 \
-o ${Assembly}/${SampleID}_megahit

cp ${SampleID}_megahit/final.contigs.fa ${Contigs}/${SampleID}.fa

###acquire the unassembled reads
cd ${Contigs}

#build index
${bowtie2build} ${SampleID}.fa ${SampleID}

#aligning sequencing reads to assembled contigs
${bowtie2} -p 8 -x ${SampleID} -1 ${CleanData}/${SampleID}_final_R1.fastq.gz -2 ${CleanData}/${SampleID}_final_R2.fastq.gz -S ${SampleID}.sam

#extract unmapped sequence
${samtools} view -b -f 12 -F 256 ${SampleID}.sam >${SampleID}_unmapped.bam

#sorted the bam file
${samtools} sort -n ${SampleID}_unmapped.bam -o ${SampleID}_unmapped_sorted.bam 
 
#transform bam to fastq
${bedtools} bamtofastq -i ${SampleID}_unmapped_sorted.bam -fq ${SampleID}_unmapped_r1.fastq -fq2 ${SampleID}_unmapped_r2.fastq

#return to initial directory
cd ../../
#merge all unmapped reads
cat ${Contigs}/*unmapped_r1.fastq >${unmapped}/unmapped_r1.fastq
cat ${Contigs}/*unmapped_r2.fastq >${unmapped}/unmapped_r2.fastq

#all unmapped reads were co-assembled
${megahit} -1 ${unmapped}/unmapped_r1.fastq \
-2 ${unmapped}/unmapped_r2.fastq \
--min-count 2 \
--k-min 27 \
--k-max 87 \
--k-step 10 \
--num-cpu-threads 20 \
--min-contig-len 500 \
-o ${unmapped}/unmapped_megahit

#merge all contigs from single sample assembled and co-assembled from unmapped reads
cat ${Contigs}/*.fa ${unmapped}/unmapped_megahit/final.contigs.fa > ${Assembly}/allSample500.final_contigs.fasta

#get time end the job
echo "Job finished at:" `date`