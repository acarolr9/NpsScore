
library(xlsx)

PACIENTES<-read_excel("C:/Users/ASUS/Documents/Training Data.xlsx")
str(PACIENTES)
PACIENTES.eva<-read_excel("C:/Users/ASUS/Documents/Test Data.xlsx")
str(PACIENTES)
PACIENTES.eva1<-read_excel("C:/Users/ASUS/Documents/Test Data corr1.xlsx")

set.seed(858)

sample <- sample(2, nrow(PACIENTES), replace = TRUE, prob = c(0.60,0.40))

PACIENTES.train <- PACIENTES[sample ==1,]

PACIENTES.test <- PACIENTES[sample ==2,]



PACIENTES.train$NPS<-as.factor(PACIENTES.train$NPS)
PACIENTES.test$NPS<-as.factor(PACIENTES.test$NPS)

#####################
corr<-PACIENTES[,13:47]
correlacion<-round(cor(corr), 1)
write.csv(correlacion, "C:/Users/ASUS/Documents/correla.csv")


PACIENTES.train$NPS<-as.factor(PACIENTES.train$NPS)
PACIENTES.test$NPS<-as.factor(PACIENTES.test$NPS)


PACIENTES.train3<-read_excel("C:/Users/ASUS/Documents/Training Data cor1.xlsx")
PACIENTES.train4<-read_excel("C:/Users/ASUS/Documents/Training Data cor2.xlsx")

sample <- sample(2, nrow(PACIENTES.train3), replace = TRUE, prob = c(0.60,0.40))
PACIENTES.train31 <- PACIENTES.train3[sample ==1,]
PACIENTES.test31 <- PACIENTES.train3[sample ==2,]

PACIENTES.train31$NPS<-as.factor(PACIENTES.train31$NPS)
PACIENTES.test31$NPS<-as.factor(PACIENTES.test31$NPS)

set.seed(3000)

sample <- sample(2, nrow(PACIENTES.train4), replace = TRUE, prob = c(0.60,0.40))
PACIENTES.train41 <- PACIENTES.train4[sample ==1,]
PACIENTES.test41 <- PACIENTES.train4[sample ==2,]

PACIENTES.train41$NPS<-as.factor(PACIENTES.train41$NPS)
PACIENTES.test41$NPS<-as.factor(PACIENTES.test41$NPS)

##library(dplyr)
#############################
PACIENTES.train1<-select(PACIENTES.train,-CONSECUTIVO, -ID, -SCORENPS, -ESTADO, -PAIS)
#PACIENTES.train31<-select(PACIENTES.train31,-CONSECUTIVO, -ID, -SCORENPS, -ESTADO, -PAIS)
#PACIENTES.train41<-select(PACIENTES.train41,-CONSECUTIVO, -ID, -SCORENPS, -ESTADO, -PAIS)

#library("rpart")
#library("rpart.plot")
##################1.CON FECHA########################

arbol <- rpart(NPS~ ., data=PACIENTES.train1,
               control=rpart.control(xval=50, minbucket = 10, maxdepth=10, cp=0.001))
###################################
#printcp(arbol) 
rpart.plot(arbol, type=1, extra=10,cex = .5)

#METRICAS TRAIN
#library(caret)

#pr<-predict(arbol,PACIENTES.train1, type="class")
#conf1<-confusionMatrix(pr,PACIENTES.train1$NPS)  
#conf1$byClass

#METRICAS TEST
#####################################
pr<-predict(arbol,PACIENTES.test, type="class")
conf1<-confusionMatrix(pr,PACIENTES.test$NPS)  
conf1$byClass
a<-as.data.frame(conf1$byClass)
experimentos1<-rbind(experimentos1, a)
write.xlsx(experimentos1,"C:/Users/ASUS/Documents/RESULTADOSARBOLES2.xlsx")

#MESTRICAS KAGGLE
Id<-PACIENTES.eva1$ID
Predicted<-as.data.frame(predict(arbol,PACIENTES.eva1, type="class"))
Result1<-cbind(Id,Predicted)
write.table(Result1,"C:/Users/ASUS/Documents/RESU2.txt",sep = ",", dec = ".",row.names = FALSE)




