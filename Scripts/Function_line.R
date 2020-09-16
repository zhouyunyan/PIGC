#Number of shared function items at different frequency thresholds for the number of KEGG orthologues, KEGG pathways, CAZy family, and eggNOG orthologues.

###Import data from Function_Freq.xlsx
#sheet1:data1
data1<- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 
#sheet2:data2
data2 <- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 

library(reshape2)
data1_melt <- melt(data1,id.vars = "Sample_num")
data2_melt <- melt(data2,id.vars = "Sample_percent")

data2_melt$absolute <- data1_melt$value
data2_melt$variable <- factor(data2_melt$variable,levels = c("KO","KEGG pathway","CAZy family","eggNOG ortholog"))
data2_melt$value <- data2_melt$value*100
data2_melt$percent <- paste(round(data2_melt$value,digits = 0),"%",sep = "")

library(ggplot2)
library(ggrepel) 
tiff(filename = "Function_line.tif",width = 2300,height = 2300,res=600,compression="lzw")
ggplot(data2_melt,aes(x=Sample_percent,y=value,colour=variable,group=variable))+
  geom_line() +
  geom_point() +
  labs(x="The proportion of samples (%)",y="The proportion of shared items (%)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.background = element_rect(color = "black"),
        legend.position=c(0.23,0.15),
        #legend.key = element_rect(fill = NULL,colour = NULL),
        legend.title = element_blank(),
        legend.text = element_text(size = 8,color="black"),
        legend.key.height=unit(0.4, "cm"),
        axis.title.y = element_text(size = 12,color="black"),
        axis.title.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 11,color="black"),
        axis.text.x = element_text(size = 11,color="black")) +
  geom_vline(aes(xintercept = 0),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 20),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 50),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 90),linetype="dashed",colour="grey")+
  geom_vline(aes(xintercept = 100),linetype="dashed",colour="grey") +
  scale_x_continuous(breaks = c(0,20,50,90,100)) + 
  geom_text_repel(aes(label=paste(absolute,"(",percent,")",sep = "")),size = 2.6)
dev.off()
