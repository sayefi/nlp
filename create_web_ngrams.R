

inputfile<-"data/ngrams/web/w2_.txt"
file.size(inputfile)/1024/1024
# original file size was 16.9MB

con<-file(inputfile,"r")
ngram.2<-read.table(con)
close(con)

colnames(ngram.2)<-c("Freq","Prev1","nextToken")
head(ngram.2)




outputFileRDS<-"data/ngrams/web/w2.RData"

start_time<-Sys.time()
save(ngram.2,file=outputFileRDS)
end_time<-Sys.time()

file.size(outputFileRDS)/1024/1024
# after storing as RDS the size reduced to 3.8MB. Writing was fast
end_time-start_time
## 1.4Sec


rm(ngram.2)

load(file=outputFileRDS)
# Loading is instant... not even a sec
head(ngram.2)
dim(ngram.2)

39*39
ngram.2.copy<-ngram.2

ngram.2.copy$Prev1<-factor(ngram.2.copy$Prev1)
ngram.2.copy$nextToken<-factor(ngram.2.copy$nextToken)
object.size(ngram.2)

object.size(ngram.2.copy)


outputFileRDSFactor<-"data/ngrams/web/w2factor.RData"

start_time<-Sys.time()
save(ngram.2.copy,file=outputFileRDSFactor)
end_time<-Sys.time()

file.size(outputFileRDSFactor)/1024/1024
# after storing as RDS the size reduced to 3.8MB...same size. took little extra time
# no improvement
end_time-start_time
## 1.5Sec


##Load dictionary file
dictfilepath<-"data/ngrams/web/WordsEn.txt"
con<-file(dictfilepath,"r")
words<-read.table(dictfilepath,stringsAsFactors = T)
close(con)


head(words)

words$rownum<-1:dim(words)[1]


ngram.2.copy$Prev1


library(data.tree)

ngram.2.copy<-head(ngram.2,20000)
head(ngram.2.copy)
ngram.2.copy$pathString<-paste0("ng",ngram.2.copy$prev1,"-/",ngram.2.copy$nextToken,"-/")
nTree<-FromDataFrameTable(ngram.2.copy, pathName = "pathString", pathDelimiter = "/",
                   colLevels = NULL, na.rm = TRUE, check = c("no-check"))

nc<-(FromDataFrameTable(head(ngram.2.copy,10), pathName = "pathString", pathDelimiter = "/",
                                        colLevels = NULL, na.rm = TRUE, check = c("no-check")))
nTree$AddChildNode(nc)


nTree$add
print(nTree,"Freq")

nTree2<-as.Node.data.frame()

ng<-nTree$root

ng$Get("Freq")

ng$Get("ng-/a-/")
ng$Climb("ng-/a-/")


head(ngram.2.copy)
nTree$Get("ng-/aaa-/","Freq")

df<-as.data.frame(nTree)

nTree$Climb(position=2,pathString="ng-/aaa-/")$Freq

save(nTree,file="data/ngrams/web/w2tree.RData")


## sqllite

library(sqldf)
db <- dbConnect(SQLite(), dbname="Test.sqlite")

dbWriteTable(conn = db, name = "ngram2test", value = head(ngram.2), row.names = FALSE)
dbWriteTable(conn = db, name = "ngram2", value = ngram.2, row.names = FALSE)
dbDisconnect(db)            # Close connection

testDf<-dbReadTable(conn=db,name="ngram2")
head(testDf)

file.size("Test.sqlite")/1024/1024
#Larger than original text file size--21.8 MB


## Try RDS with 3-gram file
inputfile<-"data/ngrams/web/w3_.txt"
file.size(inputfile)/1024/1024
# original file size was 19.45MB

con<-file(inputfile,"r")
ngram.3<-read.table(con)
close(con)

colnames(ngram.3)<-c("Freq","Prev1","Prev2","nextToken")
head(ngram.3)




outputFileRDS<-"data/ngrams/web/w3.RData"

start_time<-Sys.time()
save(ngram.3,file=outputFileRDS)
end_time<-Sys.time()

file.size(outputFileRDS)/1024/1024
# after storing as RDS the size reduced to 3.6MB. Writing was fast
end_time-start_time
## 1.51Sec

ngram<-ngram.2
colnames(ngram)<-c("Freq","prevToken","nextToken")
head(ngram)

ngram<-rbind(ngram.2,ngram.3[,])

head(ngram)

ngram.3$prevToken<-paste(ngram.3$Prev1,ngram.3$Prev2)
head(ngram.3)

ngram<-rbind(ngram.2,ngram.3[,])

ngram.3[,c("Freq","prevToken","nextToken")]

head(ngram.2)
colnames(ngram.2)<-c("Freq","prevToken","nextToken")
head(ngram.3)
ngram<-rbind(ngram,ngram.3[,c("Freq","prevToken","nextToken")])
outputFileRDS<-"data/ngrams/web/w3_prevcombined.RData"
save(ngram.3,file=outputFileRDS)
file.size(outputFileRDS)/1024/1024

min(ngram$Freq)

plot(log10(ngram$Freq))

ngram.3.copy<-ngram.3

head(ngram.3.copy)
ngram_alt<-cbind()


