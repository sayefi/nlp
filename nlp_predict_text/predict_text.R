library(dplyr)
library(stringr)
library(stringi)
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
     
     # tokens[tokens %in% ngram$nextToken]
}


getTokens_3<-function(input,option)
{
     
     docs<-VCorpus(VectorSource(input))
     
     docs <- tm_map(docs, removeNumbers)
     #remove stopwords using the standard list in tm
     if(option==1)
     {
          docs_ <- tm_map(docs, removeWords, stopwords("english"))     
     }
     
     docs <- tm_map(docs, removePunctuation)
     
     if(option==2)
     {
          docs <- tm_map(docs, stemDocument, language = c("english"), lazy = TRUE)     
     }
     
     if(option==3)
     {
          docs <- tm_map(docs, removeWords, stopwords("english"))
          docs <- tm_map(docs, stemDocument, language = c("english"), lazy = TRUE)
          
     }
     
     tokens<-NGramTokenizer(docs, Weka_control(min = 1, max = 1))
}

getTokens_v2<-function(input)
{
     input<-stri_trans_tolower(input)
     docs<-VCorpus(VectorSource(input))
     
     docs <- tm_map(docs, removeNumbers)
     # docs <- tm_map(docs, tolower)
     # docs <- tm_map(docs, removeWords, stopwords)
     docs <- tm_map(docs, removePunctuation)
     docs <- tm_map(docs, stemDocument, language = c("english"))
     
     tokens<-NGramTokenizer(docs, Weka_control(min = 1, max = 1))
}



predict_text_backoff<-function(tokens)
{
     
     result<-data.frame()

     for(i in min(length(tokens),4-1):1)
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
               res_df$prob<-res_df$freq/sum(res_df$freq)*.4^(6-i-1)
               result<-res_df[,c("prevToken","nextToken","prob")]
               break;
               
          }
               
          
     }
     
     result<-arrange(result,desc(prob))
     
}


predict_text_linear<-function(tokens,lambda)
{
     
     result<-data.frame()

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
          
          res_df<-ngram[ngram$prevToken==searchToken,]
          
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
     res_df<-ngram %>% filter(type==1) %>% filter(freq>1000)
     res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     # 
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}


predict_text_linear_stemmed<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     for(i in min(length(tokens),4-1):1)
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
          
          res_df<-head(ngram[ngram$prevToken==searchToken,],5)
          
          print(res_df)
          
          
          
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
     
     res_df<-filter(ngram,type==1)
     res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     # 
     # result<-group_by(result,nextToken)
     # result<-summarize(result,prob=sum(prob))
     # result<-arrange(result,desc(prob))
     
     
}


