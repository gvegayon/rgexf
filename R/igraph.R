
igraph.to.gexf <- function(igraph.obj) {
  
  g <- igraph.obj
  rm(igraph.obj)
  
  # Retrive elements from igraph object
  gdata <- get.data.frame(g, what="both")
  tmpedges <- gdata$edges
  tmpnodes <- gdata$vertices
  
  # Nodes and edges list
  edges <- tmpedges[,c("from","to")]
  if (length(tmpnodes$name)) nodes <- tmpnodes[,c("name","name")]
  else {
    nodes <- unique(unlist(edges))
    nodes <- data.frame(id=nodes,label=nodes,stringsAsFactors=FALSE)
  }
  
  # Nodes Attributes
  if (length(x <- list.vertex.attributes(g))) nAtt <- NULL
  else nAtt <- subset(tmpedges, select=x)
  
  # Edges Attributes
  if (length(x <- list.edge.attributes(g))) eAtt <- NULL
  else eAtt <- subset(tmpedges, select=x)
  
  # Edges Weights
  if (length(E(g)$weight)) eW <- E(g)$weight
  else eW <- NULL
  
  # Nodes Viz att
  if (length(tmpnodes$color)) {
    nVizAtt <- list(color=t(col2rgb(tmpnodes$color, alpha=T)))
  }
  else nVizAtt <- NULL
  
  # Edges Viz att
  if (length(tmpedges$color)) {
    eVizAtt <- list(color=t(col2rgb(tmpedges$color, alpha=T)))
  }
  else eVizAtt <- NULL

  if (length(tmpnodes)) { # If there are any nodes
    if (length(tmpnodes$name)) { # If these have a name
      if (!length(x <- list.vertex.attributes(g))) nAtt <- NULL
      else nAtt <- subset(tmpnodes, select=x)
    }
    else nAtt <- tmpnodes
  }
    
  # Building graph
  return(
    write.gexf(
      nodes = nodes, 
      edges = edges, 
      edgesAtt = eAtt,
      nodesAtt = nAtt,
      defaultedgetype = "directed",
      nodesVizAtt = nVizAtt,
      edgesVizAtt = eVizAtt,
      edgesWeight = eW
      )
    )
}

gexf.to.igraph <- function(gexf.obj) {
  
  g <- gexf.obj
  rm(gexf.obj)
  
  g2 <- graph.edgelist(as.matrix(g$edges[,c("source","target")]))
  
  # Labels
  V(g2)$name <- g$nodes$label
  
  # Nodes Viz atts
  if (length(x <- g$nodesVizAtt$color)) {
    V(g2)$color <- rgb(x$r/255,x$g/255,x$b/255,x$a/255)
  }
  
  # Edges Viz atts
  if (length(x <- g$edgesVizAtt$color)) {
    E(g2)$color <- rgb(x$r/255,x$g/255,x$b/255,x$a/255)
  }
  
  # Edges weights 
  if (length(x <- g$edges$weight)) {
   E(g2)$weight <- x
  }
  
  return(g2)
}

