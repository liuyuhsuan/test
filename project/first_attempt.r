rm(list=ls(all.names=TRUE))
devtools::install_github("hrbrmstr/omdbapi")
library(omdbapi)
library(dplyr)
library(pbapply)
library(rcharts)
library(XML)
library(RCurl)
library(httr)
Sys.setlocale(category = "LC_ALL", locale = "cht")
#==========================================================
path="https://ndshen.github.io/test/movieList2.html"
temp=getURL(path ,encoding="utf-8")
xmldoc=htmlParse(temp, encoding="utf-8")
movieTitle   <- xpathSApply(xmldoc, "//div//td//a", xmlValue)
movieTitle   <- gsub("\n", "", movieTitle)
movieTitle   <- gsub("\t", "", movieTitle)
movieUrl     <- xpathSApply(xmldoc, "//div//td//@href")
n=length(movieTitle)
englishName=vector(length=n)
subpath="http://www.truemovie.com/"
for(i in 316:n){
 
  
  Erroresult<- tryCatch({
    engNamePath=paste0(subpath, movieUrl[i])
    temp=getURL(engNamePath ,encoding="utf-8")
    xmldoc=htmlParse(temp, encoding="utf-8")
  }, warning = function(war) {
    print(paste("MY_WARNING:  ", movieTitle[i]))
  }, error = function(err) {
    print(paste("MY_ERROR:  ", movieTitle[i]))
    next
  }, finally = {
    print(paste("End Try&Catch", movieTitle[i]))
  })
  
  whichName=NULL
  for(j in 1:5){
    xpath1="//td/p["
    xpath2=as.character(j)
    xpath3="]"
    xpath4=paste0(xpath1, xpath2, xpath3)
    whichName=xpathSApply(xmldoc, xpath4, xmlValue)
    test=substring(whichName, first=1, last=8)
    if("-^au|W!G"==test){
      break
    }
    else if(j==5){
      whichName="Error"
    }
  }
  englishName[i]   <- whichName
  englishName[i]   <- gsub("\n", "", englishName[i])
  englishName[i]   <- gsub("\t", "", englishName[i])
  englishName[i]   <- substr(englishName[i], 9, nchar(englishName[i]))

  nameLength=nchar(englishName[i])
  o=strsplit(englishName[i],"")[[1]]
  
  k2=0
  for(k in nameLength:1){
    if(o[k]!=" "){
      break
    }
    k2=k2+1
  }
  englishName[i]=substring(englishName[i], 1, nameLength-k2)
}

#=============================================================
rating=vector(length=length(movieTitle))
for(i in 1:length(movieTitle)){
  movie=englishName[i]
  id=0
  searchList=search_by_title(movie)
  
  Erroresult<- tryCatch({
    for(j in 1:nrow(searchList)){
      if(movie==searchList[j,1]){
        id=searchList[j,3]
        break
      }
    }
    movieInfo=find_by_id(id)
    rating[i]=movieInfo$imdbRating
    next
  }, warning = function(war) {
    print(paste("MY_WARNING:  ", movie))
  }, error = function(err) {
    print(paste("MY_ERROR:  ", movie))
  }, finally = {
    print(paste("End Try&Catch", movie))
  })
}
movieList=data.frame(movieTitle, englishName, rating)

#=======================================================================
movieList$movieTitle=as.character(movieList$movieTitle)
movieList$englishName=as.character(movieList$englishName)
ram=movieList[1,2]
for(i in 2:n){
  if(movieList[i,2]==ram){
    newName<-paste0(movieList[i-1, 1], movieList[i,1])
    levels(movieList[1])<-c(levels(movieList[1]), newName)
    movieList[i-1 ,1]=newName
    movieList=movieList[-i,]
    i=i-1
  }
  ram=movieList[i,2]
}

write.table(movieList, file = "C:/Users/User/Desktop/大二上/test/project/movieList4.0.csv")

#===========================================================
setwd("C:\\Users\\User\\Desktop\\大二上\\test\\project")
movieList=read.csv("movieList4.0.csv")
movieList[1]=NULL
rating=movieList[,3]
englishName=movieList[,2]
movieTitle=movieList[,1]
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
write.table(movieList, file = "C:/Users/User/Desktop/大二上/test/project/movieList.csv")
test <- read.table("C:/Users/User/Desktop/大二上/test/project/final.csv", sep = ",")