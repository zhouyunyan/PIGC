#calculate the abundance of Antibiotic Resistance Ontology (ARO)
card_anno <- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors=F) #Gene2CARD_anno.txt
card_fpkm <- read.table("anno2CARD_gene_fpkm.txt",header = T,sep = "\t",check.names = F,stringsAsFactors = F)

library(plyr)
##ARO level
card<- merge(card_anno[,1:2],card_fpkm,by.x = "ORF_ID", by.y = "Geneid")
ARO <- ddply(card,"Best_Hit_ARO",numcolwise(sum))
names(ARO)[1] <- "ARO_name"
write.table(ARO,file = "CARD_ARO_fpkm.txt",row.names = F,sep = "\t",quote = F)


