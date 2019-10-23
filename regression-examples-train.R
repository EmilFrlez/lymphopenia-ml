# stackoverflow soultion for loading package haven
#withr::with_makevars(c(PKG_LIBS = "-liconv"), install.packages("haven"), assignment = "+=")
# load libraries
#install.packages(c('mlbench','e1071'))

#library(doMC) # multi-core
#registerDoMC(cores=4)
#doMC::registerDoMC(cores=detectCores() - 2)

library(e1071)                 
library(mlbench)
library(caret)
library(gbm)
library(neuralnet)

library(dplyr)
library(ggthemes)
library(corrplot)
library(corrgram)
library(Amelia)
library(Hmisc) # correlation matrix with significance levels

# load data
# old
#clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/clinical-1.csv")
#aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/rd_aorta.csv")

# new, extend-ed
clinical <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand/clinical-2.csv")
aorta <- read.csv("/home/ef2p/Kaggle/lymphopenia/input/expand/aorta.csv")

# drop the index in clinical dataframe
clinical <- select(clinical,-X)
aorta <- select(aorta, Anon = patient.ao, everything())
#aorta <- rename(aorta, Anon = patient_ao) # alternative 

#print(head(aorta))
# this will merge two dataframes on common column "Anon"
clinical.aorta <- merge(clinical, aorta)
clinical.aorta <- subset(clinical.aorta, select = -c(Anon))
clinical <- subset(clinical, select = -c(Anon))

# conversion to matrix causes "lasso" to fail!
#clinical.aorta <- as.matrix(clinical.aorta)
print(class(clinical.aorta))
print(any(is.na(clinical.aorta)))
print(any(!is.numeric(clinical.aorta)))

# you have to provide both set.seed() AND  seed internally to caret, total of 10*3+1
set.seed(43)
my.seeds <- list(837, 692, 246, 34, 132, 886, 111, 54, 55, 798,
                 117, 492, 242, 89, 152, 806, 112, 13, 12, 708,
                 636, 611, 446, 14, 112, 876, 763, 53, 50, 11, 101)
control <- trainControl(method="repeatedcv", number=10, repeats=3, seeds = my.seeds)

# available metrics for regression Rsquared, RMSE, R2
metric <- "Rsquared"
preProcess=c("center", "scale")

# methods: lasso, nnet (only a single hidden layer!)
# neuralnet with 1-3 hidden layers
# use mxnet for 1-3 hidden layers, or mxnetAdam (not yet on cran)
fit.lasso <- train(lya.decrease~., data=clinical.aorta, method="lasso", metric=metric, 
                    trControl=control, preProc=c("center", "scale"))

# https://datascienceplus.com/fitting-neural-network-in-r/
#fit.nn <- train(lya.decrease~., data=clinical.aorta, method="neuralnet",hidden=c(5,5), 
#           linear.output=TRUE) # classificaton=F, regression=T

# Table comparison, size=number of neurons in first hidden layer, in this case, 1-5
print(fit.lasso)
summary(fit.lasso)

# final lasso coefficients, gives results for different shrinkage parameters
#predict(fit.lasso$finalModel, type = 'coefficients')
#fit.lasso$finalModel$lambda

# plot variable importance
#pdf("/home/ef2p/Kaggle/lymphopenia/figures/lasso_varImp.pdf")
#plot(varImp(fit.lasso), main='Neural Network Model Parameters: RD Aorta')
#dev.off()
#
#residuals<-resid(fit.lasso)
#predictedValues<-predict(fit.lasso)
#plot(clinical.aorta$lya.decrease,residuals)
#abline(0,0)
#plot(clinical.aorta$lya.decrease,predictedValues, main="Residuals vs Lymphocite Decrease")
#
 
