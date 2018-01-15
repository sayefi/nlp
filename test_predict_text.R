

source('~/Data_Science/Projects/nlp/predict_text.R')

load("data/output/op/my_ngram_01_14_2018.RData")

##[1]
inputTxt<-"The guy in front of me just bought a pound of bacon, a bouquet, and a case of"
## Ans - Beer
## Backoff works...but its very week


## leanar - Beer becomes the 2nd choice...it could be a poor choice of lambda or not fixing the terms not included in the model
## lambda - lambda=c(0.4^6,0.4^5,0.4^4,0.4^3,0.4^2,0.4)
## Choice of lambda seems improve prediction
# lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5)
# A tibble: 6 x 2
# nextToken       prob
# <chr>      <dbl>
# 1       the 0.04593290
# 2      beer 0.03374923
# 3      wine 0.03365067
# 4  mistaken 0.03338656
# 5       sly 0.03337632
# 6    course 0.02245472
## this lambda ...detoriates lambda=c(0.5^5,0.5^4,0.5^3,0.5^2,0.5,1)
# nextToken       prob
# <chr>      <dbl>
# 1       the 0.09186579
# 2      beer 0.06749845
# 3      wine 0.06730134
## its the frequency of 'of the'

## minor improvement after good-turing adjustment
# # A tibble: 6 x 2
# nextToken       prob
# <chr>      <dbl>
# 1       the 0.03895312
# 2      beer 0.03248108
# 3      wine 0.03247963


##[2]
inputTxt<-"You're the reason why I smile everyday. Can you follow me please? It would mean the"
## predict_text_linear(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
## improves after good-turing
## gets the right answer - World
# 1      world 0.0275740818
# 2 difference 0.0196019172
# 3      whole 0.0079364197
# 4       same 0.0078214630
# 5      first 0.0007678043
## back off does too
# prevToken  nextToken  prob
# 1  mean the      world 0.028
# 2  mean the difference 0.020
# 3  mean the       same 0.008
# 4  mean the      whole 0.008
## add one fails
## add half doesn't do either


##[3]
inputTxt<-"Hey sunshine, can you follow me and make me the"
## no answer with back-off
## no answer with res<-predict_text_linear(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
## with some changes made ans - happiest
## the change doesn't break ##2


##[4]
inputTxt<-"Very early observations on the Bills game: Offense still struggling but the"
## linear gives the following answer
# A tibble: 3 x 2
# nextToken         prob
# <chr>        <dbl>
# 1     crowd 5.346009e-05
# 2   players 2.416976e-05
# 3   defense 2.022394e-05

##[5]
inputTxt<-"Go on a romantic date at the"
## back-off
# prevToken nextToken         prob
# 1    at the     beach 3.328277e-04
# 2    at the      mall 2.080173e-04
# 3    at the   grocery 9.707476e-05
# 4    at the    movies 5.547129e-05
## linear
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1     beach 3.072656e-04
# 2      mall 1.849244e-04
# 3   grocery 8.464724e-05
# 4    movies 6.854600e-05


##[6]
inputTxt<-"Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my"
## backoff seems working
# prevToken nextToken        prob
# 1     on my       way 0.006893741
# 2     on my       own 0.004098981
# 3     on my      blog 0.003819505
# 4     on my      face 0.003167394
# 5     on my      mind 0.002981077
# 6     on my     phone 0.002235808
## linear too


##[7]
inputTxt<-"Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some"
## backoff works better here - time, only one answer
## linear
# nextToken         prob
# <chr>        <dbl>
# 1      time 5.454157e-04
# 2     years 3.336279e-05
# 3     thing 1.612472e-05
# 4     weeks 9.044356e-06

##[8]
inputTxt<-"After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little"
## Linear - probably wrong answer
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1      ears 4.490475e-05
# 2      eyes 4.853679e-06
# 3   fingers 1.144618e-06
# 4      toes 3.940487e-07
## same answer with back-off
## some improvement observed
# 1      eyes 4.858977e-06
# 2   fingers 1.145867e-06
# 3      ears 9.329738e-07
# 4      toes 3.944788e-07


##[9]
inputTxt<-"Be grateful for the good times and keep the faith during the"
## no answer with back-off
## linear give the following
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1       bad 4.878268e-05
# 2      hard 2.225416e-05
# 3       sad 1.209113e-05
# 4     worse 2.389311e-06

#[10]
inputTxt<-"If this isnt the cutest thing you've ever seen, then you must be"
## no answer with back-off
## linear give the following
# A tibble: 2 x 2
# nextToken         prob
# <chr>        <dbl>
# 1    asleep 9.507206e-07
# 2    insane 5.691814e-07



tokens<-getTokens(inputTxt)

# length(tokens)

res<-predict_text_backoff(tokens)

res<-predict_text_linear(tokens,lambda=c(0.4^6,0.4^5,0.4^4,0.4^3,0.4^2,0.4))
head(res)


## best one so far
res<-predict_text_linear(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
head(res$nextToken,40)

res<-predict_text_linear_v2(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
head(res$nextToken,40)


#3
filter(res, nextToken %in% c("smelliest","saddest","happiest","bluest"))
#5
filter(res, nextToken %in% c("grocery","mall","beach","movies"))
#4
filter(res, nextToken %in% c("players","defense","crowd","referees"))
#7
filter(res, nextToken %in% c("thing","years","time","weeks"))
#8
filter(res, nextToken %in% c("eyes","ears","finger","fingers","toes"))
#9
filter(res, nextToken %in% c("worse","sad","hard","bad"))

filter(res, nextToken %in% c("insane","asleep","callous","insensitive"))



##

res<-predict_text_linear(tokens,lambda=c(0.5^5,0.5^4,0.5^3,0.5^2,0.5,1))

res<-predict_text_linear(tokens,lambda=c(0.01,0.05,0.1,0.15,0.3,0.4))

res<-predict_text_linear_add_one(tokens,lambda=c(0.4^6,0.4^5,0.4^4,0.4^3,0.4^2,0.4))

res<-predict_text_linear_add_one(tokens,lambda=c(0.01,0.05,0.1,0.15,0.3,0.4))

res<-predict_text_linear_add_one(tokens,lambda=c(0.4^5,0.4^4,0.4^3,0.4^2,0.4))
head(res)

res<-predict_text_linear_add_one(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
head(res)

res<-predict_text_linear_add_half(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))
head(res)


res

rm(v)
lambda[1]

head(arrange(result,desc(prob)))

result<-group_by(result,nextToken)

result<-summarize(result,prob=sum(prob))


head(result)
head(res_df)

result

ngram[ngram$prevToken]
