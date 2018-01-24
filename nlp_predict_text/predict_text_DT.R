library(dplyr)
library(stringr)
library(stringi)
library(tm)
library("RWeka")
library(RWekajars)
library(data.table)
library(varhandle)

# input<-"here you"



# load("https://sayefi.shinyapps.io/nlp_predict_text/my_ngram1t4c_01_20_2018.RData")

# load("my_ngram1t4c_01_20_2018.RData", envir = .GlobalEnv)
# smaller n-gram
load("my_ngram1t4DT_01_20_2018.RData", envir = .GlobalEnv)
setkey(NG,prevToken)

getTokens<-function(input)
{
     docs<-VCorpus(VectorSource(input))
     
     docs <- tm_map(docs, removeNumbers)
     docs <- tm_map(docs, tolower)
     #remove stopwords using the standard list in tm
     # docs <- tm_map(docs, removeWords, stopwords("english"))
     docs <- tm_map(docs, removePunctuation)
     # docs <- tm_map(docs, stemDocument, language = c("english"), lazy = TRUE)
     
     tokens<-NGramTokenizer(docs, Weka_control(min = 1, max = 1))
     
     tokens[tokens %in% NG$nextToken]
}




predict_text_linear<-function(tokens,lambda)
{
     
     result<-data.frame()
     i<-2
     for(i in min(length(tokens),4-1):1)
     {
          # print(paste("Lets check with word(s):",i))
          
          searchToken<-""
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               searchToken<-paste0(searchToken,tokens[j]," ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          # print(paste("Search Token:",searchToken))
          
          res_df<-NG[searchToken]
          
          
          # print(res_df)
          
          
          
          if(dim(res_df)[1]>1)
          {
               res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[i+1]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
               
               
          }
          
          
     }
     
     ## Making some change at Jan 13, 3:48 PM
     ## what about add all 1-grams
     
     # if(dim(result)[1]>0)
     # {
     #      res_df<-filter(ngram, type==1,nextToken %in% result$nextToken)
     # }else
     # {
     #      res_df<-filter(ngram,type==1)
     # }
     
     # stopping 1-gram addition in for shiny Jan 21,2:30pm
     res_df<-NG[""]
     res_df<-filter(res_df,freq>1000)
     # res_df<-ngram %>% filter(type==1) %>% filter(freq>1000)
     res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     # 
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))

}
