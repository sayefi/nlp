library(data.table)

load("data/output/op/my_ngram1t4_01_20_2018.RData")


NG<-data.table(ngram)

save(NG,file="data/output/op/my_ngram1t4DT_01_20_2018.RData")
