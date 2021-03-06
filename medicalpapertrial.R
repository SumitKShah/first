clinic=read.csv("clinical_trial.csv",stringsAsFactors = FALSE)
max(nchar(clinic$abstract))
summary(nchar(clinic$abstract))
table(nchar(clinic$abstract)==0)
clinic$title[which.min(nchar(clinic$title))]
corpusTitle=Corpus(VectorSource(clinic$title))
corpusAbstract=Corpus(VectorSource(clinic$abstract))
corpusTitle=tm_map(corpusTitle,content_transformer(tolower))
corpusAbstract=tm_map(corpusAbstract,content_transformer(tolower))
corpusTitle=tm_map(corpusTitle,removePunctuation)
corpusAbstract=tm_map(corpusAbstract,removePunctuation)
corpusTitle=tm_map(corpusTitle,removeWords,stopwords("english"))
corpusAbstract=tm_map(corpusAbstract,removeWords,stopwords("english"))
corpusTitle=tm_map(corpusTitle,stemDocument)
corpusAbstract=tm_map(corpusAbstract,stemDocument)
dtmTitle=DocumentTermMatrix(corpusTitle)
dtmAbstract=DocumentTermMatrix(corpusAbstract)
sparseTitle=removeSparseTerms(dtmTitle,0.95)
sparseAbstract=removeSparseTerms(dtmAbstract,0.95)
Abstract=as.data.frame(as.matrix(sparseAbstract))
colnames(Abstract)=make.names(colnames(Abstract))
Title=as.data.frame(as.matrix(sparseTitle))
colnames(Title)=make.names(colnames(Title))
which.max(colSums(Abstract))
colnames(Abstract)=paste("A",colnames(Abstract))
colnames(Title)=paste("T",colnames(Title))
dtm=cbind(Abstract,Title)
dtm$trial=clinic$trial
summary(dtm)
set.seed(144)
spl=sample.split(dtm$trial,0.7)
train=subset(dtm,spl==TRUE)
test=subset(dtm,spl==FALSE)
model=rpart(trial~.,data=train,method="class")
prp(model)
predTrain=predict(model)
summary(predTrain[,2])
table(train$trial,predTrain[,2]>0.5)
predTest=predict(model,newdata=test)
table(test$trial,predTest[,2]>0.5)
predrocr=prediction(predTest[,2],test$trial)
performance(predrocr,"auc")@y.values
