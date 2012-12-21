read.gexf <- function(x) {
################################################################################
# Read gexf graph files
################################################################################
  # Reads the graph
  gfile <- xmlParse(x)
  
  # Gets the namespace
  ns <- xmlNamespace(xmlRoot(gfile))
  
  graph <- NULL

  ################################################################################
  # Creator
  if (length(x<-getNodeSet(gfile,"/r:gexf/r:meta/r:creator", c(r=ns))) > 0) {
    graph$creator <- xmlValue(x[[1]])
  }
  else graph$creator <- NA
  # Description
  if (length(x<-getNodeSet(gfile,"/r:gexf/r:meta/r:description", c(r=ns))) > 0) {
    graph$description <- xmlValue(x[[1]])
  }
  else graph$description <- NA
  # Keywords
  if (length(x<-getNodeSet(gfile,"/r:gexf/r:meta/r:keywords", c(r=ns))) > 0) {
    graph$keywords <- xmlValue(x[[1]])
  }
  else graph$keywords <- NA
  ################################################################################

  # Attributes list
  if (length(x<-getNodeSet(gfile,"/r:gexf/r:graph/r:attributes", c(r=ns))) > 0) {
    while (length(x) > 0) {
      
      # Gets the class
      attclass <- paste(xmlAttrs(x[[1]])[["class"]],"att", sep=".")
      y <- getNodeSet(
        x[[1]], "/r:gexf/r:graph/r:attributes/r:attribute", c(r=ns))
      
      # Builds a dataframe
      graph[[attclass]] <- data.frame(
        id=sapply(y, xmlGetAttr, name="id"),
        title=sapply(y, xmlGetAttr, name="title"),
        type=sapply(y, xmlGetAttr, name="type")
        )
      
      # Removes the already analyzed
      x <- x[-1]
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
  
  graph
}

# Examples
# ---------
# x <- read.gexf("http://gephi.org/datasets/airlines-sample.gexf")
# y <- read.gexf("http://gephi.org/datasets/LesMiserables.gexf")
# z <- read.gexf("http://diseasome.eu/data/diseasome.gexf")
# a <- read.gexf("http://noduslabs.com/textplayer/bible.gexf")
# b <- read.gexf("http://gexf.net/data/WebAtlas_EuroSiS.gexf")

# lapply(b, head)
