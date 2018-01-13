## create .Rdata file from my raw n-grams

library(dplyr)
library(stringr)
inputpath<-"data/output/raw"
dir.exists(inputpath)

files<-paste0(inputpath,"/",dir(inputpath))
files
con<-lapply(files,file)
con

ngram_raw<-lapply(con,read.csv)
lapply(con,close)

head(ngram_raw[1])

str(ngram_raw)
ngram_orig[1]

## Testing size if stored at this point
## also, failsafe if this program crashes
filepath<-"data/output/tmp/my_ngram_raw2018-01-12.RData"
save(ngram_raw,file=filepath)


##requires clean-up of some n-grams
##otherwise the files will be too large...145MB
file.size(filepath)/1024/1024

##working with 3-grams
head(ngram_raw[[3]])
ngram_raw[[3]]$freq
quantile(ngram_raw[[3]]$freq)
#min freq is 2

## formatting 3-gram, sample code
# ngram.3$prevToken<-paste(ngram.3$V2,ngram.3$V3)
# ngram.3$nextToken<-ngram.3$V4
# ngram.3$type<-3
# ngram.3<-select(ngram.3,- c(V2,V3,V4))
# head(ngram.3)


ngram.3<-ngram_raw[[3]]
ngram.3$prevToken<-paste(word(ngram.3$terms3g,1),word(ngram.3$terms3g,2))
ngram.3$nextToken<-word(ngram.3$terms3g,-1)
ngram.3$type<-3
ngram.3<-select(ngram.3,- c(X,terms3g))
head(ngram.3)


##working with 2-grams
head(ngram_raw[[2]])
quantile(ngram_raw[[2]]$freq)
## may not be enough
## we may need to revisit 2-gram generation code to take 2 occurances
## no filtering required here

ngram.2<-ngram_raw[[2]]
ngram.2$prevToken<-word(ngram.2$terms2g,1)
ngram.2$nextToken<-word(ngram.2$terms2g,-1)
ngram.2$type<-2
ngram.2<-select(ngram.2,- c(X,terms2g))
head(ngram.2)


##working with 1-grams
head(ngram_raw[[1]])
quantile(ngram_raw[[1]]$freq)
## may not be enough...has freq more that 10
## no filtering required here

ngram.1<-ngram_raw[[1]]
colnames(ngram.1)<-c("prevToken","nextToken","freq")
ngram.1$type<-1
ngram.1$prevToken<-""
ngram.1<-ngram.1[,c("freq","prevToken","nextToken","type")]
head(ngram.1)


###Better safe than sorry,save the formatted n-grams (1-3)
ngram<-rbind(ngram.3,ngram.2,ngram.1)
head(ngram)
# colnames(ngram)<-c("freq","prevToken","nextToken","type")
# filter(ngram,type==2)
save(ngram,file="data/output/tmp/my_ngram_1to3_2018_01_13.RData")
file.size(file="data/output/tmp/my_ngram_1to3_2018_01_13.RData")/1024/1024
### 2.4MB only


##working with 4-grams
head(ngram_raw[[4]])
quantile(ngram_raw[[4]]$freq)
dim(ngram_raw[[4]])
## min freq is 1...too low..file size is 212MB, 4Million
## setting min freq>=2 will reduce it by atleast 75%

ngram.4<-filter(ngram_raw[[4]],freq>1)
# head(ngram.4)
# quantile(ngram.4$freq)
dim(ngram.4)[1]/dim(ngram_raw[[4]])[1]
# taking only 3% of 4Million...estimated size 6MB

ngram.4$prevToken<-paste(word(ngram.4$terms4g,1),word(ngram.4$terms4g,2),word(ngram.4$terms4g,3))
ngram.4$nextToken<-word(ngram.4$terms4g,-1)
ngram.4$type<-4
ngram.4<-select(ngram.4,- c(X,terms4g))
head(ngram.4)


##working with 5-grams
head(ngram_raw[[5]])
quantile(ngram_raw[[5]]$freq)
dim(ngram_raw[[5]])
## min freq is 1...too low..file size is 179MB, again 4Million
## setting min freq>=2 will reduce it by atleast 75%

ngram.5<-filter(ngram_raw[[5]],freq>1)
# head(ngram.5)
# quantile(ngram.5$freq)
dim(ngram.5)[1]/dim(ngram_raw[[5]])[1]
# taking less than a %...estimated size 1.8MB..shuuuu

ngram.5$prevToken<-paste(word(ngram.5$terms,1),word(ngram.5$terms,2),word(ngram.5$terms,3),word(ngram.5$terms,4))
ngram.5$nextToken<-word(ngram.5$terms,-1)
ngram.5$type<-5
ngram.5<-select(ngram.5,- c(X,terms))
head(ngram.5)


##working with 6-grams
head(ngram_raw[[6]])
quantile(ngram_raw[[6]]$freq)
dim(ngram_raw[[6]])
## min freq is 3... and only 1869 terms.. may be too low
## however, mind it, how resource consuming the 6-gram generation process can be

ngram.6<-ngram_raw[[6]]
# head(ngram.5)
# quantile(ngram.5$freq)
dim(ngram.6)[1]/dim(ngram_raw[[6]])[1]
# taking 100%...

ngram.6$prevToken<-paste(word(ngram.6$terms,1),word(ngram.6$terms,2),
                         word(ngram.6$terms,3),word(ngram.6$terms,4),
                         word(ngram.6$terms,5))

ngram.6$nextToken<-word(ngram.6$terms,-1)
ngram.6$type<-6
ngram.6<-select(ngram.6,- c(X,terms))
head(ngram.6)


## now saving
timestamp<-format(Sys.Date(),"%m_%d_%Y")
filePath<-paste0("data/output/op/my_ngram_",timestamp,".RData")
ngram<-rbind(ngram.6,ngram.5,ngram.4,ngram.3,ngram.2,ngram.1)
save(ngram,file=filePath)

s<-file.size(filePath)

print(paste("File size:",round(s/1024/1024,2),"MB"))
