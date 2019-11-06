
setwd("C:\\Users\\kausik\\Documents\\Sindhu\\PGP BABI\\Capstone\\Financial statement analysis\\Final Report\\Input files")
data<-read.csv("modelinput.csv")
View(data)
data$Score.Cluster<-as.factor(data$Score.Cluster)
set.seed(1234)

###modelinput has Score.Cluster as dependent variable
modelinput = read.csv("modelinput.csv",header=TRUE)

###Inputdata has HR,LR and MR as dependent variable
###One hot encoding is done and used in Neural network
inputdata = read.csv("input.csv",header=TRUE)

#PCA
#=====


##Scaling 
modelinput1 = scale(modelinput[,-c(1,2,39)])
modelinput1 = as.data.frame(modelinput1)
modelinput = cbind(modelinput1,modelinput[,39])
colnames(modelinput)[37]="Score.Cluster"
inputdata1 = scale(inputdata[,-c(1,2,39)])
inputdata1 = as.data.frame(inputdata1)
class(inputdata1)
inputdata = cbind(inputdata1,inputdata[,39])
colnames(inputdata)[37]="Score.Cluster"

View(modelinput)
View(inputdata)



#Splitting data (70:30)
#======================

library(caret)
?createDataPartition
data.rows<- createDataPartition(y= data$Score.Cluster, p=0.7, list = FALSE)
data.train<- data[data.rows,] # 70% data goes in here
table(data.train$Score.Cluster)

data.test<- data[-data.rows,] # 30% data goes in here
table(data.test$Score.Cluster)


#Over Sampling
#================
#Train data Over Sampling
#============================
  

library(DMwR)
?SMOTE
tr.smote <- SMOTE(data.train$Score.Cluster ~., data.train, perc.over = 300, k = 5, perc.under = 100)
table(tr.smote$Score.Cluster)
table(data.train$Score.Cluster)


#Modelling
#=============


#-------------------------CART-------------------------------------#
#------------------------------------------------------------------#

#---loading the library
library(rpart)
library(rpart.plot)

#------------ setting the control paramter inputs for rpart
#-------------"rpart.control" just stores the values 
?rpart.control
r.ctrl = rpart.control(minsplit=6, minbucket = 2, cp = 0, xval = 5)
r.ctrl
#---------model run---------------#
cart.model<-rpart(formula=Score.Cluster ~ ., data=data.train[,c(-1,-2)], method="class",control = r.ctrl)
cart.model

#plot the resulting tree
rpart.plot(cart.model)


## to find how the tree performs and derive cp value
printcp(cart.model)
plotcp(cart.model)

0.0186335
## Pruning Code
cart.ptree<- prune(cart.model, cp= 0.0186335 ,"CP")
printcp(cart.ptree)
rpart.plot(cart.ptree)
cart.ptree


prp(cart.ptree)
pred.train <- predict(cart.ptree, newdata=data.train, type="class")
pred.train
table(data.train$Score.Cluster, pred.train)

pred.test <- predict(cart.ptree, newdata=data.test, type="class")
pred.test
table(data.test$Score.Cluster, pred.test)

confusionMatrix(data.train$Score.Cluster, pred.train)
confusionMatrix(data.test$Score.Cluster, pred.test)

#TRAIN
#Accuracy : 0.9514
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.9605   0.9674   0.9111
#Specificity            0.9891   0.9337   0.9885


#TEST
#Accuracy : 0.8243
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.8125   0.8068   0.8929
#Specificity            0.9483   0.8500   0.9083

#-------------------------Random Forest-------------------------------------#
#------------------------------------------------------------------#

#---loading the library
library(randomForest)
?randomForest

RF <- randomForest(data.train$Score.Cluster~ ., data = data.train[,-c(1:2)], 
                   ntree=501, mtry = 27, nodesize = 25,
                   importance=TRUE)

RF

pred.train.rf<-predict(RF, newdata=data.train, type="class")
confusionMatrix(data.train$Score.Cluster, pred.train.rf)

#TRAIN
#Accuracy : 0.7657
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.7083   0.9023   0.6612
#Specificity            0.9685   0.6820   0.9782

pred.test.rf<-predict(RF, newdata=data.test, type="class")
confusionMatrix(data.test$Score.Cluster, pred.test.rf)

