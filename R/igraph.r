#' Converting between `gexf` and `igraph` classes
#' 
#' Converts objects between `gexf` and `igraph` objects keeping
#' attributes, edge weights and colors.
#' 
#' If the position argument is not `NULL`, the new `gexf` object will
#' include the `position` viz-attribute.
#' 
#' @aliases igraph.to.gexf gexf.to.igraph
#' @param igraph.obj An object of class `igraph`.
#' @param gexf.obj An object of class `gexf`.
#' @param ... Further arguments passed to [gexf()].
#' @return \itemize{ \item For `igraph.to.gexf` : `gexf` class object
#' \item For `gexf.to.igraph` : `igraph` class object }
#' @author George Vega Yon \email{g.vegayon@gmail.com}
#' @seealso [layout()]
#' @keywords manip
#' @examples
#' 
#'  \dontrun{
#'  
#'   # Running demo
#'   demo(gexfigraph)
#'  
#'   fn <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   gexf1 <- read.gexf(fn)
#'   igraph1 <- gexf.to.igraph(gexf1)
#'   gexf2 <- igraph.to.gexf(igraph1)
#'   
#'   # Now, let's do it with a layout!
#'   pos <- igraph::layout_nicely(igraph1)
#'   plot(
#'     igraph.to.gexf(igraph1, nodesVizAtt = list(position=cbind(pos, 0))),
#'     edgeWidthFactor = .01)
#'  }
#' @export
igraph.to.gexf <- function(igraph.obj, ...) {
  
  dots <- list(...)
  
  g <- igraph.obj
  
  # Retrive elements from igraph object
  gdata    <- igraph::get.data.frame(g, what="both")
  tmpedges <- gdata$edges
  tmpnodes <- gdata$vertices
  
  # If nodes have no name
  if (!("name" %in% colnames(tmpnodes))) 
    tmpnodes <- data.frame(tmpnodes, name=1:nrow(tmpnodes))
  
  # Nodes and edges list
  # these steps are dangerous as nodes that are not connected are dropped, creating a mismatched number of rows
#   nodes <- edge.list(tmpedges[,c(1,2)])
#   edges <- nodes$edges
#   nodes <- nodes$nodes
  
  nodes <- tmpnodes
  # change name to label
  names(nodes) <- 'label'
  # add a column to nodes to hold the IDs
  nodes$id <- as.integer(as.factor(nodes$label))
  # put them in the right order
  nodes <- nodes[, c('id', 'label')]
  
  ## replace from and to in edges with their IDs
  # first create a named vector of ids
  nodesID <- nodes$id
  names(nodesID) <- gdata$vertices$name
  
  edges <- tmpedges
  # now in the edges create the id columns
  edges$source <- nodesID[edges$from]
  edges$target <- nodesID[edges$to]
  # keep just source and target
  edges <- edges[, c('source', 'target')]
  
  # Building nodes
  if (length(tmpnodes)) {
    nodes <-merge(tmpnodes,nodes, by.x="name", by.y="label")
#    nodes <- nodes[,!(colnames(nodes) %in% c("label"))]
  }
  
  # Nodes Attributes
  x <- igraph::list.vertex.attributes(g)
  x <- x[!(x %in% c("label","color","size"))]
  if (length(x))
    dots$nodesAtt <- subset(nodes, select=x)
  
  # Edges Attributes
  x <- igraph::list.edge.attributes(g)
  x <- x[!(x %in% c("weight","color","edgesLabel","width"))]
  if (length(x)) 
    dots$edgesAtt <- subset(tmpedges, select=x)
  
  # Edges Weights
  if (!length(dots$edgesWeight) && length(igraph::E(g)$weight))
    dots$edgesWeight <- igraph::E(g)$weight
  else
    dots$edgesWeight <- NULL
  
  # Nodes Viz att
  if (!length(dots$nodesVizAtt$color)) {
    if (length(tmpnodes$color)) {
      dots$nodesVizAtt$color <- tmpnodes$color
    } else 
      dots$nodesVizAtt$color <- NULL
  }
  
  if (!length(dots$nodesVizAtt$size) && length(tmpnodes$size))
    dots$nodesVizAtt$size <- tmpnodes$size
  
  positions <- igraph::graph_attr(g, "layout")
  
  if (!length(dots$nodesVizAtt$position) && length(positions)) {
    dots$nodesVizAtt$position <- check_positions(positions)
    
  }
    
  # Edges Viz att
  if (!length(dots$edgesVizAtt$color)) {
    if (length(tmpedges$color)) {
      dots$edgesVizAtt$color <- tmpedges$color
    } else
      dots$edgexVizAtt$color <- NULL
  }
  
  # Edge type
  if (!length(dots$defaultedgetype) && igraph::is.directed(g)) 
    dots$defaultedgetype <- "directed"
  else 
    dots$defaultedgetype <- "undirected"
  
  if (!length(dots$rescale.node.size))
    dots$rescale.node.size <- FALSE
  
  # Building graph
  do.call(gexf, c(
    list(
      nodes = nodes[,c("id","name")],
      edges = edges
      ), dots)
  )

}

#' @export
#' @rdname igraph.to.gexf
gexf.to.igraph <- function(gexf.obj) {

  # Checks the class
  if (!inherits(gexf.obj,"gexf")) stop("-graph- is not of -gexf- class.") 
 
  g <- gexf.obj
  rm(gexf.obj)
  
  g2 <- igraph::graph.data.frame(
    g$edges[,c("source","target")],
    directed=(g$mode[[1]] != "undirected"),
    vertices=g$nodes[,c("id"),drop=FALSE]
    )
  
  # Labels
  igraph::V(g2)$name <- g$nodes$label
  
  # Nodes Viz atts
  if (length(x <- g$nodesVizAtt$color)) 
    igraph::V(g2)$color <- grDevices::rgb(x$r/255,x$g/255,x$b/255,x$a)
  
  if (length(x <- g$nodesVizAtt$size)) 
    igraph::V(g2)$size <- x$value
  
  if (length(x <- g$nodesVizAtt$position))
    g2 <- igraph::set_graph_attr(g2, "layout", unname(x))
  
  # Nodes atts
  if (length(x <- g$nodes[, !(colnames(g$nodes) %in% c("id", "label"))])) 
    for(i in names(x))
      g2 <- igraph::set.vertex.attribute(g2, i, value=x[,c(i)])
  

  # Edges atts
  if (length(x <- g$edges[, !(colnames(g$edges) %in% c("id", "source", "target", "weight") )])) 
    for(i in names(x))
      g2 <- igraph::set.edge.attribute(g2, i, value=x[,c(i)])
  
  
  # Edges Viz atts
  if (length(x <- g$edgesVizAtt$color)) 
    igraph::E(g2)$color <- grDevices::rgb(x$r/255,x$g/255,x$b/255,x$a)
  
  # Edges weights 
  if (length(x <- g$edges$weight)) 
   igraph::E(g2)$weight <- x
  
  
  return(g2)
}

