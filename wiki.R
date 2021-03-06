wiki=read.csv("wiki.csv",stringsAsFactors = FALSE)
wiki$Vandal=as.factor(wiki$Vandal)
table(wiki$Vandal)
corpusAdded=Corpus(VectorSource(wiki$Added))
corpusAdded=tm_map(corpusAdded,removeWords,stopwords("english"))
corpusAdded=tm_map(corpusAdded,stemDocument)
dtmAdded=DocumentTermMatrix(corpusAdded)
dtmAdded
sparseAdded=removeSparseTerms(dtmAdded,0.997)
sparseAdded
wordsAdded=as.data.frame(as.matrix(sparseAdded)) 
colnames(wordsAdded)=paste("A",colnames(wordsAdded))
corpusRemoved=Corpus(VectorSource(wiki$Removed))
corpusRemoved=tm_map(corpusRemoved,removeWords,stopwords("english"))
corpusRemoved=tm_map(corpusRemoved,stemDocument)
dtmremoved=DocumentTermMatrix(corpusRemoved)
sparseRemoved=removeSparseTerms(dtmremoved,0.997)
wordsRemoved=as.data.frame(as.matrix(sparseRemoved))
colnames(wordsRemoved)=paste("R",colnames(wordsRemoved))
wordsRemoved
wikiWords=cbind(wordsAdded,wordsRemoved)
wikiWords=cbind(wordsAdded,wordsRemoved)
wikiWords$Vandal=wiki$Vandal
set.seed(123)
spl=sample.split(wikiWords$Vandal,0.7)
train=subset(wikiWords,spl==TRUE)
test=subset(wikiWords,spl==FALSE)
table(test$Vandal)
618/(618+545)
cart=rpart(Vandal~.,data=train,method="class")
pred=predict(cart,newdata=test,type="class")
table(test$Vandal,pred)
(12+618)/(618+12+533)
prp(cart)
wikiWords2=wikiWords
wikiWords2$HTTP=ifelse(grepl("http",wiki$Added,fixed=TRUE),1,0)
table(wikiWords2$HTTP)
wikitrain=subset(wikiWords2,spl==TRUE)
wikitest=subset(wikiWords2,spl==FALSE)
crt=rpart(Vandal~.,data=wikitrain,method="class")
table(wikitrain$Vandal)
predme=predict(crt,newdata=wikitest,type="class")
table(wikitest$Vandal,predme)
wikiWords2$WordsAdded=rowSums(as.matrix(dtmAdded))
wikiWords2$WordsRemoveded=rowSums(as.matrix(dtmremoved))
summary(wikiWords2$WordsAdded)
wikitrain=subset(wikiWords2,spl==TRUE)
wikitest=subset(wikiWords2,spl==FALSE)
crt=rpart(Vandal~.,data=wikitrain,method="class")
table(wikitrain$Vandal)
predme=predict(crt,newdata=wikitest,type="class")
table(wikitest$Vandal,predme)
wikiWords3=wikiWords2
wikiWords3$Minor=wiki$Minor
wikiWords3$Logged=wiki$Loggedin
wikitrain=subset(wikiWords3,spl==TRUE)
wikitest=subset(wikiWords3,spl==FALSE)
crt=rpart(Vandal~.,data=wikitrain,method="class")
predme=predict(crt,newdata=wikitest,type="class")
table(wikitest$Vandal,predme)
(595+241)/(595+241+23+304)
prp(crt)
