rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)
Sys.setlocale(category = "LC_ALL", locale = "cht")
#==========================================================
path="https://ndshen.github.io/test/movieList.html"
temp=getURL(path ,encoding="utf-8")
xmldoc=htmlParse(temp, encoding="utf-8")
movieTitle   <- xpathSApply(xmldoc, "//td//a", xmlValue)
movieTitle   <- gsub("\n", "", movieTitle)
movieTitle   <- gsub("\t", "", movieTitle)



#===========================================================
startNo = 3600
endNo   = 4855
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
#======================================================================
popular<-list()
good<-list()
bad<-list()
for(movieListIndex in 1 : length(movieTitle)){
  movieName<-movieTitle[movieListIndex]
  frequency=0
  goodNum=0
  badNum=0
  for(i in 1:nrow(alldata)){
    if(grepl(movieName, alldata[i, 1])){
      frequency=frequency+1
      if(grepl("好雷", alldata[i,1])){
        goodNum=goodNum+1
      }
      else if(grepl("負雷", alldata[i, 1])){
        badNum=badNum+1
      }
    }
  }
  popular[movieListIndex]=frequency
  good[movieListIndex]=goodNum
  bad[movieListIndex]=badNum
}
final<-cbind(movieTitle, popular, good, bad)
names(final)<-c("Name", "Popular", "Good", "Bad")
#=======================================================================
write.table(alldata, file = "C:/Users/User/Desktop/大二上/test/project/pttTitle.csv")
write.table(final, file = "C:/Users/User/Desktop/大二上/test/project/final.csv")
write.table(movieTitle, file = "C:/Users/User/Desktop/大二上/test/project/movieTitle.csv")
test <- read.table("C:/Users/User/Desktop/大二上/test/project/final.csv", sep = ",")