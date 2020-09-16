####Comparison of predicted gene number between high and low seqeuncing depth
table <- read.table("geneNum_12.4G_VS_6.2G.txt",header = T)

library(reshape2)
table_melt <-melt(table,id.vars = "ID")
table_melt$value <- table_melt$value/1000
table_melt$variable <- factor(table_melt$variable, levels = c("Base6.2G","Base12.4G"))

library(ggpubr)
tiff(filename = "depth_12.4G_VS_6.2G.tif",width = 2000,height = 2000,res=600,compression="lzw")
#paired compare
ggboxplot(table_melt, x="variable", y="value", fill = "variable",
          palette = "jco", add = "jitter",xlab = F,ylab = "Gene numbers (¡Á 1000)") +
  guides(fill = FALSE) +
  theme(panel.background = element_rect(color = "black"),
        axis.title.y = element_text(size = 14,color="black"),
        axis.text.y = element_text(size = 12,color="black"),
        axis.text.x = element_text(size = 12,color="black"))+
  scale_x_discrete(labels =c("Base12.4G"="12.4G","Base6.2G"="6.2G"))+
  stat_compare_means(label.x = 0.7)
dev.off()