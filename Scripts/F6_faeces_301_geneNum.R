##Association of predicted gene number with the sequencing depth
data <- read.table("F6_faeces_301_geneNum.xls",header = T)

lm.data <-  lm(formula =data$gene_num ~ data$depth, data = data)
summary(lm.data)

library(ggplot2)
data$gene_num <- data$gene_num/1000

tiff(filename = "QH.D240.depth.GeneNum1.tif",width = 2500,height = 2000,res=600,compression="lzw")
ggplot(data,aes(depth,gene_num))+geom_point()+geom_smooth(method = "loess")+ 
  labs(x="Sequencing depth (Gb)",y="Gene numbers (¡Á 1000)",title="R^2 = 0.53, P < 2.2e-16") + 
  #labs(x="Sequencing depth (Gb)",y="Gene numbers (¡Á 1000)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
    axis.title.y = element_text(size = 15,color="black"),
    axis.title.x = element_text(size = 15,color="black"),
    axis.text.y = element_text(size = 12,color="black"),
    axis.text.x = element_text(size = 12,color="black"),
    plot.title = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position=c(0.85,0.15),
    legend.text = element_text(size = 8),
    legend.box.background = element_rect(color="grey", size=0.5))
dev.off()

