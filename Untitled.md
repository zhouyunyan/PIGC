# The construction of reference gene catalog and metagenome-assembled genomes of pig gut microbiome.

This directory contains scripts related to the manuscript "A landscape deep metagenome survey of swine gut microbiome spanning age, geography, domestication and gut locations reveals an extensive number of microbial genes and assembled genomes". There are two main parts in the pipeline, the construction of the gene catalog and metagenome-assembled genomes. The processes before assembly are same. 

Before running,you must ensure that all required softwares and databases are installed successfully. 

## INSTALLATION

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

Note:The version is only the version used in the paper and does not have to be the same,  and some softwares are included in other software, so you don't have to install it repeatedly. For example, bwa, bowtie2, Samtools and MEGAHIT are included in metawrap. 

### Database installation

The name,description and availavlity of the database are as follows: 

|Database|Version/release date|Description|Availability|
|:-------|:-------------------|:----------|:-----------|
|Uniprot TrEMBL|version 2020_03|protein database|https://www.uniprot.org/downloads|
|KEGG|2019/12/20|KEGG annotation|http://kobas.cbi.pku.edu.cn/kobas3/download/|
|dbCAN|HMMdb-V8|CAZymes annotation|http://bcb.unl.edu/dbCAN2/download/|
|EggNOG|EggNOG5.0|EggNOG annotation|http://eggnog5.embl.de/#/app/downloads|
|CARD|v3.1.0|Antibiotic Resistance genes annotation|https://github.com/arpcard/rgi#install-dependencies|
|VFDB|Fri Sep 4 10:06:01 2020|Virulence factors annotation|http://www.mgc.ac.cn/VFs/download.htm|
|GTDB-tk|release89|Taxonomic assignments of MAGs|https://gtdb.ecogenomic.org/downloads|
|PhyloPhlAn|2013|phylogenetic analysis of MAGs|https://github.com/biobakery/phylophlan/wiki| 

Note: The version are only the version used in the paper,most of database are constantly updated.


```python

```
