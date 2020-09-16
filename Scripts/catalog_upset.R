library(data.table)
data <- fread("group_upset_test.txt",head=T,check.names = F,sep = "\t")

group <- names(data)[2:7]

merge.list <- list()
for (i in 1:6) {
  comb <- t(combn(group,i))
  da<-list()
  for (j in 1:nrow(comb)) {
    da[[j]]<-comb[j,]
  }
  merge.list <- c(merge.list,da)
}

num <- NULL
for (i in 7:length(merge.list)) {
  if("Dom_feces" %in%  merge.list[[i]]){
    num <- c(num,i)
  }
}
final.list <- merge.list[-num]

library(UpSetR)
p <- upset(data, nsets = 6, mb.ratio = c(0.5, 0.5),
           order.by = c("freq", "degree"), decreasing = c(TRUE,FALSE),intersections=merge.list[1:21])

tiff(filename = "group_Diff_upset.tif",width = 4800,height = 4000,res=600,compression="lzw")
p
dev.off()
