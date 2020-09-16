#############Comparison of Species between Wild and Duroc#################
####Alpha diversity
library(readxl)
Alpha <- read.table("Alpha_index_2.csv",header = T, row.names = 1,check.names = F,sep = ",")
Wild_Duroc <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "Sample_info")

sub_Alpha <- Alpha[which(rownames(Alpha) %in% Wild_Duroc$SampleID),]
sub_Alpha$Group <- Wild_Duroc$Group
BD.compare <- list(c("Wild Boar","Duroc-JY"),c("Duroc-JY","Duroc-SH"),c("Wild Boar","Duroc-SH")) 

library(ggpubr)
# 1¡¢number
p1 <- ggboxplot(sub_Alpha, x="Group", y="Number",  fill  = "Group",palette = "jco") + 
  labs(y="Species numbers based on species profile",x=NULL) + 
  guides(fill=FALSE) +
  theme(legend.title=element_blank(),
        panel.background = element_rect(color = "black"),
        axis.text.x = element_text(color="black",angle = 30,vjust = 1,hjust = 1))+
  stat_compare_means(comparisons = BD.compare,aes(group=Group),label = "p.signif")

# 2¡¢Shannon index
p2 <- ggboxplot(sub_Alpha, x="Group", y="Shannon",  fill  = "Group",palette = "jco") + 
  labs(y="Shannon index based on species profile",x=NULL) + 
  guides(fill=FALSE) +
  theme(legend.title=element_blank(),
        panel.background = element_rect(color = "black"),
        axis.text.x = element_text(color="black",angle = 30,vjust = 1,hjust = 1))+
  stat_compare_means(comparisons = BD.compare,aes(group=Group),label = "p.signif")

#merge plot
tiff(filename = "Wild_Duroc_species_Alpha.tif",width = 2500,height = 2500,res=600,compression="lzw")
ggarrange(p1,p2,ncol=2,nrow=1)
dev.off()

##PCoA
data1 <- read.table("sample500_Bacteria_species_fpkm.xls",header = T, row.names = 1,check.names = F,sep = "\t")
Wild_Duroc <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "Sample_info")

sub_data <- data1[which(rownames(data1) %in% Wild_Duroc$SampleID),]
#remove species that are absent from the sample
sub_data <- sub_data[,which((colSums(sub_data)!=0))]

library(vegan)
distance <- vegdist(sub_data) #default: bray
pcoa = cmdscale(distance, k=3, eig=T) # k is dimension, 3 is recommended; eig is eigenvalues
points = as.data.frame(pcoa$points) # get coordinate string, format to dataframme
colnames(points) = c("pcoa1", "pcoa2", "pcoa3") 
eig = pcoa$eig
points$group <- factor(Wild_Duroc$Group,levels =  c("Wild Boar","Duroc-JY","Duroc-SH"))

tiff(filename = "Wild_Duroc.PCoA.tif",width = 2500,height = 2500,res=600,compression="lzw")
ggplot(points, aes(x=pcoa1, y=pcoa2, color=group)) +
  geom_point(alpha=.7, size=2) + 
  stat_ellipse(level = 0.9) +
  labs(x=paste("PCoA 1 (", format(100 * eig[1] / sum(eig), digits=4), "%)", sep=""),
       y=paste("PCoA 2 (", format(100 * eig[2] / sum(eig), digits=4), "%)", sep="")) + 
  #scale_fill_manual(values=c("red","green","blue"))+
  theme_bw() + 
  theme(panel.grid=element_blank(),
        panel.background = element_rect(color = "black"),
        legend.title = element_blank(),
        legend.position=c(0.85,0.13),
        legend.key.size = unit(0.5,'cm'),
        legend.text = element_text(size = 10),
        axis.title.x = element_text(size = 13),
        axis.title.y = element_text(size = 13),
        axis.text = element_text(size = 11,colour = "black")
  )
dev.off()

##Differential abundance analysis
sub_data$Group <- Wild_Duroc$Group
data1 <- sub_data[1:22,]
data2 <- sub_data[c(1:6,23:42),]

p_value1 <- NULL
p_value2 <- NULL
p_value3 <- NULL
for (i in 1:986){
  KW <- kruskal.test(sub_data[,i], 
                     sub_data$Group, 
                     paired=T,     
                     alternative="two.sided",
                     exact=T,     
                     correct="bonferroni",   
                     conf.int=FALSE)
  Kw_P <- KW$p.value
  p_value1 <- c(p_value1,Kw_P)
  
  
  WC1 <- wilcox.test(data1[,i] ~ data1$Group,data = data1,alternative="two.sided",exact=T,conf.int=FALSE)
  WC1_P <- WC1$p.value
  p_value2 <- c(p_value2,WC1_P)
  
  WC2 <- wilcox.test(data2[,i] ~ data2$Group,data = data2,alternative="two.sided",exact=T,conf.int=FALSE)
  WC2_P <- WC2$p.value
  p_value3 <- c(p_value3,WC2_P)
  
}
result <- as.data.frame(cbind(names(sub_data)[-987],p_value1,p_value2,p_value3),stringsAsFactors = F)
result[,2:4] <-  sapply(result[,2:4],as.numeric)
sig_data <- result[which(result$p_value2 <0.01 & result$p_value3 <0.01),]
sig_data[,2:4] <- signif(sig_data[2:4],digits = 2)
names(sig_data) <- c("Species","kruskal_test","wilcox_W_JY","wilcox_W_SH")
write.table(sig_data,file = "Species_Wild_VS_Duroc.xls",row.names = F,sep = "\t",quote = F)

