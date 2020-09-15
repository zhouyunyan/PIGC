#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 05_Function

##############Part5 Functional annotation###########################
cdhit=./03_Gene_Catalog/02_cdhit_cluster/
Database=~/Database
faa=total.protein.faa.90
Function=./05_Function
temp=./temp

diamond=~/bin/diamond
kobas=~/bin/kobas-annotate
emapper=~/bin/emapper.py
hmmscan=~/bin/hmmscan
rgi=~/bin/rgi
blastp=~/bin/blastp

cd ${Function}
mkdir KEGG eggNOG CAZy CARD VFDB

#KEGG
$diamond blastp --query ${cdhit}/$faa --db ${Database}/kegg/kegg.fasta.dmnd --out KEGG/$faa.kegg.dmnd --threads 6 --tmpdir /tmp --evalue 1e-5 --outfmt 6
$kobas -i KEGG/$faa.kegg.dmnd -n 6 -t blastout:tab -s ko -k ${Database}/kegg/kobas-3.0/ -o KEGG/$faa.kegg.annot

#eggNOG
$emapper -i ${cdhit}/$faa --temp_dir ${temp} \
                --dmnd_db eggnog_proteins.dmnd --data_dir ${Database} \
                -o eggNOG/$(basename $faa).eggout \
                --cpu 6 --matrix BLOSUM62 \
                --seed_ortholog_evalue 1e-5 --keep_mapping_files \
                --dbtype seqdb -m diamond

#CAZy
$hmmscan -o CAZy/$faa.dbcan --tblout CAZy/$faa.dbcan.tab -E 1e-5 --cpu 6 ${Database}/dbCAN/dbCAN-HMMdb-V8.txt ${cdhit}/$faa

#CARD
$rgi main -i ${cdhit}/$faa -o CARD/$faa.card -n 6 --debug -t protein -a DIAMOND --clean

#VFDB
$blastp -query ${cdhit}/$faa -db ${Database}/VFDB/VFDB_setB_pro.fas -out VFDB/$faa.vfdb.tab -evalue 1e-5 -outfmt 6 -num_threads 6 -num_alignments 5 

#get time end the job
echo "Job finished at:" `date`