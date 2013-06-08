
igraph.to.gexf <- function(igraph.obj) {
  
  g <- igraph.obj
  rm(igraph.obj)
  
  # Retrive elements from igraph object
  gdata <- get.data.frame(g, what="both")
  tmpedges <- gdata$edges
  tmpnodes <- gdata$vertices
  
  # Nodes and edges list
  nodes <- edge.list(tmpedges[,c(1,2)])
  edges <- nodes$edges
  nodes <- nodes$nodes
  
  # Building nodes
  if (length(tmpnodes)) {
    nodes <-merge(tmpnodes,nodes, by.x="name", by.y="label")
    nodes <- cbind(nodes, label=nodes$name, stringsAsFactors=FALSE)
    tmpnodes <- subset(nodes, select=c(-id,-label))
    print(tmpnodes)
    nodes <- subset(nodes, select=c(id, label))
    print(nodes)
  }
  
  # Nodes Attributes
  x <- list.vertex.attributes(g)
  x <- x[!(x %in% "name")]
  if (length(x)) nAtt <- NULL
  else nAtt <- subset(tmpedges, select=x)
  
  # Edges Attributes
  x <- list.vertex.attributes(g)
  x <- x[!(x %in% "weight")]
  if (length(x)) eAtt <- NULL
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
  
  # Edge type
  if (is.directed(g)) defaultedgetype <- "directed"
  else defaultedgetype <- "undirected"
  
  # Building graph
  return(
    write.gexf(
      nodes = nodes, 
      edges = edges, 
      edgesAtt = eAtt,
      nodesAtt = nAtt,
      defaultedgetype = defaultedgetype,
      nodesVizAtt = nVizAtt,
      edgesVizAtt = eVizAtt,
      edgesWeight = eW
      )
    )
}

gexf.to.igraph <- function(gexf.obj) {
  
  g <- gexf.obj
  rm(gexf.obj)
  
  # Starting igraph object
  g2 <- graph.edgelist(
    as.matrix(g$edges[,c("source","target")]),
    directed=(g$mode[[1]] != "undirected")
    )
  
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

