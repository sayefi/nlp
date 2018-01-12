## create .Rdata file from my raw n-grams

library(dplyr)
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

head(ngram_raw[3])
ngram_raw[[3]]$freq
quantile(ngram_raw[[3]]$freq)
str(ngram_raw[[3]])

quantile(ngram_raw[[4]]$freq)

quantile(ngram_raw[[5]]$freq)

quantile(ngram_raw[[6]]$freq)
