# library(devtools)
# install_bitbucket(repo="rgexf", username="gvegayon")
# library(rgexf)
#rm(list=ls())



plot.gexf <- function(x, EdgeType = c("curve", "line"), ...){  
#   if(!is.null(gexf.object$positions)){
#     library(sna)
#     nNodes <- nrow(gexf.object$nodes)
#     links <- matrix(rep(0, nNodes*nNodes), ncol = nNodes)
#     relations <- gexf.object$edges[,c(3,4)]
#     
#     for(edge in 1:ncol(relations)){
#       links[(relations[edge,]$target), (relations[edge,]$source)] <- 1
#     }
#     
#     positions <- gplot.layout.kamadakawai(links, layout.par=list())
#     positions <- cbind(positions, 0) # needs a z axis
#   }
#   
#   nodecolors <- data.frame(r = rep(255, nNodes),
#                            g = rep(255, nNodes),
#                            b = rep(255, nNodes),
#                            a = rep(255, nNodes))
#   
#   gexf.object <-  write.gexf(nodes=gexf.object$nodes,
#                              edges=gexf.object$edges[,c("source","target")],
#                              nodesVizAtt=list(
#                                color=nodecolors,
#                                position=positions
#                              ))
#   
  if(length(x$node.att)){
    # dev
    # html <- readLines("../inst/sigmajs/index_att.html", warn=FALSE)
    html <- readLines(system.file("sigmajs/index_att.html", package="rgexf"), warn=FALSE)
  } else {
    # dev
    html <- readLines(system.file("sigmajs/index.html", package="rgexf"), warn=FALSE)    
  }

  html <- gsub("EdgeTypePar", EdgeType, html)
  
  s <- Rhttpd$new()
  s$start(listen='127.0.0.1')
  
  # html
  my.app <- function(env){  
    res <- Response$new()
    res$write(paste(html, collapse="\n"))
    res$finish()
  }
  s$add(app=my.app, name='plot')
  
  # graph
  graph <- function(env){
    res <- Response$new()
    res$write(x$graph)
    res$finish()
  }
  s$add(app=graph, name='data')
  
  # jquery
  jquery <- function(env){
    res <- Response$new()
    res$write(paste(readLines(system.file("sigmajs/jquery.min.js", package="rgexf"), warn=FALSE), collapse="\n "))
    res$finish()
  }
  s$add(app=jquery, name='jquery.js')
  
  
  # sigmajs
  sigmajs <- function(env){
    res <- Response$new()
    res$write(paste(readLines(system.file("sigmajs/sigma.min.js", package="rgexf"), warn=FALSE) , collapse="\n "))
    res$finish()
  }
  s$add(app=sigmajs, name='sigmajs')
  
  
  # parseGexf
  parseGexf <- function(env){
    res <- Response$new()
    res$write(paste(readLines(system.file("sigmajs/sigma.parseGexf.js", package="rgexf"), warn=FALSE), collapse="\n "))
    res$finish()
  }
  s$add(app=parseGexf, name='sigmaparseGexfjs')
  s$browse('plot')
}


# gexf.object <- write.gexf(nodes=data.frame(id=1:4, label=c("juan", "pedro", "matthew", "carlos"), stringsAsFactors=F),
#                           edges=data.frame(source=c(1,1,1,2,3,4,2,4,4), target=c(4,2,3,3,4,2,4,1,1)))
# 
# 

# 
# 
# gexf.object2 <- write.gexf(nodes=data.frame(id=1:4, label=c("juan", "pedro", "matthew", "carlos"), stringsAsFactors=F),
#                            edges=data.frame(source=c(1,1,1,2,3,4,2,4,4), target=c(4,2,3,3,4,2,4,1,1)),
#                            edgesAtt=data.frame(letrafavorita=letters[1:9], numbers=1:9, stringsAsFactors=F),
#                            nodesAtt=data.frame(letrafavorita=c(letters[1:3],"hola"), numbers=1:4, stringsAsFactors=F))
# 
# gexf.object2$
# gexf.object2$nodesVizAtt
# gexf.object2$nodesVizAtt
# gexf.object2$edgesVizAtt
# gexf.object2$nodes.Att
# 
# 
# 
# gexf.object <- read.gexf("http://sigmajs.org/data/les_miserables.gexf")
#
# EdgeType <- "line"
# # gexf.object <- gexf.object2
# 
# 
# plot.gexf(gexf.object)