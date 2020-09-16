# The construction of reference gene catalog and metagenome-assembled genomes of pig gut microbiome.

This directory contains scripts related to the manuscript "A landscape deep metagenome survey of swine gut microbiome spanning age, geography, domestication and gut locations reveals an extensive number of microbial genes and assembled genomes". 

Before running, you must ensure that all required softwares and databases are installed successfully. 

## INSTALLATION

Create two directories "bin" and "Database" in user home directory. 

### Software installation

The installation method refer to the manual of each software. The name, version and availablity of the software are as follows:  

|Software|Availability|
|:-----|:---------|
|fastp (v0.19.4)|https://github.com/OpenGene/fastp|
|bwa (v0.7.17-r1188)|https://github.com/lh3/bwa|
|Samtools (v1.10)|https://github.com/samtools/samtools/releases/|
|bedtools (v2.28.0)|https://bedtools.readthedocs.io/en/latest/|
|MEGAHIT (v1.1.3)|https://github.com/voutcn/megahit|
|Bowtie 2 (v2.3.4.1)|https://anaconda.org/bioconda/bowtie2|
|Prodigal (v2.6)|https://github.com/hyattpd/Prodigal|
|CD-HIT (v4.8.1)|https://github.com/weizhongli/cdhit/releases|
|featurecount (v2.0.1)|http://bioinf.wehi.edu.au/featureCounts/|
|diamond (v0.9.21.122)|http://www.diamondsearch.org/index.php|
|BASTA (v1.3)|https://github.com/timkahlke/BASTA|
|HMMER (v3.1b2)|http://hmmer.org/|
|BLAST (v2.10.1+)|ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/|
|KOBAS (v3.0.3)|http://kobas.cbi.pku.edu.cn/kobas3/download/|
|RGI (v5.1.1)|https://card.mcmaster.ca|
|eggnog-mapper (v2.0.1)|http://eggnog5.embl.de/|
|metawrap (v1.1.1)|https://github.com/bxlab/metaWRAP|
|dRep (v2.2.3)|https://github.com/MrOlm/drep|
|GTDB-tk (v1.3.0)|http://gtdb.ecogenomic.org/|
|PhyloPhlAn (v3.0.51)|https://github.com/biobakery/phylophlan| 

Note: Make all needed command of software availabled in the "~/bin" directory or in system environment variables.The version is only the version used in the paper and does not have to be the same,  and some softwares are included in other software, so you don't have to install it repeatedly. For example, bwa, bowtie2, Samtools and MEGAHIT are included in metawrap. 

### Database installation

All databases are stored in the "~/Datebase" directory. 

The name,description and availavlity of the database are as follows: 

|Database|Version/release date|Description|Availability|
|:-------|:-------------------|:----------|:-----------|
|Pig (Sscrofa11.1)|Sscrofa11.1|Pig reference genome|http://asia.ensembl.org/Sus_scrofa/Info/Index|
|Uniprot TrEMBL|version 2020_03|protein database|https://www.uniprot.org/downloads|
|KEGG|2019/12/20|KEGG annotation|http://kobas.cbi.pku.edu.cn/kobas3/download/|
|dbCAN|HMMdb-V8|CAZymes annotation|http://bcb.unl.edu/dbCAN2/download/|
|EggNOG|EggNOG5.0|EggNOG annotation|http://eggnog5.embl.de/#/app/downloads|
|CARD|v3.1.0|Antibiotic Resistance genes annotation|https://github.com/arpcard/rgi#install-dependencies|
|VFDB|Fri Sep 4 10:06:01 2020|Virulence factors annotation|http://www.mgc.ac.cn/VFs/download.htm|
|GTDB-tk|release89|Taxonomic assignments of MAGs|https://gtdb.ecogenomic.org/downloads|
|PhyloPhlAn|2013|phylogenetic analysis of MAGs|https://github.com/biobakery/phylophlan/wiki| 

Note: The version are only the version used in the paper,most of database are constantly updated.

## OVERVIEW OF PIPELINE

The scripts of metagenomic analysis are placed in "[Pipeline](https://github.com/zhouyunyan/PIGC/tree/master/Pipeline)" directory. There are two main modules in the pipeline, the construction of the gene catalog and metagenome-assembled genomes. The processes before assembly are same. 

### Shared steps between the construction of the gene catalog and metagenome-assembled genomes

#### Part1: 01_data_preprocessing.sh

Metagemonic data pre-processing: read trimming and host (pig) read removal,generating high-quality sequence. 

#### Part2: 02_Assembly.sh

Metagenomic assembly: Assemble short reads into long contigs.

### Construction of the gene catalog

A total of four scripts in this modules, including gene prediction, taxonomy annotation, function annotation and abundance estimation.

#### Part3: 03_Gene_Catalog.sh 

This part contains steps of gene prediction, filtration of incomplete genes, integration of gene catalog and gene dereplications.

#### Part4: 04_Taxonomy.sh 

The protein sequence of genes were aligned to Uniprot TrEMBL, and the taxonomic classification were determined based on the last (lowest) common ancestor algorithms.

#### Part5: 05_Function.sh

The KEGG Orthology and pathway, CAZymes family, EggNOG Orthology,antibiotic Resistance genes,and virulence factors annotation were performed by aligning the protein sequence to KEGG, dbCAN, EggNOG, CARD and VFDB databases.

#### Part6: 06_Abundance.sh

Gene abundance were caculated by aligning clean reads of each sample to the gene catalog to obtained the counts of mapped reads, and  normalized to read count fragments per kilobase million (FPKM). The abundance of function items were performed were calculated by adding the abundances of all its members falling within each category with R scripts. 

#### Part7: 07_genome_reconstruction.sh

The steps related to reconstruction of metagenome-assembled genomes (MAG) are included in this Part. Binning, refinement, reassembly, genome annotation and abundance estimation of MAGs were performed with the modules of metaWRAP pipeline. dRep software was used for dereplication of MAGs. And taxonomic classification and phylogenetic analysis were processed by GTDB-tk and PhyloPhlAn 3.0, respectively. 

### Statistical analysis and visualization

Some processing steps in the pipeline, statistical analysis and visualization were handled by scripting with R, Shell, Perl or Python languages. These scripts were placed in "[Scripts](https://github.com/zhouyunyan/PIGC/tree/master/Scripts)" directory. All related input data for statistical analysis and visualization are in ["Pre-processed_Files"](https://github.com/zhouyunyan/PIGC/tree/master/Pre-processed_Files) directory.


```python

```
