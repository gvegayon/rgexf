read.gexf <- function(x) {
################################################################################
# Read gexf graph files
################################################################################
  # Reads the graph
  gfile <- xmlParse(x)
  
  # Gets the namespace
  ns <- xmlNamespace(xmlRoot(gfile))
  
  graph <- NULL
  graph$meta <- NULL

  ################################################################################
  # Creator
  if (length(y<-getNodeSet(gfile,"/r:gexf/r:meta/r:creator", c(r=ns))) > 0) {
    graph$meta[["creator"]] <- xmlValue(y[[1]])
  }
  else graph$meta[["creator"]] <- NA
  # Description
  if (length(y<-getNodeSet(gfile,"/r:gexf/r:meta/r:description", c(r=ns))) > 0) {
    graph$meta[["description"]] <- xmlValue(y[[1]])
  }
  else graph$meta[["description"]] <- NA
  # Keywords
  if (length(y<-getNodeSet(gfile,"/r:gexf/r:meta/r:keywords", c(r=ns))) > 0) {
    graph$meta[["keywords"]] <- xmlValue(y[[1]])
  }
  else graph$meta[["keywords"]] <- NA
  ################################################################################

  # Attributes list
  if (length(y<-getNodeSet(gfile,"/r:gexf/r:graph/r:attributes", c(r=ns))) > 0) {
    while (length(y) > 0) {
      
      # Gets the class
      attclass <- paste(xmlAttrs(y[[1]])[["class"]],"att", sep=".")
      z <- getNodeSet(
        y[[1]], "/r:gexf/r:graph/r:attributes/r:attribute", c(r=ns))
      
      # Builds a dataframe
      graph[[attclass]] <- data.frame(
        id=sapply(z, xmlGetAttr, name="id"),
        title=sapply(z, xmlGetAttr, name="title"),
        type=sapply(z, xmlGetAttr, name="type")
        )
      
      # Removes the already analyzed
      y <- y[-1]
    }
  }
  else { # If no other att is
    graph$nodes.att <- NA
    graph$edges.att <- NA
  }
  
  
  graph$mode <- xmlAttrs(getNodeSet(gfile,"/r:gexf/r:graph", c(r=ns))[[1]])
  
  # Nodes
  nodes <- getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node", c(r=ns))
  graph$nodes <- data.frame(
    id=sapply(nodes, xmlGetAttr, name="id"), 
    label=sapply(nodes, xmlGetAttr, name="label"), stringsAsFactors=F)
  rm(nodes)
  
  # Edges
  edges <- getNodeSet(gfile,"/r:gexf/r:graph/r:edges/r:edge", c(r=ns))
  graph$edges <- data.frame(
    source=sapply(edges, xmlGetAttr, name="source"), 
    target=sapply(edges, xmlGetAttr, name="target"), stringsAsFactors=F)
  rm(edges)

  graph$graph <- saveXML(gfile, encoding="UTF-8")

  graph
}

add.gexf.node <- function(id=NA, label=NA, start=NA, end=NA, graph) {
  # Parses the graph file
  graph$graph <- xmlTreeParse(graph$graph)
  
  # Gets the number of nodes
  n <- length(graph$graph$doc$children$gexf[["graph"]][["nodes"]])
  
  # Adds the new node
  graph$graph$doc$children$gexf[["graph"]][["nodes"]][[n+1]] <- 
    asXMLNode(x=xmlNode("node", attrs=c(id=id, label=label)))
  
  graph$nodes <- rbind(graph$nodes, cbind(id=id, label=label))
  
  # Saves and returns as char XML
  saveXML(graph, encoding="UTF-8")
}

#grafo <- read.gexf("lesmiserables.gexf")
#grafo <- add.gexf.node(id=999, label="test", graph=grafo)

# Examples
# ---------
# x <- read.gexf("http://gephi.org/datasets/airlines-sample.gexf")
# y <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
# z <- read.gexf("http://diseasome.eu/data/diseasome.gexf")
# a <- read.gexf("http://noduslabs.com/textplayer/bible.gexf")
# b <- read.gexf("http://gexf.net/data/WebAtlas_EuroSiS.gexf")

# lapply(b, head)

#x <- write.gexf(nodes=grafo$nodes, edges=grafo$edges)
#lapply(x[-5], head)
#lapply(grafo[-6], head)