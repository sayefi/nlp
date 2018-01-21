

source('~/Data_Science/Projects/nlp/predict_text.R')

load("data/output/op/my_ngram1t4c_01_20_2018.RData")
# load("data/output/op/my_ngram_01_15_2018.RData")
# load("data/output/op/my_ngram_01_14_2018.RData")
# load("data/output/op/my_ngram_01_17_2018.RData")

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
## with stemmed 
# A tibble: 5 x 2
# nextToken         prob
# <chr>        <dbl>
# 1      eyes 4.858977e-06
# 2   fingers 1.145867e-06
# 3      ears 9.329738e-07
# 4    finger 7.952192e-07
# 5      toes 3.944788e-07


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

#[11]
inputTxt<-"When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd"
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1       die 4.358951e-05
# 2       eat 2.994112e-05
# 3      give 3.845877e-06
# 4     sleep 1.231075e-06
## back-off with stemmed
# prevToken nextToken         prob
# 1      live       die 1.072626e-04
# 2      live       eat 7.150838e-05

#[12]W
inputTxt<-"Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his"
# A tibble: 3 x 2
# nextToken         prob
# <chr>        <dbl>
# 1 financial 1.019330e-06
# 2 spiritual 3.250037e-07
# 3   marital 3.282865e-08

#[13]W
inputTxt<-"I'd give anything to see arctic monkeys this"
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1   morning 1.117690e-05
# 2     month 9.179460e-06
# 3   weekend 8.377979e-06
# 4    decade 1.502777e-06

#[14]
inputTxt<-"Talking to your mom has the same effect as a hug and helps reduce your"
# A tibble: 3 x 2
# nextToken         prob
# <chr>        <dbl>
# 1    stress 1.252314e-06
# 2 happiness 9.830663e-07
# 3    hunger 7.889577e-07

#[15]W
inputTxt<-"When you were in Holland you were like 1 inch away from me but you hadn't time to take a"
# back-off
# prevToken nextToken         prob
# 1      take      look 7.157895e-04
# 2      take   picture 3.052632e-04
# 3      take      walk 1.052632e-04
# 4      take    minute 8.421053e-05
## Linear
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1      look 5.700050e-04
# 2      walk 1.540131e-04
# 3   picture 4.552161e-06
# 4    minute 3.205923e-06
## with Jan 14 ngrams & backoff
# 1 to take a   picture 0.023076923
# 2 to take a      look 0.012307692
# 3 to take a      walk 0.004615385
## Jan 14 linear
# nextToken        prob
# <chr>       <dbl>
#      1   picture 0.021608610
# 2      look 0.019332871
# 3      walk 0.004688801
# 4    minute 0.001112418


#[16]W
inputTxt<-"I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the"
# prevToken nextToken    prob
# 1     settl      case 0.00128
# 2     settl    matter 0.00032
#[17]
inputTxt<-"I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each"
# # A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
#      1      hand 6.893987e-06
# 2       arm 1.471469e-06
# 3    finger 7.952192e-07
# 4       toe 3.193400e-07

#18W---R
inputTxt<-"Every inch of you is perfect from the bottom to the"
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1      side 5.266469e-04
# 2       top 1.841607e-04
# 3    center 9.699170e-06
# 4    middle 4.758792e-06

## Jan 14 linear
# prevToken nextToken         prob
# 1    to the       top 0.0006012430
# 2    to the      side 0.0002404972
# 3    to the    center 0.0002127475
# 4    to the    middle 0.0001017488

#19
inputTxt<-"I'm thankful my childhood was filled with imagination and bruises from playing"
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1   outside 6.756233e-06
# 2    inside 5.510181e-06
# 3     daily 3.468909e-06
# 4    weekly 1.139606e-06

#20W
inputTxt<-"I like how the same people are in almost all of Adam Sandler's"
# A tibble: 4 x 2
# nextToken         prob
# <chr>        <dbl>
# 1   stories 4.032450e-06
# 2  pictures 3.594141e-06
# 3    movies 2.573505e-06
# 4    novels 6.198953e-07

tokens<-getTokens(inputTxt)

tokens<-getTokens_v2(inputTxt)

## best one so far
res<-predict_text_linear(tokens,lambda=c(0.5^4,0.5^3,0.5^2,0.5))
head(res$nextToken,40)

res<-predict_text_linear_v4(tokens,lambda=c(0.5^4,0.5^3,0.5^2,0.5))

# length(tokens)

res<-predict_text_backoff(tokens)

res<-predict_text_linear(tokens,lambda=c(0.4^6,0.4^5,0.4^4,0.4^3,0.4^2,0.4))
head(res,100)

#11
filter(res, nextToken %in% c("give","sleep","die","eat"))

#12
filter(res, nextToken %in% c("financial","marital","horticultural","spiritual"))

#13
filter(res, nextToken %in% c("morning","weekend","decade","month"))

#14
filter(res, nextToken %in% c("happiness","stress","hunger","sleepiness"))

#15
filter(res, nextToken %in% c("walk","minute","picture","look"))

#16
filter(res, nextToken %in% c("incident","case","account","matter"))

#17
filter(res, nextToken %in% c("arm","finger","hand","toe"))

#18
filter(res, nextToken %in% c("center","middle","top","side"))

#19
filter(res, nextToken %in% c("daily","inside","weekly","outside"))

#20
filter(res, nextToken %in% c("movies","novels","stories","pictures"))



res<-predict_text_linear_v3(tokens,lambda=c(0.5^6,0.5^5,0.5^4,0.5^3,0.5^2,0.5))


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
