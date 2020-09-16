###The frequency of genes in 500 samples
data1<- read.table("gene_Freq.xls",head=T,check.names = F)
data1$gene_num <- prettyNum(data1$gene_num,big.mark = ",")
data1$label <- rep("NA",6)
data1$label[1:5] <- paste(round(data1$gene_percent[1:5],digits = 1),"%",sep = "")
data1$label[6] <- paste(round(data1$gene_percent[6],digits = 3),"%",sep = "")

library(ggplot2)
library(ggrepel) 
tiff(filename = "percent_gene_Freq.tif",width = 2500,height = 2200,res=600,compression="lzw")
ggplot(data1[-2,],aes(x=Sample_percent,y=gene_percent,group=1))+
  geom_line() +
  geom_point()+
  labs(x="The proportion of samples (%)",y="The proportion of genes (%)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.background = element_rect(color = "black"),
        axis.title.y = element_text(size = 13,color="black"),
        axis.title.x = element_text(size = 13,color="black"),
        axis.text.y = element_text(size = 12,color="black"),
        axis.text.x = element_text(size = 12,color="black")) +
  geom_vline(aes(xintercept = 0),linetype="dashed",colour="grey")+
  #geom_vline(aes(xintercept = 0.2),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 20),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 50),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 90),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 100),linetype="dashed",colour="grey") +
  scale_x_continuous(breaks = c(0,20,50,90,100)) + 
  geom_text_repel(aes(label=paste(gene_num,"(",label,")",sep = "")),size = 2.6) 
dev.off()  


###The counts distribution of the abundance of genes. 
library(data.table)
data <- fread("gene_abundance_test.txt",head=T,check.names = F,sep = "\t")
Average <- data$Average
j=0
range <- rep(NA,51) 
counts <- rep(NA,51)
for (i in 1:50){
  counts[i]<- length(Average[(Average>j) & (Average<= j+0.004)])
  range[i] <- paste(j,j+0.004,sep="~")
  j=j+0.004
}
counts[51] <- length(which(Average>0.2))
range[51] <- ">0.2"
table <- cbind(range,counts)
write.table(table,file="AbunRange.genenum.step0.004.txt",sep="\t",quote=F)

table <- read.table("AbunRange.genenum.step0.004.txt",header=T,check.names = F,stringsAsFactors = F)
table$group <- rep(NA,nrow(table))
mean <- mean(data$Average)
mean
#[1] 0.07538235
range[19]
#[1] "0.072~0.076"
table$group[1:18] <- "Low abundance"
table$group[19] <- "Average abundance"
table$group[20:51] <- "High abundance"
table$group <- factor(table$group,levels=c("Low abundance","Average abundance","High abundance"))
table$range <- factor(table$range,levels=table$range)
table$counts <- table$counts/1000000
library(ggplot2)
tiff(filename = "rangeAbun.geneNum.tif",width = 2500,height = 2000,res=600,compression="lzw")
ggplot(table,aes(x = range,y=counts,fill=group))+
  geom_bar(stat="identity")+
  labs(x="Average abundance (fpkm) of genes in 500 samples",y="Gene numbers (¡Á1,000,0000)") +
  #xlim(0,0.2)+
  theme_bw()+
  #scale_x_continuous(breaks = c(0.00, 0.05, 0.10, 0.15, 0.20),labels = c(0.00, 0.05, 0.10, 0.15, ">0.20"))+
  scale_fill_manual(values = c("#619CFF","#F8766D","#00BA38"))+
  theme(panel.grid.major = element_line(colour = NA),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(color = "black"),
        axis.title.y = element_text(size = 9,color="black"),
        axis.title.x = element_text(size = 9,color="black"),
        axis.text.y = element_text(size = 8,color="black"),
        axis.text.x = element_text(size = 6,color="black",angle = 90),
        legend.title = element_blank(),
        legend.text = element_text(size = 8),
        legend.position = c(0.8,0.86),
        legend.key.size = unit(10, "pt"))
dev.off()