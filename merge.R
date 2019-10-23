# Ref:
#http://www.sthda.com/english/wiki/correlation-matrix-
#a-quick-start-guide-to-analyze-format-and-visualize-
#a-correlation-matrix-using-r-software

# you need to install Hadley Wickman's devtools package to use github 
# https://www.statmethods.net/stats/correlations.html

# Install
#if(!require(devtools)) install.packages("devtools")
library(devtools)
#devtools::install_github("kassambara/ggcorrplot")

#install.packages("Hmisc")
#install.packages(c("corrplot","corrgram"))
#install.packages("Amelia") # missing data
#install.packages(c("dplyr","ggthemes"))
#devtools::install_github("tidyverse/dplyr")
library(dplyr)
library(ggthemes)
library(corrplot)
#library(corrgram)
library(Amelia)
library(Hmisc) # correlation matrix with significance levels

#corrgram(clinical.aorta,order=TRUE, lower.panel=panel.shade,upper.panel=panel.pie, text.panel=panel.txt)
# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

# aorta, heart, liver, lung, spleen, stomach, thora, VC_CA, PA_CA, PA_SP
#outfiles <- c('clinicalHeart')

clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/rd_stomach.csv")

# drop the index in clinical dataframe
clinical <- select(clinical,-X)
aorta <- select(aorta, Anon = patient_st, everything())
#aorta <- rename(aorta, Anon = patient_sp) # alternative 
print(head(aorta))
#print(head(aorta))
# this will merge two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)

#print(any(!is.numeric(clinical.aorta)))

#print(head(clinical.aorta))

#missmap(clinical.aorta, main="Missing Map: RD Aorta", 
#        col=c("yellow", "black"), legend=FALSE)

# drop the Anon string to choos just numeric columns

clinical.aorta <- select(clinical.aorta,-Anon)
#print(head(clinical.aorta)) 

#write.csv(clinical.aorta, file='/home/ef2p/Kaggle/lymphopenia/R/clinicalAorta.csv')

clinical.aorta <-as.matrix(clinical.aorta)

#pdf(paste0("/home/ef2p/Kaggle/lymphopenia/figures/",outfiles[1],".pdf"))
corrplot(cor(clinical.aorta), method = "color")
#dev.off()

res2 <- cor(clinical.aorta, method = 'pearson') # pearson, spearman
#print(res2)

df <- as.data.frame(res2)
ndf <- df[order(-df$lya.decrease),]
print(ndf['lya.decrease'])

#res2 <- rcorr(clinical.aorta, type = 'spearman') # HMisc input must be matrix, type spearman/pearson

#print(head(clinical.aorta))

#print(flattenCorrMatrix(res2$r, res2$P))

