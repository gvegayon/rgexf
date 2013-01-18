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
  
  graph$mode <- xmlAttrs(getNodeSet(gfile,"/r:gexf/r:graph", c(r=ns))[[1]])
  
  # Nodes
  nodes <- getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node", c(r=ns))
  graph$nodes <- data.frame(
    id=sapply(nodes, xmlGetAttr, name="id"), 
    label=sapply(nodes, xmlGetAttr, name="label"), stringsAsFactors=F)

  #nodes <- getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node", c(r=ns))
  #graph$nodesatt <- NULL
  #if (NROW(y <- graph$node.att) > 0) {
  #  print(nodes)
  #  print(getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node/r:attvalues/r:attvalue[@for='att1']", c(r=ns)))
  #  print(getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node/r:attvalues/r:attvalue[@for='att2']", c(r=ns)))
  #  
  #  while (NROW(y) > 0) {
  #    message(names(nodes))
  #    graph$nodesatt <- cbind(graph$nodesatt, sapply(nodes[["attributes"]], xmlGetAttr, name=y[1,1]),
  #                         stringsAsFactors=F)
  #    y <- y[-1,]
  #  }
#    print(gfile)
  #  names(graph$node) <- c("id","label",graph$node.att[,1])
  #}
  rm(nodes)
  
  # Edges
  edges <- getNodeSet(gfile,"/r:gexf/r:graph/r:edges/r:edge", c(r=ns))
  graph$edges <- data.frame(
    source=sapply(edges, xmlGetAttr, name="source"), 
    target=sapply(edges, xmlGetAttr, name="target"), stringsAsFactors=F)
  rm(edges)

  if (length(graph$node.att) == 0) graph$node.att <- NA
  if (length(graph$edge.att) == 0) graph$edge.att <- NA

  graph$graph <- saveXML(gfile, encoding="UTF-8")

  class(graph) <- "gexf"

  graph
}

