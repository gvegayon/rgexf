#' Reads gexf (.gexf) file
#' 
#' `read.gexf` reads gexf graph files and imports its elements as a
#' `gexf` class object
#' 
#' 
#' @param x String. Path to the gexf file.
#' @return A `gexf` object.
#' @note By the time attributes and viz-attributes aren't supported.
#' @author George Vega Yon 
#' 
#' Jorge Fabrega Lacoa 
#' @references The GEXF project website: http://gexf.net
#' @keywords IO
#' @examples
#' 
#'   fn <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   mygraph <- read.gexf(fn)
#' 
#' @export read.gexf
read.gexf <- function(x) {
  
  oldstrf <- getOption("stringsAsFactors")
  on.exit(options(stringsAsFactors = oldstrf))
  options(stringsAsFactors = FALSE)
  
  # Reads the graph
  gfile <- XML::xmlParse(x, encoding="UTF-8")
  
  # Gets the namespace
  ns <- XML::xmlNamespace(XML::xmlRoot(gfile))
  
  graph <- NULL
  graph$meta <- NULL

  ################################################################################
  # Creator
  if (length(y<-XML::getNodeSet(gfile,"/r:gexf/r:meta/r:creator", c(r=ns))) > 0) {
    graph$meta[["creator"]] <- XML::xmlValue(y[[1]])
  }
  else graph$meta[["creator"]] <- NA
  # Description
  if (length(y<-XML::getNodeSet(gfile,"/r:gexf/r:meta/r:description", c(r=ns))) > 0) {
    graph$meta[["description"]] <- XML::xmlValue(y[[1]])
  }
  else graph$meta[["description"]] <- NA
  # Keywords
  if (length(y<-XML::getNodeSet(gfile,"/r:gexf/r:meta/r:keywords", c(r=ns))) > 0) {
    graph$meta[["keywords"]] <- XML::xmlValue(y[[1]])
  }
  else graph$meta[["keywords"]] <- NA
  ################################################################################

  # Attributes list
  graph$atts.definitions <- list(nodes=NULL,edges = NULL)
  if (length(y<-XML::getNodeSet(gfile,"/r:gexf/r:graph/r:attributes", c(r=ns)))) {
    while (length(y) > 0) {
      
      # Gets the class
      attclass <- paste(XML::xmlAttrs(y[[1]])[["class"]],"s", sep="")
      z <- XML::getNodeSet(
        y[[1]], "/r:gexf/r:graph/r:attributes/r:attribute", c(r=ns))
      
      # Builds a dataframe
      graph$atts.definitions[[attclass]] <- data.frame(
        id=sapply(z, XML::xmlGetAttr, name="id"),
        title=sapply(z, XML::xmlGetAttr, name="title"),
        type=sapply(z, XML::xmlGetAttr, name="type")
        )
      
      # Removes the already analyzed
      y <- y[-1]
    }
  }
  
  graph$mode <- XML::xmlAttrs(XML::getNodeSet(gfile,"/r:gexf/r:graph", c(r=ns))[[1]])
  
  # Nodes
  nodes <- XML::getNodeSet(gfile,"/r:gexf/r:graph/r:nodes/r:node", c(r=ns))
  ids <- sapply(nodes, XML::xmlGetAttr, name="id")
  labels <- lapply(nodes, XML::xmlGetAttr, name="label")
  labels <- sapply(labels, function(x) if (is.null(x)) "" else x)
  if (all(labels == "")) labels <- ids
  graph$nodes <- data.frame(
    id=ids, 
    label=labels, 
    stringsAsFactors=F)
  rm(nodes)
  rm(ids)
  rm(labels)
  
  # Viz attributes -------------------------------------------------------------
  nodesVizAtt <- NULL
  edgesVizAtt <- NULL
  
  # Extracting attributes
  node.vizattr <- XML::xpathApply(
    gfile, "/r:gexf/r:graph/r:nodes/r:node", namespaces = c(r=ns, v="viz"),
    fun=XML::xmlChildren
    )
  
  node.attr <- XML::xpathApply(
    gfile, "/r:gexf/r:graph/r:nodes/r:node/r:attvalues", namespaces = c(r=ns),
    fun=XML::xmlChildren
  )
  
  node.attr <- lapply(node.attr, lapply, XML::xmlAttrs)

  node.vizattr <- lapply(node.vizattr, lapply, XML::xmlAttrs)
  # node.vizattr <- lapply(node.viz)
  
  # Colors
  nodesVizAtt$color <- lapply(node.vizattr, function(a) {
    
    if (length(a$color)) 
      return(check_and_map_color(a$color))
    
    check_and_map_color(default_nodeVizAtt$color())
    
  })
  
  nodesVizAtt$color <- do.call(rbind, nodesVizAtt$color)
  
  nodesVizAtt$color <- as.data.frame(nodesVizAtt$color)
  dimnames(nodesVizAtt$color) <- list(
    1L:nrow(nodesVizAtt$color), c("r", "g", "b", "a")
  )

  
  # Size
  nodesVizAtt$size <- lapply(node.vizattr, function(a) {
    if (length(a$size)) 
      return(viz_att_checks$size(as.numeric(a$size)))
    
    viz_att_checks$size(default_nodeVizAtt$size())
  })
  
  nodesVizAtt$size <- do.call(rbind, nodesVizAtt$size)

  nodesVizAtt$size <- as.data.frame(nodesVizAtt$size)
  dimnames(nodesVizAtt$size) <- list(
    1L:nrow(nodesVizAtt$size), "value"
  )
  
  
  # Positions
  nodesVizAtt$position <- lapply(node.vizattr, function(a) {
    if (length(a$position)) 
      return(viz_att_checks$position(matrix(as.numeric(a$position), nrow = 1)))
    
    viz_att_checks$position(default_nodeVizAtt$position())
  })
  
  nodesVizAtt$position <- do.call(rbind, nodesVizAtt$position)
  nodesVizAtt$position <- as.data.frame(nodesVizAtt$position)
  dimnames(nodesVizAtt$position) <- list(
    1L:nrow(nodesVizAtt$position), c("x", "y", "z")
  )
  
  
  # Edges
  edges <- XML::getNodeSet(gfile,"/r:gexf/r:graph/r:edges/r:edge", c(r=ns))

  graph$edges <- data.frame(
    id=sapply(edges, XML::xmlGetAttr, name="id", default=NA),
    source=sapply(edges, XML::xmlGetAttr, name="source"), 
    target=sapply(edges, XML::xmlGetAttr, name="target"), 
    weight=as.numeric(sapply(edges, XML::xmlGetAttr, name="weight", default="1.0")),
    stringsAsFactors=F)

  if (any(is.na(graph$edges[,1]))) graph$edges[,1] <- 1:NROW(graph$edges)
  rm(edges)

  graph$graph <- XML::saveXML(gfile, encoding="UTF-8")

  class(graph) <- "gexf"

  order <- order(as.integer(graph$nodes$id))
  
  build.and.validate.gexf(
    nodes            = graph$nodes[order, , drop=FALSE],
    edges            = graph$edges,
    atts.definitions = graph$atts.definitions,
    nodesVizAtt      = lapply(nodesVizAtt, "[", i=order, j=, drop=FALSE),
    edgesVizAtt      = edgesVizAtt,
    graph            = graph$graph
    )
  
}
