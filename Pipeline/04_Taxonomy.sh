#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 04_Taxonomy

##############Part4 Taxonomic annotation###########################
diamond=~/bin/diamond
basta=~/basta
Database=~/Database
GeneCatalog=./03_Gene_Catalog
Taxonomy=./04_Taxonomy

#make Uniprot TrEMBL database
diamond makedb --in ${Database}/uniprot/uniprot_trembl.fasta.gz -d ${Database}/uniprot/uniprot_trembl

#aligning protein sequence of gene catalog to the Uniprot TrEMBL database
${diamond} blastp -q ${GeneCatalog}/02_cdhit_cluster/total.protein.faa.90 -d ${Database}/uniprot/uniprot_trembl.dmnd -t tmp -p 8 -e 1e-5 -k 50 --id 30 --sensitive -o ${Taxonomy}/total.protein.faa.90.diamond2uniprot_trembl    

#taxonomic classification based on the LCA algorithms
${basta} sequence -l 25 -i 80 -e 0.00001 -m 3 -b 1 -p 60 ${Taxonomy}/total.protein.faa.90.diamond2uniprot_trembl ${Taxonomy}/PIGC90.diamond2uniprot_trembl.dmnd.lca.out ${Database}/basta/uniprot

#get time end the job
echo "Job finished at:" `date`