add.gexf.node <- function(
################################################################################
# Add nodes to gexf class object
################################################################################
  graph, id=NA, label=NA, start=NULL, end=NULL,
  vizAtt=list(color=NULL, position=NULL, size=NULL, shape=NULL, image=NULL)) {
  # Parses the graph file
  graph$graph <- xmlTreeParse(graph$graph)
  
  # Gets the number of nodes
  n <- length(graph$graph$doc$children$gexf[["graph"]][["nodes"]])
  
  node <- xmlNode("node", attrs=c(id=id, label=label, start=start, end=end))
  
  # Adds the viz atts
  if (length(unlist(vizAtt)) > 0) {
    if (length(vizAtt$color) > 0) node <- addChildren(node, xmlNode("viz:color", attrs=vizAtt$color))
    if (length(vizAtt$position) > 0) node <- addChildren(node, xmlNode("viz:position", attrs=vizAtt$position))
    if (length(vizAtt$size) > 0) node <- addChildren(node, xmlNode("viz:size", attrs=vizAtt$size))
    if (length(vizAtt$image) > 0) node <- addChildren(node, xmlNode("viz:image", attrs=vizAtt$image))
  }
  
  graph$graph$doc$children$gexf[["graph"]][["nodes"]][[n+1]] <- asXMLNode(x=node)
  
  graph$nodes <- rbind(graph$nodes, data.frame(id=id, label=label, 
                                               stringsAsFactors=F))
  
  # Saves and returns as char XML
  graph$graph <- saveXML(xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}

add.gexf.edge <- function(
################################################################################
# Add edges to gexf class object
################################################################################
  graph, source, target, id=NULL, type=NULL, label=NULL, start=NULL, end=NULL, 
  weight=1, vizAtt = list(color=NULL, thickness=NULL, shape=NULL)) {
  # Parses the graph file
  graph$graph <- xmlTreeParse(graph$graph)
  
  # Gets the number of edges
  n <- length(graph$graph$doc$children$gexf[["graph"]][["edges"]])
  
  edge <- xmlNode("edge", attrs=c(id=id, type=type, label=label, source=source, 
                                  target=target, start=start, end=end, 
                                  weight=weight))
    # Adds the viz atts
  if (length(unlist(vizAtt)) > 0) {
    if (length(vizAtt$color) > 0) edge <- addChildren(edge, xmlNode("viz:color", attrs=vizAtt$color))
    if (length(vizAtt$thickness) > 0) edge <- addChildren(edge, xmlNode("viz:thickness", attrs=vizAtt$position))
    if (length(vizAtt$shape) > 0) edge <- addChildren(edge, xmlNode("viz:shape", attrs=vizAtt$size))
  }
  
  # Adds the new edge
  graph$graph$doc$children$gexf[["graph"]][["edges"]][[n+1]] <- asXMLNode(x=edge)
  
  graph$edges <- rbind(graph$edges, data.frame(source=source, target=target,
                                               stringsAsFactors=F))
  
  # Saves and returns as char XML
  graph$graph <- saveXML(xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}

new.gexf.graph <- function(
################################################################################
# Creates an empty gexf class object
################################################################################
  defaultedgetype = "undirected",
  meta = list(creator="NodosChile", description="A graph file writing in R using \'rgexf\'",keywords="gexf graph, NodosChile, R, rgexf")
  ) {
  
  # Building doc
  xmlFile <- newXMLDoc(addFinalizer=T)
  gexf <- newXMLNode(name='gexf', doc = xmlFile)
  
  # Adding gexf attributes
  newXMLNamespace(node=gexf, namespace='http://www.gexf.net/1.2draft')
  newXMLNamespace(
    node=gexf, namespace='http://www.gexf.net/1.1draft/viz', prefix='viz')
  newXMLNamespace(
    node=gexf, namespace='http://www.w3.org/2001/XMLSchema-instance',
    prefix='xsi'
  ) 
  
  xmlAttrs(gexf) <- c( 
    'xsi:schemaLocation' = 'http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd',
    version=1.2)
  
  # graph
  xmlMeta <- newXMLNode(name="meta", 
                        attrs=list(lastmodifieddate=as.character(Sys.Date())), 
                        parent=gexf)
  newXMLNode(name='creator', meta$creator, parent=xmlMeta)
  newXMLNode(name='description', meta$description, parent=xmlMeta)
  newXMLNode(name='keywords', meta$keywords, parent=xmlMeta)
  
  xmlGraph <- newXMLNode(name="graph", parent=gexf)
  
  mode <- "static"
  xmlAttrs(xmlGraph) <- c(mode=mode)
  
  # Nodes
  newXMLNode(name='nodes', parent=xmlGraph)
  
  # Edges
  newXMLNode(name='edges', parent=xmlGraph)
  
  # Return
  results <- list(
    meta=unlist(meta),
    mode=unlist(c(defaultedgetype=defaultedgetype, mode=mode)),
    node.att = NULL,
    edge.att = NULL,
    nodes=data.frame(id=NULL, label=NULL),
    edges=data.frame(source=NULL, target=NULL),
    graph=saveXML(xmlFile, encoding='UTF-8'))
  class(results) <- "gexf"
  
  return(results)
}


rm.gexf.node <- function(
  ################################################################################
  # Add nodes to gexf class object
  ################################################################################
  graph, id=NULL, number=NULL, rm.edges = TRUE
  ) {
  
  # Checking the node to delete
  if (length(number)==0) {
    if (length(id)==0) stop("No nodes specified.")
    else {
      number <- as.numeric(rownames(graph$nodes)[id == graph$nodes["id"]])
    }
    if (length(number) == 0) stop("No such node.")
  }
  else {
    id <- graph$nodes[number,]$id
  }
  
  # Gets the number of nodes
  
  if (NROW(graph$nodes) > 0) {
    # Parses the graph file
    graph$graph <- xmlTreeParse(graph$graph)
  
    # Removes nodes from XML
    graph$graph$doc$children$gexf[["graph"]][["nodes"]] <- 
      removeChildren(graph$graph$doc$children$gexf[["graph"]][["nodes"]], 
                   kids=c(number))
    
    # If removing edges is true
    if (rm.edges) {
      if (length(graph$graph$doc$children$gexf[["graph"]][["edges"]]) > 0) {
        edges.to.rm <- rownames(subset(graph$edges, 
                                       graph$edges["source"] == id |
                                         graph$edges["target"]  == id))
        
        if (length(edges.to.rm) > 0) {
          edges.to.rm <- as.numeric(edges.to.rm)
          
          # Removing from xml
          graph$graph$doc$children$gexf[["graph"]][["edges"]] <- 
            removeChildren(graph$graph$doc$children$gexf[["graph"]][["edges"]], 
                         kids=as.list(edges.to.rm))
          
          # Removing from data frame
          graph$edges <- graph$edges[-edges.to.rm,]
        }
        else {
          warning("No edges to remove found.")
        }
      }
      else {
        warning("No edges to be removed.")
      }
    }
    graph$nodes <- graph$nodes[-number,]
    
    # Saves and returns as char XML
    graph$graph <- saveXML(xmlRoot(graph$graph), encoding="UTF-8")
    return(graph)
  }
  else {
    stop("No nodes to be removed.")
  }
}

rm.gexf.edge <- function(
################################################################################
# Add edges to gexf class object
################################################################################
  graph, number=NULL
  ) {
  # Checking the node to delete
  if (length(number) == 0)  stop("No edge especified.")
  
  # Gets the number of edges
  if (NROW(graph$edges) > 0) {
    
    # Parses the graph file
    graph$graph <- xmlTreeParse(graph$graph)
    
    graph$graph$doc$children$gexf[["graph"]][["edges"]] <- 
      removeChildren(graph$graph$doc$children$gexf[["graph"]][["edges"]], 
                     kids=c(number))
    
    graph$edges <- graph$edges[-number,]
    
    # Saves and returns as char XML
    graph$graph <- saveXML(xmlRoot(graph$graph), encoding="UTF-8")
    return(graph)
  }
  else {
    stop("No edges to be removed.")
  }
}
