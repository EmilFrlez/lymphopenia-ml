# stackoverflow soultion for loading package haven
#withr::with_makevars(c(PKG_LIBS = "-liconv"), install.packages("haven"), assignment = "+=")
# load libraries
#install.packages(c('mlbench','e1071'))
#install.packages("NeuralNetTools")
#install.packages('RSNNS')
#library(doMC) # multi-core
#registerDoMC(cores=4)
#doMC::registerDoMC(cores=detectCores() - 2)

library(RSNNS)
library(e1071)                 
library(mlbench)
library(caret)
library(gbm)
library(nnet)
library(NeuralNetTools)
library(neuralnet)
library(dplyr)
#library(ggthemes)
#library(corrplot)
#library(corrgram)
#library(Amelia)
#library(Hmisc) # correlation matrix with significance levels

# load data
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

x <- subset(clinical.aorta, select = -c(lya.decrease))
y <- subset(clinical.aorta, select =  c(lya.decrease))
y <- as.numeric(unlist(y))
print(y)

#print(str(clinical.aorta))

control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7

# available metrics for regression Rsquared, RMSE, R2
metric <- "Rsquared"

preProcess=c("center", "scale")

# neuralnet with 1-3 hidden layers
# use mxnet for 1-3 hidden layers, or mxnetAdam (not yet on cran)

# https://datascienceplus.com/fitting-neural-network-in-r/
# https://rpubs.com/mbaumer/NeuralNetworks
# this is the way to expand the number of hidden layers (expand.grid!)
my.grid = expand.grid(layer1=c(5), layer2=c(0), layer3=c(0))
fit.nn <- caret::train(x=x, y=y, method="neuralnet", tuneGrid=my.grid,
          preProc=c("center", "scale"), trControl=control,metric=metric,linear.output=TRUE) # classificaton=F, regression=T


#my.grid <- expand.grid(decay = c(0.01, 0.1, 0.5), size=c(10,10,10))
#my.grid = expand.grid(layer1=c(10), layer2=c(10), layer3=c(10))
#fit.nn <- caret::train( x=x, y=y, method="mlpML", 
#                        preProc =  c('center', 'scale', 'knnImpute', 'pca'),
#                        tuneGrid = my.grid,
#                        trControl = trainControl(method = "cv", verboseIter = FALSE, returnData = FALSE),
#                        verbose=FALSE)
#fit.nn <- train(lya.decrease~., data=clinical.aorta, method="nnet", linout=true, tuneGrid=my.grid, verbose=FALSE)

# Table comparison, size=number of neurons in first hidden layer, in this case, 1-5
print(fit.nn)
summary(fit.nn)

#plotnet(fit.nn$finalModel, y_names = "LYA Decrease")
#title("Graphical Representation of our Neural Network")
#garson(fit.nn$finalModel)

# final lasso coefficients, gives results for different shrinkage parameters
#predict(fit.nn$finalModel, type = 'coefficients')
#fit.nn$finalModel$lambda

# plot variable importance
#pdf("/home/ef2p/Kaggle/lymphopenia/figures/nn_varImp.pdf")
#plot(varImp(fit.nn), main='Neural Network Model Parameters: RD Aorta')
#dev.off()
#
#residuals<-resid(fit.nn)
#predictedValues<-predict(fit.nn)
#plot(clinical.aorta$lya.decrease,residuals)
#abline(0,0)
#plot(clinical.aorta$lya.decrease,predictedValues, main="Residuals vs Lymphocite Decrease")
#
 
