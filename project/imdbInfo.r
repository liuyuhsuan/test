devtools::install_github("hrbrmstr/omdbapi")
library(omdbapi)
library(dplyr)
library(pbapply)
library(rcharts)
movie="Haunted Campus"
id=0
searchList=search_by_title(movie)
for(i in 1:nrow(searchList)){
  if(movie==searchList[i,1]){
    id=searchList[i,3]
    break
  }
}
movieInfo=find_by_id(id)
rating=movieInfo$imdbRating