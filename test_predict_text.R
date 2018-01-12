

source('~/Data_Science/Projects/nlp/predict_text.R')

load("data/ngrams/web/ngram_web2018-01-10.RData")

inputTxt<-"Hey sunshine, can you follow me and make me the"
inputTxt<-"Very early observations on the Bills game: Offense still struggling but the"
inputTxt<-"If this isn't the cutest thing you've ever seen, then you must be"
inputTxt<-"The guy in front of me just bought a pound of bacon, a bouquet, and a case of"

tokens<-getTokens(inputTxt)

# length(tokens)

res<-predict_text_backoff(tokens)

res<-predict_text_linear(tokens,lambda=c(0.4^5,0.4^4,0.4^3,0.4^2,0.4))

res<-predict_text_linear(tokens,lambda=c(0.05,0.1,0.15,0.3,0.4))

res<-predict_text_linear_add_one(tokens,lambda=c(0.05,0.1,0.15,0.3,0.4))


res<-predict_text_linear_add_one(tokens,lambda=c(0.4^5,0.4^4,0.4^3,0.4^2,0.4))
head(res)

res
lambda[1]

head(arrange(result,desc(prob)))

result<-group_by(result,nextToken)

result<-summarize(result,prob=sum(prob))


head(result)
head(res_df)

result

ngram[ngram$prevToken]
