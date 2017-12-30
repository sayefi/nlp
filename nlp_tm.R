# download.packages("tm")


library(tm)

#remove.packages(tm)
#install.packages("http://cran.r-project.org/bin/windows/contrib/3.0/tm_0.5-10.zip",repos=NULL)
# library(tm)
#install.packages("filehash")
# library(filehash)


# docs <- Corpus(DirSource("data/sample/"))
# 
# docs
# 
# CMetaData(docs)
# 
# summary(docs)
# 
# 
# 
# start_time<-Sys.time()
# dtm<-DocumentTermMatrix(docs)
# end_time<-Sys.time()
# end_time-start_time
# 
# object.size(docs)
# 
# dtm

## --------------------------------------------------------------------

result_df<-data.frame()

filepaths<-paste0("data/final/en_US/",dir("data/final/en_US/"))

result_df<-cbind(file_names=dir("data/final/en_US/"))

con<-lapply(filepaths,file,open="r")

con


lines<-lapply(con,readLines,encoding="UTF-8",skipNul=TRUE)

lapply(con,close)

## size of file
summary(lines)[,1]


line_length<-lapply(lines,nchar)

no_of_lines<-lapply(line_length,sum)

result_df<-cbind(result_df,no_of_lines)

max_line_length<-lapply(line_length,max)

result_df<-cbind(result_df,max_line_length)

result_df
## result_df contains the basic summary


mySample <- function(x,p) {
     sample(x,length(x)*p)
}

## 

set.seed(35546)
linesSample<-lapply(lines,mySample,0.05)

lines<-linesSample

mygsub <- function(x,p,r) { 
     
     #wrapper function for easy gsub usage in lapply
     gsub(p,r,x)
}
linesClean<-lapply(linesSample,mygsub,"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"," ")
linesClean<-lapply(linesClean,mygsub,"\\?\\!",".")
linesClean<-lapply(linesClean,mygsub,"[^[:print:][:punct:]]"," ")


docs<-VCorpus(VectorSource(linesClean))

#docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
#remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)
# docs <- tm_map(docs, stemDocument, language = c("english"), lazy = TRUE)


dtm <- DocumentTermMatrix(docs)

freq <- colSums(as.matrix(dtm))

#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

#inspect most frequently occurring terms
freq[head(ord)]

# inspect(dtm[1:3,1:1000])

word_matrix<-inspect(dtm[1:3,head(ord,25)])

rownames(word_matrix)<-c("blogs","news","twitter")


# barplot(word_matrix, main="Frequnecy of words", ylab= "Total", col=heat.colors(3),cex.names = .8)


word_matrix

library(reshape2)

df<-melt(word_matrix)

df

library(ggplot2)

g = ggplot(data=df,aes(x=Terms,fill=factor(Docs),y=value))
g = g + geom_bar(stat = "identity", position = "stack")
g






library(ggplot2)

colnames(df)

plot(df)



freqTerms<-findFreqTerms(dtm,lowfreq=1000)

freqTerms

BigramTokenizer <- function(x) 
{
     RWeka::NGramTokenizer(x, RWeka::Weka_control(min=2, max=2))
}

library(slam)
# install.packages("SnowballC")
# install.packages("RWeka")
library(SnowballC)
library(RWeka)
options(mc.cores=1)
dtm.docs.2g <- DocumentTermMatrix(docs, control=list(tokenize=BigramTokenizer))

sums.2g <- colapply_simple_triplet_matrix(dtm.docs.2g,FUN=sum)
sums.2g <- sort(sums.2g, decreasing=T)

head(sums.2g)

inspect(dtm.docs.2g[1:3,1:100])

tail(sums.2g)

str(sums.2g)

hist(sums.2g)

sums.2g[sums.2g>100]


MultiTokenizer <- function(x) 
{
     RWeka::NGramTokenizer(x, RWeka::Weka_control(min=2, max=5))
}

dtm.docs.2g <- DocumentTermMatrix(docs, control=list(tokenize=MultiTokenizer))

sums.2g <- colapply_simple_triplet_matrix(dtm.docs.2g,FUN=sum)
sums.2g <- sort(sums.2g, decreasing=T)

head(sums.2g)

inspect(dtm.docs.2g[1:3,1:100])

tail(sums.2g)

str(sums.2g)

hist(sums.2g)

sums.2g[sums.2g>1000]


head(findAssocs(dtm,"you",.8))

dtm

hist(df)


summary(docs)


lapply(lines,grep,)

grep(lines[1],"[A-Za-z]* ")





result_df




filepaths[2]

str(line_length)



length(lines[1])

dim(lines[1])


## use of database

docs <- PCorpus(DirSource("data/sample/"), readerControl 
                                                  = list(reader=readPlain,
                                                  language="en",
                                                  load=TRUE),
                                        dbControl=list(useDb=TRUE,
                                                  dbName = "data/tmdb",
                                                  dbType="DB1"))

start_time<-Sys.time()
dtm<-DocumentTermMatrix(docs)
end_time<-Sys.time()
end_time-start_time
object.size(docs)

summary(docs)


## use of database, w/ large docs

docs <- PCorpus(DirSource("data/final/en_US/"), readerControl 
                = list(reader=readPlain,
                       language="en",
                       load=TRUE),
                dbControl=list(useDb=TRUE,
                               dbName = "data/tmdb",
                               dbType="DB1"))

start_time<-Sys.time()
dtm<-DocumentTermMatrix(docs)
end_time<-Sys.time()
end_time-start_time
object.size(docs)

summary(docs)



docs

start_time<-Sys.time()
dtm<-DocumentTermMatrix(docs)
end_time<-Sys.time()
end_time-start_time


dtm

freq <- colSums(as.matrix(dtm))

freq[1000:1010]

ord <- order(freq,decreasing=TRUE)

freq[ord[1:10]]
