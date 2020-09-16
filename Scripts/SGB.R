###The nuber of species-level genome bins (SGBs) and the percent of unknown SGB (uSGB) in each phyla. 

#bar plot 
Result <- read.table("Phylum.SGB.bin.stat.xls",header = T,check.names = F,sep = "\t")
uSGB_percent <- round(Result$uSGB*100/Result$SGB,digits = 0)
Result$uSGB_percent <- uSGB_percent
library(ggplot2)
library(reshape2)
SGB.data.melt <- melt(Result[,2:7],id.vars = "Phylum.ID")
SGB.data.melt$Phylum.ID <- factor(SGB.data.melt$Phylum.ID,levels = Result$Phylum.ID)
SGB_bar <- ggplot(SGB.data.melt[which(SGB.data.melt$variable=="SGB"),],aes(x=Phylum.ID,y=value,fill=variable))+
  geom_bar(stat = "identity")+
  labs(x = NULL, y = NULL) +
  theme_bw()+
  geom_text(aes(label=value,y=value+55),position=position_stack(vjust=1),size=3)+ 
  theme(panel.grid.major =element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        axis.text.x = element_text(colour="black",face="bold",angle = 90, hjust = 0,vjust = 1), 
        #axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        legend.title = element_blank(),
        legend.position = "none") 


uSGB_bar <- ggplot(SGB.data.melt[which(SGB.data.melt$variable=="uSGB_percent"),],aes(x=Phylum.ID,y=value,fill=variable))+
  geom_bar(stat = "identity",fill="lightblue")+
  labs(x = NULL, y = NULL) +
  theme_bw()+
  geom_text(aes(label=value,y=value+4),position=position_stack(vjust=1),size=3)+ 
  theme(panel.grid.major =element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        #axis.text.x = element_text(angle = 52, hjust = 1), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        legend.title = element_blank(),
        legend.position = "none") 

library(aplot)
tiff(filename = "Phylum_SGB.tif",width = 3000,height = 3000,res=600,compression="lzw")
uSGB_bar %>% insert_bottom(SGB_bar) 
dev.off()

