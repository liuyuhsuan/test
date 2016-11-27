rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)
Sys.setlocale(category = "LC_ALL", locale = "cht")
startNo = 4700
endNo   = 4717 
subPath <- "https://www.ptt.cc/bbs/movie/index"
alldata = data.frame()
for( pid in startNo:endNo )
{
  urlPath <- paste(subPath,pid,  ".html", sep='')
  temp    <- getURL(urlPath, encoding = "big5")
  xmldoc  <- htmlParse(temp)
  title   <- xpathSApply(xmldoc, "//div[@class=\"title\"]", xmlValue)
  title   <- gsub("\n", "", title)
  title   <- gsub("\t", "", title)
  date    <-xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
  Erroresult<- tryCatch({
    subdata <- data.frame(title, date)
    alldata <- rbind(alldata, subdata)
  }, warning = function(war) {
    print(paste("MY_WARNING:  ", urlPath))
  }, error = function(err) {
    print(paste("MY_ERROR:  ", urlPath))
  }, finally = {
    print(paste("End Try&Catch", urlPath))
  })
}



name<-"你的名字"
movie1 =0
good1=0
bad1=0
for(i in 1: length(alldata[,1])){
  if(grepl(name, alldata[i, 1])){
    movie1<-movie1+1
    if(grepl("好雷", alldata[i, 1])){
      good1<-good1+1
    }
    else if(grepl("負雷", alldata[i, 1])){
      bad1<-bad1+1
    }
  }
}