predict_text_linear_v4<-function(tokens,lambda)
{
     
     result<-data.frame()
     i<-2
     for(i in min(length(tokens),4-1):1)
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
          
          ## skip-gram
          ## with 3-gram skip the middle word
          if(i==2)
          {
               searchToken<-paste(tokens[length(tokens)-2],tokens[length(tokens)])
               # searchToken<-trimws(searchToken)
               print(paste("Search Token:",searchToken))
               
               res_df<-ngram[ngram$prevToken==searchToken,]
               
               print(res_df)
               if(dim(res_df)[1]>1)
               {
                    res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[i+1]
                    result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
                    
                    
               }
               
          }
          ## with 2-gram 
          if(i==1)
          {
               #skip the last word
               searchToken<-tokens[length(tokens)-1]
               # searchToken<-trimws(searchToken)
               print(paste("Search Token:",searchToken))
               
               res_df<-ngram[ngram$prevToken==searchToken,]
               
               print(res_df)
               if(dim(res_df)[1]>1)
               {
                    res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[i+1]
                    result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
                    
                    
               }
               
               #skip last 2 workds
               searchToken<-tokens[length(tokens)-2]
               # searchToken<-trimws(searchToken)
               print(paste("Search Token:",searchToken))
               
               res_df<-ngram[ngram$prevToken==searchToken,]
               
               print(res_df)
               if(dim(res_df)[1]>1)
               {
                    res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[i+1]
                    result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
                    
                    
               }
               
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
     
     ## limiting result again Jan 17
     res_df<-filter(ngram,type==1)
     # res_df<-head(filter(ngram, type==1,nextToken %in% result$nextToken),6)
     
     res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}

predict_text_linear_v3<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     i<-1
     for(i in min(length(tokens),6-1):1)
     {
          print(paste("Lets check with word(s):",i))
          
          searchToken<-"^"
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               searchToken<-paste0(searchToken,tokens[j],"[a-z]* ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          print(paste("Search Token:",searchToken))
          
          ngram.f<-filter(ngram,type==(i+1))
          l<-grep(searchToken,ngram.f$prevToken)
          
          
          
          
          
          
          if(length(l)>0)
          {
               res_df<-ngram.f[l,]
               
               print(res_df)
               
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
     
     res_df<-filter(ngram,type==1)
     res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}

predict_text_linear_v2<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     for(i in min(length(tokens),6-1):1)
     {
          print(paste("Lets check with word(s):",i))
          
          searchToken<-""
          for(j in (length(tokens)-i+1):(length(tokens)))
          {
               # print(j)
               ## adding logic to remove last token if it is stopword
               # jan 14 10:54pm
               
               if(j==length(tokens) && tokens[j] %in% stopwords)
                    break
               
               searchToken<-paste0(searchToken,tokens[j]," ")
               
          }
          
          searchToken<-trimws(searchToken)
          
          ## further changes to remove stop-words while searching for 2-grams
          ## Jan 14 7:39pm
          
          # if(searchToken %in% stopwords && length(tokens)>1)
          # {
          #      searchToken<-tokens[length(tokens)-1]
          # }
          
          ## end
          ## remove this logic
          
          print(paste("Search Token:",searchToken))
          
          res_df<-ngram[ngram$prevToken==searchToken,]
          
          print(res_df)
          
          
          ## dim(res_df)[1]>1...was wrong. corrected on Jan 17
          if(dim(res_df)[1]>0)
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
     
     
     
     ## Changes on Jan 14, 7PM
     ## Don't add 1-grams, rather add 2-grams based on 1 skip
     # res_df<-filter(ngram,type==1)
     # res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[1]
     # result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     # 
     
     # adding this back again at Jan 14 11:23am
     if(length(tokens)>1)
     {
          searchToken<-tokens[length(tokens)-1]
          res_df<-ngram[ngram$prevToken==searchToken,]

          if(dim(res_df)[1]>0)
          {
               res_df$prob<-res_df$freq/sum(res_df$freq)*lambda[2]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))


          }
     }
     
     ## not worked, didn't add 1-gram back
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
}

# filter(result,nextToken=="insane")



predict_text_linear_add_one<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     # nv<-ngram %>% group_by(type) %>% dplyr::summarise(n()) %>% select(`n()`) 
     nv<-ngram %>% group_by(type) %>% dplyr::summarise(n()) 
     # nv$`n()`[1]
     V<-nv$`n()`

     
     # i<-1
     for(i in min(length(tokens),6-1):1)
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
          
          
          
          if(dim(res_df)[1]>0)
          {
               str(V)
               i
               V[i]
               res_df$prob<-(res_df$freq+1)/(sum(res_df$freq)+V[i+1])*lambda[i+1]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
               
               
          }
          
          
     }
     
     
     if(dim(result)[1]>1)
     {
          res_df<-filter(ngram, type==1,nextToken %in% result$nextToken)
     }
     else
     {
          res_df<-filter(ngram,type==1)
     }
     
     
     res_df$prob<-(res_df$freq+1)/(sum(res_df$freq)+V[1])*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
     
}


predict_text_linear_add_half<-function(tokens,lambda)
{
     
     result<-data.frame()
     
     # nv<-ngram %>% group_by(type) %>% dplyr::summarise(n()) %>% select(`n()`) 
     nv<-ngram %>% group_by(type) %>% dplyr::summarise(n()) 
     # nv$`n()`[1]
     V<-nv$`n()`
     
     
     # i<-1
     for(i in min(length(tokens),6-1):1)
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
          
          
          
          if(dim(res_df)[1]>0)
          {
               str(V)
               i
               V[i]
               res_df$prob<-(res_df$freq+.5)/(sum(res_df$freq)+V[i+1]*.5)*lambda[i+1]
               result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
               
               
          }
          
          
     }
     
     
     if(dim(result)[1]>1)
     {
          res_df<-filter(ngram, type==1,nextToken %in% result$nextToken)
     }
     else
     {
          res_df<-filter(ngram,type==1)
     }
     
     
     res_df$prob<-(res_df$freq+.5)/(sum(res_df$freq)+V[1]*.5)*lambda[1]
     result<-rbind(result,cbind(res_df[,c("prevToken","nextToken","prob")]))
     
     
     result<-group_by(result,nextToken)
     result<-summarize(result,prob=sum(prob))
     result<-arrange(result,desc(prob))
     
     
     
}



# head(result[1],100)

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



