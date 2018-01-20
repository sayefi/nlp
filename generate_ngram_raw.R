library(tm)

library(slam)
# install.packages("SnowballC")
# install.packages("RWeka")
library(SnowballC)
library(RWeka)

setwd("~/Data_Science/Projects/nlp")

stopwords = c("a", "about", "above", "after", "again", "against", "all", 
              "am", "an", "and", "any", "are", "arent", "as", "at", "be", "because", 
              "been", "before", "being", "below", "between", "both", "but", 
              "by", "cant", "cannot", "could", "couldnt", "did", "didnt", "do", 
              "does", "doesnt", "doing", "dont", "down", "during", "each", 
              "few", "for", "from", "further", "had", "hadnt", "has", "hasnt", 
              "have", "havent", "having", "he", "hed", "hell", "hes", "her", 
              "here", "heres", "hers", "herself", "him", "himself", "his", 
              "how", "hows", "i", "id", "ill", "im", "ive", "if", "in", "into", 
              "is", "isnt", "it", "its", "its", "itself", "lets", "me", "more", 
              "most", "mustnt", "my", "myself", "no", "nor", "not", "of", "off", 
              "on", "once", "only", "or", "other", "ought", "our", "ours", 
              "ourselves", "out", "over", "own", "same", "shant", "she", "shed", 
              "shell", "shes", "should", "shouldnt", "so", "some", "such", 
              "than", "that", "thats", "the", "their", "theirs", "them", "themselves", 
              "then", "there", "theres", "these", "they", "theyd", "theyll", 
              "theyre", "theyve", "this", "those", "through", "to", "too", 
              "under", "until", "up", "very", "was", "wasnt", "we", "wed", 
              "well", "were", "weve", "were", "werent", "what", "whats", "when", 
              "whens", "where", "wheres", "which", "while", "who", "whos", 
              "whom", "why", "whys", "with", "wont", "would", "wouldnt", "you", 
              "youd", "youll", "youre", "youve", "your", "yours", "yourself", 
              "yourselves", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
              "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", 
              "x", "y", "z")

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
# sample_no_of_lines<-round(as.numeric(no_of_lines)*.10/3,0)

# total_size<-object.size(lines)
# file_size<-as.numeric(lapply(lines,object.size))
# file_size_proportion<-file_size/total_size

save(lines,file="data/output/tmp/lines_2018_01_17.RData")

set.seed(35546)

getLineSample <- function(x,size) {
     sample(x,size)
}

# line_nos<-sample(no_of_lines[[1]],sample_no_of_lines[1])
# 
# 
# linesSample1<-sample(lines[[1]],sample_no_of_lines[1])
# linesSample2<-sample(lines[[2]],sample_no_of_lines[2])
# linesSample3<-sample(lines[[3]],sample_no_of_lines[3])
# 
# linesSample<-list(linesSample1,linesSample2,linesSample3)
# 
# 
# save(linesSample,file="data/output/tmp/lines_2018_01_17.RData")

# 
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

# linesClean<-stri_trans_tolower(linesClean)

docs<-VCorpus(VectorSource(linesClean))

docs <- tm_map(docs, removeNumbers)
#remove stopwords using the standard list in tm

docs <- tm_map(docs, removePunctuation)

# docs <- tm_map(docs, tolower)

# docs <- tm_map(docs, stemDocument, language = c("english"))

# docs_rm_stop <- tm_map(docs, removeWords, stopwords)

# not removing stop words
docs_rm_stop<-docs

# stopwords("english")

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

# rm(docs_rm_stop)

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

## -------------3-grams --------------------------------------------
TrigramTokenizer <- function(x) 
{
     RWeka::NGramTokenizer(x, RWeka::Weka_control(min=3, max=3))
}

options(mc.cores=1)
start_time<-Sys.time()
dtm.3g <- DocumentTermMatrix(docs_rm_stop, control=list(tokenize=TrigramTokenizer))
end_time<-Sys.time()
time_taken_3g<-end_time-start_time

# sums.2g <- colapply_simple_triplet_matrix(dtm.docs.2g,FUN=sum)
# sums.2g <- sort(sums.2g, decreasing=T)

freq <- colSums(as.matrix(dtm.3g))

freq3g<-length(freq[freq>1])


#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

terms3g<-freq[head(ord,freq3g)]

# head(terms3g)

totalTerm3Occ<-sum(terms3g)

terms3_df<-as.data.frame(c("terms3g","freq"))

terms3_df<-cbind(names(terms3g),terms3g)

colnames(terms3_df)<-c("terms3g","freq")

head(terms3_df)


term3outputFile<-"data/output/term3list.txt"
con<-file(term3outputFile,"w")
# writeLines(names(terms3g),con)
write.csv(terms3_df,con)
close(con)


## ------------------------- 4-gram---------------------------------------
QuadgramTokenizer <- function(x) 
{
     RWeka::NGramTokenizer(x, RWeka::Weka_control(min=4, max=4))
}

options(mc.cores=1)
start_time<-Sys.time()
dtm.4g <- DocumentTermMatrix(docs_rm_stop, control=list(tokenize=QuadgramTokenizer))
end_time<-Sys.time()
time_taken_4g<-end_time-start_time

# sums.2g <- colapply_simple_triplet_matrix(dtm.docs.2g,FUN=sum)
# sums.2g <- sort(sums.2g, decreasing=T)

freq <- colSums(as.matrix(dtm.4g))

freq4g<-length(freq[freq>2])
# freq4g<-length(freq)
#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

# freq[head(ord,freq4g)]

terms4g<-freq[head(ord,freq4g)]
totalTerm4Occ<-sum(terms4g)


terms4_df<-as.data.frame(c("terms4g","freq"))

terms4_df<-cbind(names(terms4g),terms4g)

colnames(terms4_df)<-c("terms4g","freq")

head(terms4_df)

term4outputFile<-"data/output/term4list.txt"
con<-file(term4outputFile,"w")
# writeLines(names(terms4g),con)
write.csv(terms4_df,con)
close(con)

## 1 grams------------------------------------------------------
start_time<-Sys.time()
dtm <- DocumentTermMatrix(docs_rm_stop)
end_time<-Sys.time()
time_taken_freq_terms<-end_time-start_time

freq <- colSums(as.matrix(dtm))

freqTerms1<-length(freq[freq>10])

#create sort order (descending)
ord <- order(freq,decreasing=TRUE)

terms1<-freq[head(ord,freqTerms1)]

totalTerm1Occ<-sum(terms1)

terms1_df<-as.data.frame(c("terms","freq"))

# names(terms1)
terms1_df<-cbind(names(terms1),terms1)

# dim(terms1_df)
colnames(terms1_df)<-c("terms1","freq")

# head(terms1_df)



term1outputFile<-"data/output/term1list.txt"
con<-file(term1outputFile,"w")
write.csv(terms1_df,con)
# writeLines(names(terms1),con)
close(con)
