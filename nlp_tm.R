# download.packages("tm")


library(tm)

#remove.packages(tm)
#install.packages("http://cran.r-project.org/bin/windows/contrib/3.0/tm_0.5-10.zip",repos=NULL)
library(tm)
#install.packages("filehash")
library(filehash)


docs <- Corpus(DirSource("data/sample/"))

docs

CMetaData(docs)

summary(docs)



start_time<-Sys.time()
dtm<-DocumentTermMatrix(docs)
end_time<-Sys.time()
end_time-start_time

object.size(docs)

dtm

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


## result_df contains the basic summary


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
