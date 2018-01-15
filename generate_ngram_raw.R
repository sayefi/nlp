library(tm)

library(slam)
# install.packages("SnowballC")
# install.packages("RWeka")
library(SnowballC)
library(RWeka)

fileURL<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
inputFile<-"data/SwiftKey.zip"
en_tw_path<-"data/final/en_US/en_US.twitter.txt"

## check whether the file is already downloaded in project folder

if(!file.exists(en_tw_path))
{
     ## Downloading file
     download.file(fileURL,inputFile,"curl")
     
     ## Unziping file in data directory
     unzippedFile<-"data/."
     unzip(inputFile,exdir=unzippedFile)
}


base_path<-"data/final/en_US/"
filepaths<-paste0(base_path,dir(base_path))

con<-lapply(filepaths,file,open="r")
lines<-lapply(con,readLines,encoding="UTF-8",skipNul=TRUE)
a<-lapply(con,close)

line_length<-lapply(lines,nchar)
# no_of_chars<-lapply(line_length,sum)
no_of_lines<-lapply(line_length,length)
# max_line_length<-lapply(line_length,max)
# file_size<-lapply(lapply(lines, object.size),format,units="MB")


sample_no_of_lines_per_file<-round(sum(as.numeric(no_of_lines))*.05/3,0)
# total_size<-object.size(lines)
# file_size<-as.numeric(lapply(lines,object.size))
# file_size_proportion<-file_size/total_size

set.seed(35546)

getLineSample <- function(x,size) {
     sample(x,size)
}

linesSample<-lapply(lines,getLineSample,sample_no_of_lines_per_file)

sample_size<- format(object.size(linesSample),units="MB")

rm(lines)
rm(line_length)

mygsub <- function(x,p,r) { 
     
     #wrapper function for easy gsub usage in lapply
     gsub(p,r,x)
}
linesClean<-lapply(linesSample,mygsub,"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"," ")
linesClean<-lapply(linesClean,mygsub,"\\?\\!",".")
linesClean<-lapply(linesClean,mygsub,"[^[:print:][:punct:]]"," ")

docs<-VCorpus(VectorSource(linesClean))

docs <- tm_map(docs, removeNumbers)
#remove stopwords using the standard list in tm

docs <- tm_map(docs, removePunctuation)

# docs <- tm_map(docs, tolower)

docs_rm_stop <- tm_map(docs, removeWords, stopwords("english"))

stopwords("english")

rm(linesClean)
rm(linesSample)


BigramTokenizer <- function(x) 
{
     RWeka::NGramTokenizer(x, RWeka::Weka_control(min=2, max=2))
}

options(mc.cores=1)
start_time<-Sys.time()
dtm.2g <- DocumentTermMatrix(docs_rm_stop, control=list(tokenize=BigramTokenizer))
end_time<-Sys.time()
time_taken_2g<-end_time-start_time

rm(docs_rm_stop)

# sums.2g <- colapply_simple_triplet_matrix(dtm.docs.2g,FUN=sum)
# sums.2g <- sort(sums.2g, decreasing=T)

freq2g <- colSums(as.matrix(dtm.2g))

totalFreq2g<-length(freq2g[freq2g>1])
#create sort order (descending)
ord <- order(freq2g,decreasing=TRUE)

# freq[head(ord,freq2g)]

terms2g<-freq2g[head(ord,totalFreq2g)]

## making changes ... taking all 2-grams
# terms2g<-freq2g

totalTerm2Occ<-sum(terms2g)

terms2_df<-as.data.frame(c("terms2g","freq"))

terms2_df<-cbind(names(terms2g),terms2g)

colnames(terms2_df)<-c("terms2g","freq")

head(terms2_df)

term2outputFile<-"data/output/term2list.txt"
con<-file(term2outputFile,"w")
write.csv(terms2_df,con)
# writeLines(names(terms2g),con)
close(con)
