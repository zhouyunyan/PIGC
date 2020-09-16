#####Numbers of shared bacterial taxa among pigs at different thresholds of frequencies at the phylum, genus and species level
###Import data from Core_species.xlsx
#sheet£ºdata1
data1<- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 
#sheet£ºdata2
data2 <- read.delim("clipboard",header = T,sep = "\t",check.names = F,stringsAsFactors = F) 

library(reshape2)
data1_melt <- melt(data1,id.vars = "Sample_num")
data2_melt <- melt(data2,id.vars = "Sample_percent")

data2_melt$absolute <- data1_melt$value
data2_melt$variable <- factor(data2_melt$variable,levels = c("Phylum","Genus","Species"))
data2_melt$value <- data2_melt$value*100
data2_melt$percent <- paste(round(data2_melt$value,digits = 0),"%",sep = "")

library(ggplot2)
library(ggrepel) 
tiff(filename = "Phylum_Genus_Species_line.tif",width = 2300,height = 2300,res=600,compression="lzw")
ggplot(data2_melt,aes(x=Sample_percent,y=value,colour=variable,group=variable))+
  geom_line() +
  geom_point() +
  labs(x="The proportion of samples (%)",y="The proportion of shared items (%)")+
  theme_bw()+
  theme(panel.grid=element_blank(),
        panel.background = element_rect(color = "black"),
        legend.position=c(0.15,0.11),
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
  scale_x_continuous(breaks = c(0,20,50,90,100)) 
  geom_text_repel(aes(label=paste(absolute,"(",percent,")",sep = "")),size = 2.6)
dev.off()

###Core species in different gut location
data <- read.table("sample500_Bacteria_species_fpkm.xls",header = T, row.names = 1,check.names = F,sep = "\t")
info <- read.table("sample500.info.txt",header = T, row.names = 1,check.names = F,sep = "\t")

#relative abundance
rela.abun <- sweep(data,1,rowSums(data),"/")

rela.abun$Group <- info$SampleType[match(rownames(rela.abun),rownames(info))]

ileum_data <- rela.abun[which(rela.abun$Group=="ileum"),-ncol(rela.abun)]
cecum_data <- rela.abun[which(rela.abun$Group=="cecum"),-ncol(rela.abun)]
feces_data <- rela.abun[which(rela.abun$Group=="feces"),-ncol(rela.abun)]

library(vegan)
#The distribution of species in each group
ileum_num <- specnumber(ileum_data,MARGIN = 2)
cecum_num <- specnumber(cecum_data,MARGIN = 2)
feces_num <- specnumber(feces_data,MARGIN = 2)

all_exist_ileum <- names(ileum_data)[which(ileum_num==6)]
all_exist_cecum <- names(cecum_data)[which(cecum_num==20)]
all_exist_feces <- names(feces_data)[which(feces_num ==472)]

#shared species in ileum,cecum and feces
#all <-intersect(intersect(all_exist_ileum,all_exist_cecum),all_exist_feces)

###average abundance
sub_ileum <- ileum_data[,all_exist_ileum]
sub_cecum <- cecum_data[,all_exist_cecum]
sub_feces <- feces_data[,all_exist_feces]

sub_ileum_mean <- colMeans(sub_ileum)
sub_cecum_mean <- colMeans(sub_cecum)
sub_feces_mean <- colMeans(sub_feces)

###### top 20 core species (present in all samples of each group) in feces¡¢cecum¡¢ileum
table_top20_ileum <- sub_ileum[,order(sub_ileum_mean,decreasing = T)[1:20]]
table_top20_cecum <- sub_cecum[,order(sub_cecum_mean,decreasing = T)[1:20]]
table_top20_feces <- sub_feces[,order(sub_feces_mean,decreasing = T)[1:20]]

top20.log.ileum <- log10(table_top20_ileum)
top20.log.cecum <- log10(table_top20_cecum)
top20.log.feces <- log10(table_top20_feces)

shared <- intersect(intersect(names(top20.log.cecum),names(top20.log.ileum)),names(top20.log.feces))

library(reshape2)
top20.melt.ileum <- melt(top20.log.ileum)
top20.melt.cecum <- melt(top20.log.cecum)
top20.melt.feces <- melt(top20.log.feces)

# top20.melt.feces$label <- rep(NA,nrow(top20.melt.feces))
# top20.melt.feces$label[which(top20.melt.feces$variable %in% shared)] <- "shared"
# top20.melt.feces$label[which(!(top20.melt.feces$variable %in% shared))] <- "notshared"

library(ggplot2)
p.ileum <- ggplot(data = top20.melt.ileum, aes(x=variable,y=value))+
  geom_boxplot(fill="red")+
  coord_flip()+scale_x_discrete(limits=rev(levels(top20.melt.ileum$variable)))+
  labs(title="Ileum",y="Relative abundance (log10)",x=NULL)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 12,color="black"))

p.cecum <- ggplot(data = top20.melt.cecum, aes(x=variable,y=value))+
  geom_boxplot(fill="green")+
  coord_flip()+scale_x_discrete(limits=rev(levels(top20.melt.cecum$variable)))+
  labs(title="Cecum",y="Relative abundance (log10)",x=NULL)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 12,color="black"))

p.feces <- ggplot(data = top20.melt.feces, aes(x=variable,y=value))+
  geom_boxplot(fill="blue")+
  coord_flip()+scale_x_discrete(limits=rev(levels(top20.melt.feces$variable)))+
  labs(title="Feces",y="Relative abundance (log10)",x=NULL)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 12,color="black"),
        axis.text.y = element_text(size = 12,color="black"))
