table <- read.table("NetData_mapping.txt",header = T,sep = "\t",stringsAsFactors = F)

library(reshape2)
table_melt <-melt(table,id.vars = c("SampleID","Group"))
table_melt$value <- table_melt$value*100
table_melt$variable <- factor(table_melt$variable, levels = c("PIGC90","PGC90"))
table_melt$Group <- factor(table_melt$Group,levels = unique(table$Group))

library(ggpubr)
tiff(filename = "NetData_mapping_ratio.tif",width = 2500,height = 2000,res=600,compression="lzw")
ggboxplot(table_melt, x="Group", y="value", fill = "variable",
          palette = "jco", xlab = "Datastes from different studies",ylab = "reads mapped to catalog (%)") +
  theme(panel.background = element_rect(color = "black"),
        axis.title.y = element_text(size = 13,color="black"),
        axis.title.x = element_text(size = 13,color="black"),
        axis.text.y = element_text(size = 12,color="black"),
        axis.text.x = element_text(size = 12,color="black"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.position = c(0.18,0.15))
dev.off()
