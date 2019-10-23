#http://jamesmarquezportfolio.com/correlation_matrices_in_r.html
#https://drsimonj.svbtle.com/exploring-correlations-in-r-with-corrr
#install.packages("corrr") 

#install.packages(c("corrplot","corrgram"))
#install.packages("Amelia") # missing data
#install.packages(c("dplyr","ggthemes"))
#devtools::install_github("tidyverse/dplyr")
library(dplyr)
library(ggplot2)
library(ggthemes)
library(corrplot)
library(corrgram)
library(Amelia)

# aorta, heart, liver, lung, spleen, stomach, thora, VC_CA, PA_CA, PA_SP
outfiles <- c('sig-blood-1')

#clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand2/clinical-2.csv")
#aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/rd_aorta.csv")
aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand2/blood.csv")

# drop the index in clinical dataframe
clinical <- select(clinical,-X)
aorta <- select(aorta,-X)
aorta <- select(aorta, Anon = patient.bl, everything())

#print(head(aorta))
# this will meare two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)
# exclude negative lya decreases
clinical.aorta <- subset(clinical.aorta, lya.decrease>=0)

#print(any(!is.numeric(clinical.aorta)))

#print(head(clinical.aorta))

#missmap(clinical.aorta, main="Missing Map: RD Aorta", 
#        col=c("yellow", "black"), legend=FALSE)

# drop the Anon string to choose just numeric columns

clinical.aorta <- select(clinical.aorta,-Anon)
#print(head(clinical.aorta)) 

#write.csv(clinical.aorta, file='/home/ef2p/Kaggle/lymphopenia/R/clinicalAorta.csv')

#clinical.aorta <-as.matrix(clinical.aorta)

#pdf(paste0("/home/ef2p/Kaggle/lymphopenia/figures/",outfiles[1],".pdf"))
corrplot(cor(clinical.aorta), method = "color")
#dev.off()
#print(cor(clinical.aorta, method = 'pearson'))
#corrplot(cor(clinical.aorta), method = "color")

# here we order correlation coefficents in size!
#install.packages('tidyverse')
library(tidyverse)
library(corrr)

rs <- correlate(clinical.aorta) # this is a corrr function 
#rs # this prints rs

# this show how lya.decrease depends on all other variables!
pdf(paste0("/home/ef2p/Kaggle/lymphopenia/figures/",outfiles[1],".pdf"))
rs %>% 
  focus(lya.decrease) %>%
  mutate(rowname = reorder(rowname, lya.decrease)) %>%
  ggplot(aes(rowname, lya.decrease)) +
  geom_col() + coord_flip()
dev.off()

# you have to execute this in terminal window or run it!!!
#clinical.aorta %>% 
#  correlate(use = "pairwise.complete.obs") %>% 
#  network_plot(min_cor=0.2)

#pdf(paste0("/home/ef2p/Kaggle/lymphopenia/figures/",outfiles[1],".pdf"))
#clinical.aorta %>% 
#  correlate(use = "pairwise.complete.obs") %>% 
#  network_plot(min_cor=0.2)
#rs <- correlate(clinical.aorta) 
#rs
#dev.off()

# It can also be called using the traditional method
#network_plot(correlate(clinical.aorta), min_cor=0.2)
#dev.off()