#mean and sd of each froup
library(plyr)
a <- function(x) mean(x)
b <- function(x) sd(x)
mean <- ddply(sub_data, "Group",numcolwise(a))
sd <- ddply(sub_data, "Group",numcolwise(b))
info_group <- rep(c("mean","sd"),c(3,3))
Wild_Duroc_mean_sd <- rbind(mean,sd)
Wild_Duroc_mean_sd <- as.data.frame(cbind(info_group,Wild_Duroc_mean_sd))
Wild_Duroc_mean_sd[,3:988] <- round(Wild_Duroc_mean_sd[,3:988],3)

#select Significantly different speceis
sig_mean_sd <- Wild_Duroc_mean_sd[,c(1,2,which(names(Wild_Duroc_mean_sd) %in% sig_data$Species))]
write.table(sig_mean_sd,file = "Species_sig_mean_sd.xls",row.names = F,sep = "\t",quote = F)

#####show significantly different speceis
select_sig <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "select_sig_data(69)")
sub_data <- read.table("Wild_Duroc_fpkm.xls",header = T, row.names = 1,check.names = F,sep = "\t")
Wild_Duroc <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "Sample_info")

select_data <- sub_data[,select_sig$Species]
rownames(select_data) <- Wild_Duroc$SampleID_new[match(rownames(select_data),Wild_Duroc$SampleID)] 

select_data <- as.data.frame(t(select_data))

#group information of samples
Sample_group <- as.data.frame(Wild_Duroc$Group)
rownames(Sample_group) <- Wild_Duroc$SampleID_new
names(Sample_group) <- "Group"
Sample_group$Group <- factor(Sample_group$Group,levels = c("Wild Boar","Duroc-JY","Duroc-SH"))

##pheatmap
library(pheatmap)
tiff(filename = "Boar_Duroc_sig_species69_heatmap.tif",width = 4800,height = 5000,res=600,compression="lzw")
pheatmap(select_data,scale = "row",color = colorRampPalette(rev(c("red","white","blue")))(102),
         cluster_rows =T,cluster_cols =F,fontsize = 8,
         border_color=NA,annotation_legend=F,
         annotation_col =Sample_group)
dev.off()


#############Comparison of antibiotic resistance genes between Wild and Duroc#################
####ARGs number
Alpha <- read.table("Wild_Duroc_CARD_Alpha.xls",header = T, check.names = F,sep = "\t")

Alpha$Group <- factor(Alpha$Group,levels =  c("Wild Boar","Duroc-JY","Duroc-SH"))

BD.compare <- list(c("Wild Boar","Duroc-JY"),c("Duroc-JY","Duroc-SH"),c("Wild Boar","Duroc-SH")) 
library(ggpubr)
p1 <- ggboxplot(Alpha, x="Group", y="Number",  fill  = "Group",palette = "jco") + 
  labs(y="ARGs number",x=NULL) + 
  guides(fill=FALSE) +
  theme(legend.title=element_blank(),
        panel.background = element_rect(color = "black"),
        axis.text.x = element_text(color="black",angle = 30,vjust = 1,hjust = 1))+
  stat_compare_means(comparisons = BD.compare,aes(group=Group),label = "p.signif")

tiff(filename = "Wild_Duroc_ARGs_number.tif",width = 2500,height = 2500,res=600,compression="lzw")
p1
dev.off()

####at drug level
Drug.merge <- read.table("CARD_Drug_fpkm.xls",header = T,sep = "\t",check.names = F,stringsAsFactors = F)
rownames(Drug.merge) <- Drug.merge$Drug_rename
data1 <- as.data.frame(t(Drug.merge[,3:ncol(Drug.merge)]))
data1$Group <- rep(c("Wild Boar","Duroc-JY","Duroc-SH"),c(6,16,20))

library(plyr)
data1.mean <- ddply(data1,"Group",numcolwise(mean))