#Accuracy : 0.7635 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.5952   0.8571   0.7907
#Specificity            0.9340   0.6941   0.9810

set.seed(seed)
bestmtry <- tuneRF(X1, Y1, stepFactor=0.5, improve=1e-5, ntree=200)
print(bestmtry)

#-------------------------SVM-------------------------------------#
#------------------------------------------------------------------#
library(e1071)
?radial
SVMmodel=svm(Score.Cluster~.,data=data.train,kernel="radial",cost=1)
summary(SVMmodel)
Prediction.train=predict(SVMmodel)
Prediction.train
table(data.train$Score.Cluster, Prediction.train)

Prediction.test=predict(SVMmodel,newdata=data.test)
Prediction.test
table(data.test$Score.Cluster, Prediction.test)


library(caret)

confusionMatrix(data.train$Score.Cluster, Prediction.train)
confusionMatrix(data.test$Score.Cluster, Prediction.test)

#TRAIN
#Accuracy : 0.6629
#                     Class: 1 Class: 2 Class: 3
#Sensitivity           0.92308   0.6212   0.8636
#Specificity           0.81009   0.8772   0.8464

#TEST 
#Accuracy : 0.6622 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity           1.00000   0.6172  0.92857
#Specificity           0.81690   0.9500  0.82836

#-------------------------LDA-------------------------------------#
#------------------------------------------------------------------#


library(DiscriMiner)
X1<-data.train[,3:38]
Y1<-as.numeric(data.train[,39])
Y1<-as.numeric(data.train$Score.Cluster)
Fischer1<-linDA(X1,Y1)
print(Fischer1,digits =5)

confusionMatrix(data.train$Score.Cluster, Fischer1$classification)


X2<-data.test[,3:38]
Y2<-as.numeric(data.test[,39])
Y2<-as.numeric(data.test$Score.Cluster)
Fischer2<-linDA(X2,Y2)
print(Fischer,digits =5)

confusionMatrix(data.test$Score.Cluster, Fischer2$classification)
?predict

#TRAIN
#Accuracy : 0.8057 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.8421   0.7840   0.8375
#Specificity            0.9044   0.8394   0.9333

#TRAIN
#Accuracy : 0.8514 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.8519   0.8295   0.9091
#Specificity            0.9256   0.8833   0.9478

library(MASS)
?lda
data.train$Score.Cluster<-as.numeric(as.character(data.train$Score.Cluster))
z <- lda(data.train$Score.Cluster~.,data=data.train)
predict(z, test)$class


#-------------------------KNN-------------------------------------#
#------------------------------------------------------------------#

tr.x<-data.train[,3:38]
tst.x<-data.test[,3:38]
tr.y<-as.factor(data.train[,39])
tst.y<-as.factor(data.test[,39])
?knn
knn.model.tr<-knn(train=tr.x,test=tr.x, cl=tr.y,k=3)
knn.model.tr
confusionMatrix(tr.y, knn.model.tr)

#TRAIN
#Accuracy : 0.7686 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.7692   0.7889   0.7209
#Specificity            0.9088   0.7881   0.9129

knn.model.test<-knn(train=tst.x,test=tst.x, cl=tst.y,k=3)
knn.model.test
confusionMatrix(tst.y, knn.model.test)

#TEST
#Accuracy : 0.8311 
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.7241   0.8295   0.9355
#Specificity            0.9076   0.8833   0.9402


#-------------------------Naive Bayes------------------------------#
#------------------------------------------------------------------#

tr.x<-data.train[,3:38]
tst.x<-data.test[,3:38]
tr.y<-as.factor(data.train[,39])
tst.y<-as.factor(data.test[,39])

nb.model<-naiveBayes(x=tr.x, y=tr.y)
tr.pred<-predict(nb.model,newdata=tr.x)
tr.pred
confusionMatrix(tr.y, tr.pred)

#TRAIN
#Accuracy : 0.6629
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.5738   0.8673   0.5923
#Specificity            0.9737   0.5873   0.9636

tst.pred<-predict(nb.model,newdata=tst.x)
tst.pred
confusionMatrix(tst.y, tst.pred)

#TEST
#Accuracy : 0.6824
#                     Class: 1 Class: 2 Class: 3
#Sensitivity            0.5370   0.8667   0.6735
#Specificity            0.9681   0.6019   0.9697



