###Import data from PIGC_Uniprot.xlsx
#sheet:data1
data1<- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 
#sheet:data2
data2 <- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 

library(reshape2)
data1_melt <- melt(data1,id.vars = "Item")
data2_melt <- melt(data2,id.vars = "Item")

data2_melt$value <- data2_melt$value*100
data2_melt$absolute <- prettyNum(data1_melt$value,big.mark = ",")
data2_melt$Item <- factor(data2_melt$Item,levels = c("Predicted genes (unique)","Known protein (unique)","Known taxa (unique)"))
data2_melt$percent <- paste(round(data2_melt$value,digits = 0),"%",sep = "")
  
library(ggplot2)
library(ggrepel) 
tiff(filename = "PIGC_compare_line.tif",width = 2300,height = 2300,res=600,compression="lzw")
ggplot(data2_melt,aes(x=variable,y=value,colour=Item,group=Item))+
  geom_line() +
  geom_point() +
  labs(x="",y="The proportion of each item in PIGC100 (%)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        legend.position=c(0.28,0.11),
        legend.title = element_blank(),
        legend.text = element_text(size = 8,color="black"),
        legend.key.height=unit(0.4, "cm"),
        axis.title.y = element_text(size = 12,color="black"),
        axis.title.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 11,color="black"),
        axis.text.x = element_text(size = 11,color="black")) +
        #axis.text.x = element_text(size = 11,color="black",angle = 30,vjust = 1,hjust = 1))+
  geom_text_repel(aes(label=paste(absolute,"(",percent,")",sep = "")),size = 2.6)
dev.off()


#####The number and percentage of genes that be classified to different levels in PIGC90.
###Import data from PIGC_Uniprot.xlsx
#sheet: taxa
data<- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 
names(data)[2] <- "gene_num"
data$percent <- round(data$gene_num*100/17237052,digits = 0)
data$label <- paste(round(data$gene_num*100/17237052,digits = 1),"%",sep = "")
data$gene_num <- prettyNum(data$gene_num,big.mark = ",")
data$PIGC90 <- factor(data$PIGC90,levels = c("Kingdom","Phylum","Class","Order","Family","Genus","Species"))
library(ggplot2)
library(ggrepel) 
tiff(filename = "percent_known_taxa.tif",width = 2500,height = 2500,res=600,compression="lzw")
ggplot(data,aes(x=PIGC90,y=percent,group=1))+
  geom_line() +
  geom_point()+
  labs(x="",y="The proportion of classified genes (%)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        legend.position=c(0.28,0.11),
        legend.title = element_blank(),
        legend.text = element_text(size = 8,color="black"),
        legend.key.height=unit(0.4, "cm"),
        axis.title.y = element_text(size = 12,color="black"),
        axis.title.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 11,color="black"),
        axis.text.x = element_text(size = 11,color="black",angle = 45,vjust = 1,hjust = 1)) +
  geom_text_repel(aes(label=paste(gene_num,"(",label,")",sep = "")),size = 2.6)
dev.off()  
  