top.name <- NULL
for (i in 1:nrow(data1.mean)) {
  row.data <- data1.mean[i,-1]
  top10 <- sort(row.data,decreasing = T)[1:10]
  top.name <- c(top.name,names(top10))
} 
unique.top <- unique(top.name)
data1.mean.top <- data1.mean[,unique.top]
data1.mean.Others <- data1.mean[,!(names(data1.mean) %in% unique.top)]
data1.Others.sum <- apply(data1.mean.Others[,-1], 1, sum)
data1.mean.top$Others <- data1.Others.sum
data1.mean.top$Group <- data1.mean$Group

library(reshape2)
data1.melt <- melt(data1.mean.top,id.vars = "Group")

#bar plot
data1.melt$Group <- factor(data1.melt$Group,levels = c("Wild Boar","Duroc-JY","Duroc-SH"))

library(ggplot2)
library(ggsci)
library(RColorBrewer)
colourCount = length(unique(data1.melt$variable))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))
p1 <- ggplot(data1.melt,aes(x=Group,y=value,fill=variable))+
  geom_bar(stat="identity")+
  labs(y="ARGs abundance (FPKM)",x=NULL,fill="Drug") + 
  scale_fill_manual(values = getPalette(colourCount))+
  theme_bw()+
  guides(fill=guide_legend(ncol=1))+
  theme(panel.background = element_rect(color = "black"),
        axis.text.x = element_text(angle = 30,vjust = 1,hjust = 1,size=12,colour = "black"),
        axis.text.y = element_text(size=12,colour = "black"),
        legend.key.size = unit(0.4,'cm'))

tiff(filename = "Wild_Duroc.drug_bar.tif",width = 2000,height = 2500,res=600,compression="lzw")
p1
dev.off()

#############Comparison of KEGG pathway######################
library(readxl)  
data <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "KEGG_level3")
Wild_Duroc <- read_xlsx("Wild_Duroc_taxa.xlsx",sheet = "Sample_info")

sub_data <- data[which(data$Group=="PATH"),c("Description",Wild_Duroc$SampleID)]
names(sub_data)[2:43] <- Wild_Duroc$SampleID_new[match(names(sub_data)[2:43],Wild_Duroc$SampleID)]

#remove pathway that are absent from the sample
data_delete_all0 <- sub_data[which((rowSums(sub_data[,2:43])!=0)),]
data.t <- as.data.frame(t(data_delete_all0[,2:43]))
names(data.t) <- data_delete_all0$Description

##Differential abundance analysis
data.t$Group <- Wild_Duroc$Group
data1 <- data.t[1:22,]
data2 <- data.t[c(1:6,23:42),]

p_value1 <- NULL
p_value2 <- NULL
p_value3 <- NULL
for (i in 1:435){
  KW <- kruskal.test(data.t[,i], 
                     data.t$Group, 
                     paired=T,     
                     alternative="two.sided",
                     exact=T,     
                     correct="bonferroni",   
                     conf.int=FALSE)
  Kw_P <- KW$p.value
  p_value1 <- c(p_value1,Kw_P)
  
  
  WC1 <- wilcox.test(data1[,i] ~ data1$Group,data = data1,alternative="two.sided",exact=T,conf.int=FALSE)
  WC1_P <- WC1$p.value
  p_value2 <- c(p_value2,WC1_P)
  
  WC2 <- wilcox.test(data2[,i] ~ data2$Group,data = data2,alternative="two.sided",exact=T,conf.int=FALSE)
  WC2_P <- WC2$p.value
  p_value3 <- c(p_value3,WC2_P)
  
}
result <- as.data.frame(cbind(names(data.t)[-436],p_value1,p_value2,p_value3),stringsAsFactors = F)
result[,2:4] <-  sapply(result[,2:4],as.numeric)
sig_data <- result[which(result$p_value2 <0.01 & result$p_value3 <0.01),]
sig_data[,2:4] <- signif(sig_data[2:4],digits = 2)
names(sig_data) <- c("Pathway","kruskal_test","wilcox_W_JY","wilcox_W_SH")
write.table(sig_data,file = "Pathway_Wild_VS_Duroc.xls",row.names = F,sep = "\t",quote = F)

#mean and sd of each froup
library(plyr)
a <- function(x) mean(x)
b <- function(x) sd(x)
mean <- ddply(data.t, "Group",numcolwise(a))
sd <- ddply(data.t, "Group",numcolwise(b))
info_group <- rep(c("mean","sd"),c(3,3))
Wild_Duroc_mean_sd <- rbind(mean,sd)
Wild_Duroc_mean_sd <- as.data.frame(cbind(info_group,Wild_Duroc_mean_sd))
Wild_Duroc_mean_sd[,3:437] <- round(Wild_Duroc_mean_sd[,3:437],3)

#select Significantly different pathway
sig_mean_sd <- Wild_Duroc_mean_sd[,c(1,2,which(names(Wild_Duroc_mean_sd) %in% sig_data$Pathway))]
write.table(sig_mean_sd,file = "Pathway_sig_mean_sd.xls",row.names = F,sep = "\t",quote = F)


