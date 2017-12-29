

en_tw_path<-"data/final/en_US/en_US.twitter.txt"

con <- file(en_tw_path, "r")

len_tw<-0


while(TRUE)
{
     
     line<-readLines(con, 1) 
     
     line
     
     if(nchar(line)>len_tw)
          len_tw<-nchar(line)
     else if (length(line)==0)
          break
     
     
}

len_tw

close(con)


en_blog_path<-"data/final/en_US/en_US.blogs.txt"

con <- file(en_blog_path, "r")

len_blog<-0


while(TRUE)
{
     
     line<-readLines(con, 1) 
     
     line
     
     if(nchar(line)>len_blog)
          len_blog<-nchar(line)
     else if (length(line)==0)
          break
     
     
}

len_blog

close(con)



en_news_path<-"data/final/en_US/en_US.news.txt"

con <- file(en_news_path, "r")

len_news<-0


while(TRUE)
{
     
     line<-readLines(con, 1) 
     
     line
     
     if(nchar(line)>len_news)
          len_news<-nchar(line)
     else if (length(line)==0)
          break
     
     
}

len_news

close(con)

##-----------------------------------------------------


## grep "love" "data/final/en_US/en_US.twitter.txt"

en_tw_path<-"data/final/en_US/en_US.twitter.txt"

con <- file(en_tw_path, "r")

lineNoLove<-grep("love",readLines(con))

close(con)


con <- file(en_tw_path, "r")

lineNoHate<-grep("hate",readLines(con))

close(con)

length(lineNoLove)/length(lineNoHate)


## ------------------------------------------------------

en_tw_path<-"data/final/en_US/en_US.twitter.txt"

con <- file(en_tw_path, "r")

grep("biostats",readLines(con),value = TRUE)

close(con)


## ------------------------------------------------------




en_tw_path<-"data/final/en_US/en_US.twitter.txt"

con <- file(en_tw_path, "r")

grep("A computer once beat me at chess, but it was no match for me at kickboxing",readLines(con),value = TRUE)

close(con)


