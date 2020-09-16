
###Phylogenetic tree of bacteria 

library(ggplot2)
library(ggtree)
tree <- read.tree("bacteria_data.tre.treefile")
data1 <- read.table("Bacteria_sig_SGB.txt",header=T,sep="\t",check.names=F,stringsAsFactors = F)

group_file <- as.data.frame(data1[,3])
rownames(group_file) <- data1$new_MAGID
names(group_file) <- "Group"
## group by SGB
groupInfo <- split(row.names(group_file),group_file$Group)

tree$tip.label <- data1$new_MAGID[match(tree$tip.label,data1$genome)] 

# add group information to tree
tree <- groupOTU(tree, groupInfo)

tree_plot <-ggtree(tree,layout = "rectangular",branch.length="none",aes(color=group)) + 
  theme(legend.position = "none")+
  geom_point2(aes(subset=isTip), size=1.5) + 
  xlim(0,50)+  
  geom_tiplab(aes(angle=0),align = F,hjust=-0.1,color="black",fontface="bold",size=2) 

# tiff(filename = "Boar_Duroc_sig_Barteria_tree.tif",width = 800,height = 4500,res=600,compression="lzw")
# tree_plot
# dev.off()

#get the order of tip
tip_num <-tree_plot$data$y[1:nrow(data1)]
tip_label<- tree_plot$data$label[1:nrow(data1)]
tip_label_order <- tip_label[order(tip_num,decreasing=T)]

#significant different MAG between Wild boar and Duroc
sig <- read.table("sig_Wild_Duroc_SGB.xls",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
sig_MAG <-rownames(sig)[-which(sig$SGB_cluster %in% c("1011_1","1502_1"))]

#bar plot
enrich <- rep("NA",length(tip_label_order))
enrich[which(tip_label_order %in% sig_MAG)] <- 1
enrich[which(!(tip_label_order %in% sig_MAG))] <- 0
enrich <- as.numeric(enrich)
Duroc_MAG <- rownames(sig)[which(sig$`Duroc-JY  vs. Wild`=="Duroc-JY" & !(sig$SGB_cluster %in% c("1011_1","1502_1")))]
enrich[which(tip_label_order %in% Duroc_MAG)] <- -1
enrich_data <- as.data.frame(cbind(tip_label_order,enrich))
names(enrich_data) <- c("MAG_ID","value")
enrich_data$MAG_ID <- factor(enrich_data$MAG_ID,levels = enrich_data$MAG_ID)

p_bar <- ggplot(data = enrich_data, mapping = aes(x = 1,y=MAG_ID)) + 
  geom_tile(aes(fill = as.factor(value)))+
  scale_fill_manual(values=c("red","lightgrey","blue"))+
  guides(fill = FALSE) +
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.border = element_blank(), 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks = element_blank())

library(aplot)
tiff(filename = "Boar_Duroc_sig_Barteria_tree_bar.tif",width = 900,height = 4500,res=600,compression="lzw")
p_bar %>% insert_left(tree_plot,width =3)
dev.off()

###heatmap
data <- read.table("WB_Duroc_MAG_abundance.txt",header=T,row.names=1,sep="\t",check.names=F)
sig_MAG_data <- data[,which(names(data) %in% sig_MAG)]
sig_MAG_data <- sig_MAG_data[,as.character(enrich_data$MAG_ID[which(tip_label_order %in% sig_MAG)])] #MAGÖØÐÂÅÅÐò
sig_MAG_data <- as.data.frame(t(sig_MAG_data))


# group MAG by SGB
MAG_group <- as.data.frame(group_file[which(rownames(group_file) %in% sig_MAG),])
rownames(MAG_group) <- rownames(group_file)[which(rownames(group_file) %in% sig_MAG)]
names(MAG_group) <- "SGB"

#sample group
Sample_group <- as.data.frame(data$Group)
rownames(Sample_group) <- rownames(data)
names(Sample_group) <- "Group"
Sample_group$Group <- factor(Sample_group$Group,levels = c("Wild Boar","Duroc-JY","Duroc-SH"))

library(pheatmap)
tiff(filename = "Boar_Duroc_sig_heatmap.tif",width = 4200,height = 4000,res=600,compression="lzw")
pheatmap(sig_MAG_data,scale = "row",color = colorRampPalette(rev(c("red","white","blue")))(102),
         cluster_rows =F,cluster_cols =F,
         border_color=NA,annotation_legend=F,
         annotation_row = MAG_group,annotation_col =Sample_group)
dev.off()

#######Phylogenetic tre of Archaea
library(ggplot2)
library(ggtree)
tree <- read.tree("archaea_data.tre.treefile")
data1 <- read.delim("Archaea_sig_SGB.txt",header=T,sep="\t",check.names=F,stringsAsFactors = F) 

