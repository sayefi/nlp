library(stringr)
library(tm)
library("RWeka")
library(RWekajars)

library(varhandle)

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
}

# nrow(nv)
nv<-group_by(ngram,type)
# nv
v<-summarise(nv,vc=n())
V<-v$vc
V

predict_text_backoff<-function(tokens)
{
     
     result<-data.frame()

     for(i in min(length(tokens),5-1):1)
     {
          print(paste("Lets check with word(s):",i))
          
          searchToken<-""
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               searchToken<-paste0(searchToken,tokens[j]," ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          print(paste("Search Token:",searchToken))
          
          res_df<-ngram[ngram$prevToken==searchToken,]
          
          print(res_df)
          
          
               
          if(dim(res_df)[1]>1)
          {
               res_df$prob<-res_df$freq/sum(res_df$freq)*.4^(5-i-1)
               result<-res_df[,c("prevToken","nextToken","prob")]
               break;
               
          }
               
          
     }
     
     result<-arrange(result,desc(prob))
     
}


predict_text_linear<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     for(i in min(length(tokens),5-1):1)
     {
          print(paste("Lets check with word(s):",i))
          
          searchToken<-""
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               searchToken<-paste0(searchToken,tokens[j]," ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          print(paste("Search Token:",searchToken))
          
          res_df<-ngram[ngram$prevToken==searchToken,]
          
          print(res_df)
          
          
          
          if(dim(res_df)[1]>1)
          {
               res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[i+1]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
               
               
          }
          
          
     }
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}



predict_text_linear_add_one<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     
     for(i in min(length(tokens),5-1):1)
     {
          print(paste("Lets check with word(s):",i))
          
          searchToken<-""
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               searchToken<-paste0(searchToken,tokens[j]," ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          print(paste("Search Token:",searchToken))
          
          res_df<-ngram[ngram$prevToken==searchToken,]
          
          print(res_df)
          
          
          
          if(dim(res_df)[1]>1)
          {
               res_df$prob<-(res_df$freq+1)/(sum(res_df$freq)+10^6)*lambda[i+1]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
               
               
          }
          
          
     }
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}
# predict_text_backoff<-function(tokens,predict_settings)
# {
#      
#      result<-data.frame()
#      
#      for(i in min(length(tokens),5-1):1)
#      {
#           print(paste("Lets check with word(s):",i))
#           
#           searchToken<-""
#           for(j in (length(tokens)-i+1):(length(tokens)))
#           {
#                # print(j)
#                searchToken<-paste0(searchToken,tokens[j]," ")
#                
#           }
#           
#           searchToken<-trimws(searchToken)
#           
#           print(paste("Search Token:",searchToken))
#           
#           res_df<-ngram[ngram$prevToken==searchToken,]
#           
#           print(res_df)
#           
#           ## predict_setting ==1 for Backoff
#           if(predict_settings==1)
#           {
#                res_df$prob<-res_df$freq/sum(res_df$freq)*.4^(5-i-1)
#                
#                if(dim(res_df)[1]>1&&predict_settings==1)
#                {
#                     
#                     result<-res_df[,c("prevToken","nextToken","prob")]
#                     break;
#                     
#                }
#                
#           }
#           
#           
#           ## Linear Interpolation
#           if(predict_settings==2)
#           {
#                if(dim(res_df)[1]>1)
#                {
#                     ##.4 has to be replaced with lamda
#                     res_df$prob<-res_df$freq/sum(res_df$freq)*.4^(5-i-1)
#                     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
#                }
#                
#           }
#      }
#      
#      result
#      
# }
