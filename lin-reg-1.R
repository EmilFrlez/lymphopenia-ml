# you need to install Hadley Wickman's devtools package to use github 
# https://www.statmethods.net/stats/correlations.html

# parallel processing
#install.packages('doMC')
#install.packages('doMPI')
library(doMC) # multi-core
registerDoMC(cores=4)

#install.packages("caret",
#                 repos = "http://cran.r-project.org", 
#                 dependencies = c("Depends", "Imports", "Suggests"))
#install.packages("caret", dependencies = TRUE)
#install.packages("caret", dependencies = c("Depends", "Suggests"))
library(caret) # R library for cross-validation
library(gbm)
# Install
#if(!require(devtools)) install.packages("devtools")
#library(devtools)
#devtools::install_github("kassambara/ggcorrplot")

#packages<-c('ggplot2','data.table','knitr','xtable')
#install.packages(packages)

#install_github('andreacirilloac/updateR')
#library(updateR)
#updateR(admin_password='emil2434121')
#install.packages('caret')

#install.packages("Hmisc")
#install.packages(c("corrplot","corrgram"))
#install.packages("Amelia") # missing data
#install.packages(c("dplyr","ggthemes"))
#devtools::install_github("tidyverse/dplyr")
library(dplyr)
library(ggthemes)
library(corrplot)
library(corrgram)
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
# this will merge two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)
clinical.aorta <- subset(clinical.aorta, select = -c(Anon))
clinical <- subset(clinical, select = -c(Anon))

print(any(is.na(clinical.aorta)))
print(any(!is.numeric(clinical.aorta)))

#install.packages("caTools")
#library(caTools)

clinical.aorta <- as.data.frame(clinical.aorta)
#print(class(clinical.aorta))
print(head(clinical.aorta))

# Set a random seed
set.seed(101) 

metric <- "Accuracy"
preProcess=c("center", "scale")

# Define train control for k fold cross validation
#train_control <- trainControl(method="cv", number=10)
train_control <- trainControl(method="repeatedcv", number=10, repeats=4)
print(head(train_control))
# Fit simplest linearr model with one predictor lya.start
model <- train(lya.decrease ~ ., data=clinical.aorta, trControl=train_control, method="gbm", 
               tuneLength = 3, preProc=c("center", "scale"), verbose = FALSE)
# Summarise Results
print(model)
summary(model)
#plot(model)
#Plotting Varianle importance for GBM
#varImp(object=model)
#plot(varImp(object=model),main="LM - Variable Importance")
# Grab residuals
res <- residuals(model)
# Convert to DataFrame for gglpot
res <- as.data.frame(res)
#print(head(res))

# Histogram of residuals
#pl <- ggplot(res,aes(res)) +  geom_histogram(binwidth=0.10, fill='blue',alpha=0.5)
#print(pl)


