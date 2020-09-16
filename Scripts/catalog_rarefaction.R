data <- read.table("rarefaction.result.txt",header = T,check.names = F,sep = "\t")
start <- c(0,0)
data <- data.frame(rbind(start,data))
data$Result <- data$Result/1000000
library(ggplot2)
tiff(filename = "catalog_rarefaction.tif",width = 2200,height = 2000,res=600,compression="lzw")
ggplot(data,aes(x=num,y=Result,group=1))+
  geom_line() +
  #geom_point() +
  guides(color=F,size=F)+
  labs(x="Sample size",y="Gene numbers (¡Á1,000,000)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.background = element_rect(color = "black"),
        axis.title.y = element_text(size = 12,color="black"),
        axis.title.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 11,color="black"),
        axis.text.x = element_text(size = 11,color="black"),
        plot.margin = unit(c(0.2, 0.3, 0.2, 0.2), "cm")) 
dev.off()
