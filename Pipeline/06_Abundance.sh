#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 06_Abundance

##############Part6 Abundance estimation###########################
GeneCatalog=./03_Gene_Catalog
Abundance=./06_Abundance
bwa=~/bin/bwa
samtools=~/bin/samtools
featureCounts=./featureCounts
temp=./temp

cd ${Abundance}
mkdir Gene KEGG eggNOG CAZy CARD VFDB

###Gene abundance
cd Gene
SAF=./06_Abundance/PIGC90_cds.fna.saf
mkdir sam sort_bam flagstat abundance
bwa mem -M -Y -t 8 -o sam/${SampleID}.sam ${GeneCatalog}/02_cdhit_cluster/PIGC90_cds.fna ${CleanData}/${SampleID}.clean_R1.fastq.gz ${CleanData}/${SampleID}.clean_R1.fastq.gz
samtools sort -@ 8 -o sort_bam/${SampleID}.sort.bam sam/${SampleID}.sam && \
     samtools flagstat -@ 8 sort_bam/${SampleID}.sort.bam > flagstat/${SampleID}.flagstat

#counts	 
featureCounts -T 8 -p -a $SAF -F SAF --tmpDir ../../${temp} -o abundance/${SampleID}.counts sort_bam/${SampleID}.sort.bam

#fpkm					
total_counts=$(cat abundance/${SampleID}.counts | grep -v -w '^Geneid' | awk '{a+=$NF}END{print a}')
awk -v "counts=$total_counts" '{if(NR>1){print $1"\t"1000000*1000*$NF/($(NF-1)*counts)}else{print $1"\t"$NF}}' abundance/${SampleID}.counts > abundance/${SampleID}.fpkm.txt 
#merge all samples
paste -d '\t' abundance/*.fpkm.txt >abundance/sample500.fpkm.txt

#return to initial directory
cd ../../

#get time end the job
echo "Job finished at:" `date`

###function abundance were performed with R scripts 
#KEGG Orthology (KO), eggNOG Orthology, CAZyme family, Antibiotic Resistance Ontology (ARO), and Virulence Factors (VF) were calculatedby adding the abundances of all its members falling within each category.

