
## File path

fileURL<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
inputFile<-"data/SwiftKey.zip"
en_tw_path<-"data/final/en_US/en_US.twitter.txt"

## check whether the file is already downloaded in project folder

if(!file.exists(en_tw_path))
{

     ## Downloading file

     download.file(fileURL,inputFile,"curl")


     ## Unziping file in data directory

     unzippedFile<-"data/."
     unzip(inputFile,exdir=unzippedFile)
     
}



con <- file(en_tw_path, "r")

conrw<-file("data/sample/sample.txt","wt")


## Read the first line of text readLines(con, 1) 
#line<-readLines(con, 1) 

#line
# txt<-NULL
# 
# txt<-as.data.frame(readLines(con, 500),stringsAsFactors =FALSE)
set.seed(1000)

l<-0

while(TRUE)
{
     ## Read the next line of text readLines(con, 5) 
     
     lines<-readLines(con, 500) 
     l<-l+500
     
     toss<-rbinom(1,1,.05)
     
     if(toss==1)
     {
            writeLines(lines,conrw)
                 #txt<-rbind(txt,as.data.frame(lines,stringsAsFactors =FALSE))
     }
     
     
     
     if(length(lines)==0){
          break
     }
     
     
     ## Read in the next 5 lines of text 

}

l

## It's important to close the connection when you are done
close(con)
close(conrw)
