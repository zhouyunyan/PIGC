rm(list = ls())
#Corration between Prevotella_copri and Lipopolysaccharide_biosynthesis in Duroc population.
library(readxl)
data <- read_xlsx("P.copri_LPS.xlsx",sheet = "P.copri_LPS")

lm.table <-  lm(formula =data$Lipopolysaccharide_biosynthesis ~ data$Prevotella_copri, data = data)
summary(lm.table)
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -849.66 -237.23   33.69  219.53 1348.24 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)           1.985e+03  9.988e+01  19.869  < 2e-16 ***
#   data$Prevotella_copri 1.736e-02  2.056e-03   8.445 7.32e-10 ***
#   ---
#   Signif. codes:  0 ¡®***¡¯ 0.001 ¡®**¡¯ 0.01 ¡®*¡¯ 0.05 ¡®.¡¯ 0.1 ¡® ¡¯ 1
# 
# Residual standard error: 459.3 on 34 degrees of freedom
# Multiple R-squared:  0.6772,	Adjusted R-squared:  0.6677 
# F-statistic: 71.32 on 1 and 34 DF,  p-value: 7.322e-10

library(ggplot2)

tiff(filename = "P.copri_LPS.tif",width = 2500,height = 2000,res=600,compression="lzw")
ggplot(data,aes(Prevotella_copri,Lipopolysaccharide_biosynthesis))+
  geom_point(aes(colour = group))+
  geom_smooth(method = "lm",colour="black")+ 
  theme_bw()+
  labs(x="Prevotella copri (fpkm)",y="LPS biosynthesis (fpkm)",title = "R^2 = 0.67, P = 7.32e-10",size=10) + 
  theme(panel.grid=element_blank(),
    panel.background = element_rect(color = "black"),
    axis.title.y = element_text(size = 13,color="black"),
    axis.title.x = element_text(size = 13,color="black"),
    axis.text.y = element_text(size = 11,color="black"),
    axis.text.x = element_text(size = 11,color="black"),
    plot.title = element_text(hjust = 0.5),
    legend.title = element_blank(),
    legend.position=c(0.85,0.12),
    legend.text = element_text(size = 8),
    #legend.box.background = element_rect(color="grey", size=0.5),
    legend.key.size = unit(0.4,'cm'))
dev.off()
