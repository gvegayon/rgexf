read.gexf <- function(x) {
################################################################################
# Read gexf graph files
################################################################################
  # Reads the graph
  graphfile <- xmlParse(x)
  
  # Gets the namespace
  ns <- xmlNamespace(xmlRoot(graphfile))
  
  graph <- NULL
  graph$creator <- xmlValue(
    getNodeSet(graphfile,"/r:gexf/r:meta/r:creator", c(r=ns))[[1]])
  graph$description <- xmlValue(
    getNodeSet(graphfile,"/r:gexf/r:meta/r:description", c(r=ns))[[1]])
  graph$keywords <- xmlValue(
    getNodeSet(graphfile,"/r:gexf/r:meta/r:keywords", c(r=ns))[[1]])
  
  graph$mode <- xmlAttrs(getNodeSet(graphfile,"/r:gexf/r:graph", c(r=ns))[[1]])
  
  # Nodes
  nodes <- getNodeSet(graphfile,"/r:gexf/r:graph/r:nodes/r:node", c(r=ns))
  graph$nodes <- data.frame(
    id=sapply(nodes, xmlGetAttr, name="id"), 
    label=sapply(nodes, xmlGetAttr, name="label"), stringsAsFactors=F)
  rm(nodes)
  
  # Edges
  edges <- getNodeSet(graphfile,"/r:gexf/r:graph/r:edges/r:edge", c(r=ns))
  graph$edges <- data.frame(
    source=sapply(edges, xmlGetAttr, name="source"), 
    target=sapply(edges, xmlGetAttr, name="target"), stringsAsFactors=F)
  rm(edges)
  
  graph
}

# x <- read.gexf("grafo.gexf")