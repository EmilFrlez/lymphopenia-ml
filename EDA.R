#install.packages(c("corrplot","corrgram"))
#install.packages("Amelia") # missing data
#install.packages(c("dplyr","ggthemes"))
#devtools::install_github("tidyverse/dplyr")
library(dplyr)
library(ggthemes)
library(corrplot)
library(corrgram)
library(Amelia)

# aorta, heart, liver, lung, spleen, stomach, thora, VC_CA, PA_CA, PA_SP
outfiles <- c('clinicalThora')

#clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand/clinical-2.csv")
#aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/rd_aorta.csv")
aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand/aorta.csv")

# drop the index in clinical dataframe
clinical <- select(clinical,-X)
aorta <- select(aorta,-X)
aorta <- select(aorta, Anon = patient.ao, everything())

#print(head(aorta))
# this will meare two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)

#print(any(!is.numeric(clinical.aorta)))

#print(head(clinical.aorta))

#missmap(clinical.aorta, main="Missing Map: RD Aorta", 
#        col=c("yellow", "black"), legend=FALSE)

# drop the Anon string to choose just numeric columns

clinical.aorta <- select(clinical.aorta,-Anon)
#print(head(clinical.aorta)) 

#write.csv(clinical.aorta, file='/home/ef2p/Kaggle/lymphopenia/R/clinicalAorta.csv')

clinical.aorta <-as.matrix(clinical.aorta)

#pdf(paste0("/home/ef2p/Kaggle/lymphopenia/figures/",outfiles[1],".pdf"))
#corrplot(cor(clinical.aorta), method = "color")
#dev.off()

#print(cor(clinical.aorta, method = 'pearson'))

# here we order correlation coefficents in size!

# first method gives just correlation coefficients:
res2 <- cor(clinical.aorta, method = 'pearson') # pearson, spearman
df <- as.data.frame(res2)
ndf <- df[order(-df$lya.decrease),]
print(ndf['lya.decrease'])

# second "rcorr" method gives p-values!
# see https://rstudio-pubs-static.s3.amazonaws.com/
# 240657_5157ff98e8204c358b2118fa69162e18.html#
# correlation-matrix-with-significance-levels-p-value
#res2 <- rcorr(clinical.aorta, type = 'spearman') # HMisc input must be matrix, type spearman/pearson
#df <- as.data.frame(res2$P)
#ndf <- df[order(df$lya.decrease),]
#print(ndf['lya.decrease'])

#corrgram(clinical.aorta,order=TRUE, lower.panel=panel.shade,upper.panel=panel.pie, text.panel=panel.txt)

