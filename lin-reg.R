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

# aorta, heart, liver, lung, spleen, stomach, thora, VC_CA, PA_CA, PA_SP
#outfiles <- c('clinicalHeart')

clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/rd_aorta.csv")

# drop the index in clinical dataframe
clinical <- select(clinical,-X)
aorta <- select(aorta, Anon = patient_ao, everything())
#aorta <- rename(aorta, Anon = patient_ao) # alternative 

#print(head(aorta))
# this will meare two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)
clinical.aorta <- subset(clinical.aorta, select = -c(Anon))
clinical <- subset(clinical, select = -c(Anon))

print(any(is.na(clinical.aorta)))
print(any(!is.numeric(clinical.aorta)))

#install.packages("caTools")
library(caTools)

clinical.aorta <- as.data.frame(clinical.aorta)
print(class(clinical.aorta))

# Set a random seed
set.seed(101) 
# Split up the sample
sample <- sample.split(clinical.aorta["lya.decrease"], SplitRatio = 0.70) # SplitRatio = percent of sample==TRUE)
# Training Data
train = subset(clinical.aorta, sample == TRUE)
# Testing Data
test = subset(clinical.aorta, sample == FALSE)

#print(head(train))

# build the model
model <- lm(lya.decrease ~ .,train)
#print(summary(model))

# Grab residuals
res <- residuals(model)
# Convert to DataFrame for gglpot
res <- as.data.frame(res)
#print(head(res))

# Histogram of residuals
pl <- ggplot(res,aes(res)) +  geom_histogram(binwidth=0.05, fill='blue',alpha=0.5)
print(pl)

plot(model)

