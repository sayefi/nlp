library(dplyr)


load("data/ngrams/web/ngram_web2018-01-10.RData")
ngram_web<-ngram

load("data/output/op/my_ngram1t4_01_20_2018.RData")

## no 1-gram in web
# filter(ngram_web,type==1)


## find 2-grams that are in web but not in my ngram

ngram_web.2<-filter(ngram_web,type==2)

ngram.2<-filter(ngram,type==2)

ngram_web.2$term<-paste(ngram_web.2$prevToken,ngram_web.2$nextToken)

ngram.2$term<-paste(ngram.2$prevToken,ngram.2$nextToken)

ngram_web.2$term<-gsub("[^[:print:][:punct:]]","" , ngram_web.2$term ,ignore.case = TRUE)

not_found.2<-!(ngram_web.2$term %in% ngram.2$term) 

sum(not_found.2)

plot(log10(arrange(ngram_web.2[not_found.2,],desc(freq))$freq))

not_found.2<-!(ngram_web.2$term %in% ngram.2$term) & ngram_web.2$freq>=100

sum(not_found.2)

ngram.2.new<-ngram_web.2[not_found.2,]

ngram.2.new$freq<-round(ngram.2.new$freq/100,0)

ngram.2.new[ngram.2.new$prevToken=="little",]

ngram.2.new<-select(ngram.2.new,-term)


## same adjustment in 3-gram

ngram_web.3<-filter(ngram_web,type==3)

ngram.3<-filter(ngram,type==3)

ngram_web.3$term<-paste(ngram_web.3$prevToken,ngram_web.3$nextToken)

ngram.3$term<-paste(ngram.3$prevToken,ngram.3$nextToken)

ngram_web.3$term<-gsub("[^[:print:][:punct:]]","" , ngram_web.3$term ,ignore.case = TRUE)

not_found.3<-!(ngram_web.3$term %in% ngram.3$term) 

sum(not_found.3)

plot(log10(arrange(ngram_web.3[not_found.3,],desc(freq))$freq))

not_found.3<-!(ngram_web.3$term %in% ngram.3$term) & ngram_web.3$freq>=100

sum(not_found.3)

ngram.3.new<-ngram_web.3[not_found.3,]

ngram.3.new$freq<-round(ngram.3.new$freq/100,0)

ngram.3.new[ngram.3.new$prevToken=="but the",]

ngram.3.new[ngram.3.new$prevToken=="must be",]

ngram.3.new<-select(ngram.3.new,-term)

## same adjustment in 4-gram

ngram_web.4<-filter(ngram_web,type==4)

ngram.4<-filter(ngram,type==4)

ngram_web.4$term<-paste(ngram_web.4$prevToken,ngram_web.4$nextToken)

ngram.4$term<-paste(ngram.4$prevToken,ngram.4$nextToken)

ngram_web.4$term<-gsub("[^[:print:][:punct:]]","" , ngram_web.4$term ,ignore.case = TRUE)

not_found.4<-!(ngram_web.4$term %in% ngram.4$term) 

sum(not_found.4)

plot(log10(arrange(ngram_web.4[not_found.4,],desc(freq))$freq))

not_found.4<-!(ngram_web.4$term %in% ngram.4$term) & ngram_web.4$freq>=50

sum(not_found.4)

ngram.4.new<-ngram_web.4[not_found.4,]

ngram.4.new$freq<-round(ngram.4.new$freq/100,0)

ngram.4.new[ngram.4.new$prevToken=="you must be",]

ngram.4.new<-select(ngram.4.new,-term)

## now saving
timestamp<-format(Sys.Date(),"%m_%d_%Y")
filePath<-paste0("data/output/op/my_ngram1t4c_",timestamp,".RData")
# ngram<-rbind(ngram.6,ngram.5,ngram.4,ngram.3,ngram.2,ngram.1)
ngram<-rbind(ngram,ngram.2.new,ngram.3.new,ngram.4.new)
save(ngram,file=filePath)

file.size(filePath)