tree$tip.label <- data1$new_MAGID[match(tree$tip.label,data1$genome)] 

tree_plot <-ggtree(tree,layout = "rectangular",branch.length="none") + 
  theme(legend.position = "none")+
  geom_point2(aes(subset=isTip), size=1) + 
  xlim(0,50)+  
  geom_tiplab(aes(angle=0),align = F,hjust=-0.1,color="black",fontface="bold",size=2) 


# tiff(filename = "Boar_Duroc_sig_Archaea_tree.tif",width = 800,height = 1800,res=600,compression="lzw")
# tree_plot
# dev.off()

#get the order of tip
tip_num <-tree_plot$data$y[1:nrow(data1)]
tip_label<- tree_plot$data$label[1:nrow(data1)]
tip_label_order <- tip_label[order(tip_num,decreasing=T)]

#significant different MAG between Wild boar and Duroc
sig <- read.table("sig_Wild_Duroc_SGB.xls",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
sig_MAG <-rownames(sig)[which(sig$SGB_cluster=="1502_1")]

#bar plot
enrich <- rep("NA",length(tip_label_order))
enrich[which(tip_label_order %in% sig_MAG)] <- 1
enrich[which(!(tip_label_order %in% sig_MAG))] <- 0
enrich <- as.numeric(enrich)
Duroc_MAG <- rownames(sig)[which(sig$`Duroc-JY  vs. Wild`=="Duroc-JY" & (sig$SGB_cluster=="1502_1"))]
enrich[which(tip_label_order %in% Duroc_MAG)] <- -1
enrich_data <- as.data.frame(cbind(tip_label_order,enrich))
names(enrich_data) <- c("MAG_ID","value")
enrich_data$MAG_ID <- factor(enrich_data$MAG_ID,levels = enrich_data$MAG_ID)

p_bar <- ggplot(data = enrich_data, mapping = aes(x = 1,y=MAG_ID)) + 
  geom_tile(aes(fill = as.factor(value)))+
  scale_fill_manual(values=c("red","lightgrey","blue"))+
  guides(fill = FALSE) +
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.border = element_blank(), 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks = element_blank())

library(aplot)
tiff(filename = "Boar_Duroc_sig_Archaea_tree_bar.tif",width = 650,height = 1800,res=600,compression="lzw")
p_bar %>% insert_left(tree_plot,width =3)
dev.off()


#boxplot
sig <- read.table("sig_Wild_Duroc_SGB.xls",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
sig_MAG <-rownames(sig)[which(sig$SGB_cluster=="1502_1")]

data <- read.table("WB_Duroc_MAG_abundance.txt",header=T,row.names=1,sep="\t",check.names=F,stringsAsFactors = F)
sig_Wild_Duroc <- data[,which(names(data) %in% sig_MAG)]
sig_Wild_Duroc$ID <- rownames(sig_Wild_Duroc)
sig_Wild_Duroc$Sample_group <- data$Group
library(reshape2)
melt.data <- melt(sig_Wild_Duroc,id.vars = c("ID","Sample_group"))
melt.data$Sample_group <- factor(melt.data$Sample_group,levels = c("Wild Boar","Duroc-JY","Duroc-SH"))
library(ggpubr)
my_comparisons <- list(c("Wild Boar","Duroc-JY"),c("Wild Boar","Duroc-SH"))

p1 <- ggboxplot(melt.data[1:126,], x="Sample_group", y="value", fill = "Sample_group",
               palette = "jco", xlab = F,ylab = "",facet.by = "variable") +
  stat_compare_means(comparisons=my_comparisons,label = "p.signif")+
  theme(axis.title.y = element_text(size = 15,color="black"),
        panel.background = element_rect(color = "black"),
        axis.text.x = element_text(angle = 45,size = 10,color="black",hjust = 1,vjust = 1))+
  guides(fill = FALSE)+
  ylim(0,7.2)

p2 <- ggboxplot(melt.data[127:252,], x="Sample_group", y="value", fill = "Sample_group",
                palette = "jco", xlab = F,ylab = "",facet.by = "variable") +
  stat_compare_means(comparisons=my_comparisons,label = "p.signif")+
  theme(axis.title.y = element_text(size = 15,color="black"),
        panel.background = element_rect(color = "black"),
        axis.text.x = element_text(angle = 45,size = 10,color="black",hjust = 1,vjust = 1))+
  guides(fill = FALSE)+
  ylim(0,3.8)

tiff(filename = "Archaea_Boar_Duroc_boxplot1.tif",width = 2000,height = 1600,res=600,compression="lzw")
p1
dev.off()
tiff(filename = "Archaea_Boar_Duroc_boxplot2.tif",width = 2000,height = 1600,res=600,compression="lzw")
p2
dev.off()
