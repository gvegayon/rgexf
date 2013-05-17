library(devtools)
# install_bitbucket(repo="rgexf", username="gvegayon")
library(rgexf)
rm(list=ls())




people <- data.frame(id=1:4, label=c("juan", "pedro", "matthew", "carlos"), stringsAsFactors=F)
relations <- data.frame(source=c(1,1,1,2,3,4,2,4,4), target=c(4,2,3,3,4,2,4,1,1))

node.att <- data.frame(letrafavorita=c(letters[1:3],"hola"), numbers=1:4, stringsAsFactors=F)
edge.att <- data.frame(letrafavorita=letters[1:9], numbers=1:9, stringsAsFactors=F)



gexf.object <- write.gexf(nodes=people, edges=relations)
EdgeType <- "line"




plot.gexf <- function(gexf.object, EdgeType = c("line", "curve")){
  
  library(Rook)
  graph <- gexf.object$graph
  html <- readLines("index_att.html", warn=F)
  if(!is.null(gexf.object$node.att)){
    html <- gsub("/\\*\\* remove for pop up|remove for pop up \\*\\*/", "", html)
  }
  
  html <- gsub("EdgeTypePar", EdgeType, html)
  
  s <- Rhttpd$new()
  s$start(listen='127.0.0.1')
  
  my.app <- function(env){  
    res <- Response$new()
    res$write(paste(html, collapse="\n"))
    res$finish()
  }
  s$add(app=my.app, name='plot')
  
  my.app2 <- function(env){
    res <- Response$new()
    res$write(graph)
    res$finish()
  }
  s$add(app=my.app2, name='data')
  s$browse('plot')
}