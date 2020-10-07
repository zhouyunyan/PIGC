#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 03_Gene_Catalog

##############Part3 Construction of the gene catalog###########################
CleanData=./01_CleanData
Assembly=./02_Assembly
GeneCatalog=./03_Gene_Catalog
Scripts=~/Scripts
PGC=./03_Gene_Catalog/PGC
prodigal=~/bin/prodigal
cdhit=~/bin/cdhit

cd ${GeneCatalog}
mkdir 01_before_cdhit 02_cdhit_cluster 03_Gene_abundance

###gene prediction
cd 01_before_cdhit
#gene prediction of 500 samples
${prodigal} -a allSample500_protein.faa -d allSample500_nucl.fna -o allSample500_gff -p meta -i ../../${Assembly}/allSample500.final_contigs.fasta

#extract protein sequence of complete genes from 500 samples
bash ${Scripts}/Sample500_gene_info_deal.sh allSample500_protein.faa

cd ../../PGC
#extract protein sequence of complete genes from PGC
bash ${Scripts}/BGI287_gene_info_deal.sh 287sample_7.7M.GeneSet.pep.faa

cd ../../
#merge protein sequence of complete genes from PGC and 500 samples in current study
cat ${PGC}/filter.287sample_7.7M.GeneSet.pep.faa ${GeneCatalog}/01_before_cdhit/filter.allSample500_protein.faa >${GeneCatalog}/01_before_cdhit/sample500_BGI287_complete_protein.faa

faa=${GeneCatalog}/01_before_cdhit/sample500_BGI287_complete_protein.faa
cd ${GeneCatalog}/02_cdhit_cluster/
###dereplication at protein level (identity:100%-90%-50%)
$cdhit -i ${faa} -o total.protein.faa.100 -c 1.00 -n 5 -M 80000 -d 0 -T 16 && \
     cd-hit -i total.protein.faa.100 -o total.protein.faa.90 -c 0.90 -s 0.8 -n 5 -M 80000 -g 1 -d 0 -T 16 && \
     cd-hit -i total.protein.faa.90 -o total.protein.faa.50 -c 0.5 -s 0.8 -n 3 -M 80000 -g 1 -d 0 -T 16        

cat total.protein.faa.90|grep "^>"|awk -F ' ' '{print $1}'|awk -F '>' '{print $2}' >PIGC90_geneID.list

#extract the nucleotide sequence corresponding to a protein sequence of PIGC90 by sequence ID
perl ${Scripts}/extract_fabyid.pl PIGC90_cds.fna PIGC90_geneID.list ../01_before_cdhit/sample500_BGI287_before_redundancy_nofilter_cds.fna

#return to initial directory
cd ../../

#get time end the job
echo "Job finished at:" `date`

