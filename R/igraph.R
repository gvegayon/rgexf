

igraph.to.gexf <- function(g) {
  
  # Retrive elements from igraph object
  g <- get.data.frame(g, what="both")
  tmpedges <- g$edges
  tmpnodes <- g$vertices
  
  # Nodes and edges list
  edges <- tmpedges[,c("from","to")]
  if (length(tmpnodes$name)) nodes <- tmpnodes[,c("name","name")]
  else {
    nodes <- unique(unlist(edges))
    nodes <- data.frame(id=nodes,label=nodes,stringsAsFactors=FALSE)
  }
  
  # Attributes
  if (!length( tmpedges[,!(colnames(tmpedges) %in% c("from","to"))] )) eAtt <- NULL
  else eAtt <- subset(tmpedges, select=c(-from,-to))

  if (length(tmpnodes)) { # If there are any nodes
    if (length(tmpnodes$name)) { # If these have a name
      if (!length( tmpnodes[,!(colnames(tmpnodes) %in% c("name"))] )) nAtt <- NULL
      else nAtt <- subset(tmpnodes, select=c(-name))
    }
    else nAtt <- tmpnodes
  }
    
  
  
  # Building graph
  return(
    write.gexf(
      nodes, 
      edges, 
      edgesAtt=eAtt,
      nodesAtt=nAtt,
      defaultedgetype="directed"
      )
    )
}

#gexf.to.igraph <- function() {
#  
#}
require(rgexf)
require(igraph)
g <- graph.ring(10)
g <- set.graph.attribute(g, "name", "RING")
# It is the same as
g$name <- "RING"
g$name

g <- set.vertex.attribute(g, "color", value=c("red", "green"))
get.vertex.attribute(g, "color")

plot(igraph.to.gexf(g))