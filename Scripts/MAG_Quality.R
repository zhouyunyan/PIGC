data <- read.table("MAG_quality.txt",header = T,row.names = 1,sep = "\t",check.names = F,stringsAsFactors = F)

library(ggplot2)
library(ggsci)

##Completeness and Contamination
tiff(filename = "MAG_com_con.tif",width = 2000,height = 2000,res=600,compression="lzw")
ggplot(data,mapping = aes(x=Completeness,y=Contamination,colour=Quality))+
  geom_point(size=0.5)+
  labs(x="Completeness (%)",y="Contamination (%)") +
  ylim(0,6.2) +
  theme_bw() +
  theme(panel.grid.major = element_line(colour=NA),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.21,0.88),
        legend.text = element_text(size = 8))+
  scale_color_npg() +
  scale_fill_discrete(breaks=c("Medium-quality (4,978 MAGs;78.5% )","Near-complete (1,361 MAGs;21.5%)"))
dev.off()

##Contigs number
tiff(filename = "MAG_Contigs.tif",width = 2000,height = 2000,res=600,compression="lzw")
ggplot(data,aes(x = Contigs_num,fill = Quality))+
  geom_histogram(bins = 100)+
  labs(x="No. of contigs",y="Counts") +
  xlim(0,1000)+
  scale_color_npg() +
  theme_bw() +
  theme(panel.grid.major = element_line(colour=NA),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.75,0.88),
        legend.text = element_text(size = 8))
dev.off() 
  
##tRNA number
tiff(filename = "MAG_tRNA.tif",width = 2000,height = 2000,res=600,compression="lzw")
ggplot(data,aes(x = tRNA_num,fill = Quality))+
  geom_histogram(bins = 100)+
  labs(x="No. of tRNA",y="Counts") +
  xlim(0,100)+
  scale_color_npg() +
  theme_bw() +
  theme(panel.grid.major = element_line(colour=NA),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.75,0.88),
        legend.text = element_text(size = 8))
dev.off() 

