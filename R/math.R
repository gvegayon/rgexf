ordAndCheckDplEdges <- function(edges, undirected=TRUE) {
################################################################################
# Checks for dupl
################################################################################  
  srce <- edges[,1]
  trgt <- edges[,2]
  
  nedges <- length(srce)
  
  result <- .C("ROrderAndCheckDplEdges", 
     as.integer(nedges),     # Edges length
     as.double(srce),        # Input Source
     as.double(trgt),        # Input Target
     as.integer(undirected), # Tells the function if the graph is undirected
     "source" = as.double(              # Output Source
       vector("double", nedges) 
       ),
     "target" = as.double(              # Output Target
       vector("double", nedges)
     ),
     "reps" = as.double(              # Output Target
       vector("double", nedges)
     ), PACKAGE="rgexf"
     )
  
  return(
    data.frame(
      source=result$source, 
      target=result$target, 
      reps=result$reps, 
      check.names=FALSE)
    )
}

#dyn.load("ROrderAndCheckDplEdges.so")

#relations <- cbind(
#  c(1,1,3,4,2,5,6), 
#  c(2,3,1,2,4,1,1)
#)


#ordEdges(relations)
#ordEdges(relations, undirected=FALSE)
