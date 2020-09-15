#!/bin/bash

# Kill script if any commands fail
set -e
echo "Job Start at `date`"

mkdir 03_Binning 04_dRep 05_Taxonomy 06_Genome_annotation 07_MAG_quant

##############Part3 Binning: Contigs to MAGs###########################
##use several modules of metawrap pipeline
CleanData=./01_CleanData
Contigs=./02_Assembly/Contigs
Binning=./03_Binning

mkdir ${Binning}/${SampleID}
cd ${Binning}/${SampleID}
mkdir INITIAL_BINNING BIN_REFINEMENT BIN_REASSEMBLY

source activate ~/miniconda3/envs/metawrap-env/

#binning with two different algorithms with the Binning module
metawrap binning -o INITIAL_BINNING -t 20 -a ../../${Contigs}/${SampleID}.fa --metabat2 --maxbin2 --universal /

#Consolidate bin sets with the Bin_refinement module
metawrap bin_refinement -o BIN_REFINEMENT -t 4 -A INITIAL_BINNING/metabat2_bins/ -B INITIAL_BINNING/maxbin2_bins/  -c 50 -x 10 --quick

#Re-assemble the consolidated bin set with the Reassemble_bins module
metawrap reassemble_bins -o BIN_REASSEMBLY \
-1 ${CleanData}/${SampleID}_final_R1.fastq \
-2 ${CleanData}/${SampleID}_final_R2.fastq \
-t 16 \
-m 200 \
-c 50 \
-x 10 \
-b BIN_REFINEMENT/metawrap_50_10_bins

conda deactivate

#rename bin name:prefix SampleID
for i in $(ls *.fa);do mv $i ${SampleID}_${i};done

#return to initial directory
cd ../../

##############Part4 MAG de-replication###########################
Binning=./03_Binning
mkdir ${Binning}/MAG_Fasta
MAGs=./${Binning}/MAG_Fasta
dRep=~/bin/dRep

mkdir ./04_dRep/dRep/dRep99 ./04_dRep/dRep/dRep95
dRep99=./04_dRep/dRep/dRep99
dRep95=./04_dRep/dRep/dRep95

#copy all fasta file of MAG to target directory
cp ${Binning}/${SampleID}/*.fa ${MAG}

#MAG de-replicate
${dRep} dereplicate ${dRep99} -g ${MAGs}/*.fa -p 16 -d -comp 50 -con 5 -nc 0.25 -pa 0.9 -sa 0.99
${dRep} cluster ${dRep95} -p 16 -nc 0.25 -pa 0.9 -sa 0.95 -g ${MAGs}/*.fa


##############Part5 Taxonomic classification and phylogenetic analysis###########################
phylophlan=~/bin/phylophlan.py
gtdbtk=~/bin/gtdbtk
genomes=./04_dRep/dRep/dRep99/dereplicated_genomes
Taxonomy=./05_Taxonomy

cd ${Taxonomy}
mkdir gtdbtk phylophlan

###Taxonomic classification
$gtdbtk classify_wf --cpus 16 --out_dir gtdbtk --genome_dir ../${genomes} --extension fa

###Phylogenetic analysis
$phylophlan -i ../${genomes} -d ${phylophlan} --diversity high -f ${cfg} --accurate -o ${OUTPUT} --nproc 8

cd ../

##############Part6 Genome annotation###########################
genomes=./04_MAG_de-replication/dereplicated_genomes
prokka_Result=./06_Genome_annotation
mkdir ./06_Genome_annotation/genomes_protein

source activate ~/miniconda3/envs/prokka_env/

for i in $(ls ${genomes}/*.fa)
do
file=${i##*/}
ID=${file%.*}
prokka $i --prefix $ID --metagenome --kingdom Bacteria --outdir ${prokka_Result}
done

conda deactivate 


##############Part7 MAG abundance ###########################
CleanData=./01_CleanData
allContigs=./02_Assembly/allSample500.final_contigs.fasta
genomes=./04_dRep/dRep/dRep99/dereplicated_genomes
MAG_quant=./07_MAG_quant

source activate ~/miniconda3/envs/metawrap-env/

metawrap quant_bins -b ${genome} -o ${MAG_quant} -a ${allContigs} ${CleanData}/*.fastq -t 16

conda deactivate

#get time end the job
echo "Job finished at:" `date`