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
#' if (interactive()) {
#'   # Running demo
#'   demo(gexfigraph)
#' }
#'  
#'   fn <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#'   gexf1 <- read.gexf(fn)
#'   igraph1 <- gexf.to.igraph(gexf1)
#'   gexf2 <- igraph.to.gexf(igraph1)
#'   
#' if (interactive()) {
#'   # Now, let's do it with a layout! (although we can just use
#'   # the one that comes with lesmiserables :))
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
  edges <- gdata$edges
  nodes <- cbind(id = 1L:igraph::vcount(g), gdata$vertices)

  # If nodes have no name
  namecol <- which(colnames(nodes) == "name")
  if (!length(namecol)) 
    nodes <- data.frame(nodes, label=rownames(nodes))
  else
    nodes$label <- nodes$name
  

  edges$source <- rownames(nodes)[match(edges$from, rownames(nodes))]
  edges$target <- rownames(nodes)[match(edges$to, rownames(nodes))]
  #edges <- edges[, c("source", "target")]
  
  # Nodes Attributes
  x <- igraph::list.vertex.attributes(g)
  x <- x[!(x %in% c("label", "color", "size", "name"))]
  if (length(x))
    dots$nodesAtt <- subset(nodes, select = x)
  
  # Edges Attributes
  x <- igraph::list.edge.attributes(g)
  x <- x[!(x %in% c("weight","color","edgesLabel","width"))]
  if (length(x)) 
    dots$edgesAtt <- subset(edges, select = x)
  
  # Edges Weights
  if (!length(dots$edgesWeight) && length(igraph::E(g)$weight))
    dots$edgesWeight <- igraph::E(g)$weight
  else
    dots$edgesWeight <- NULL
  
  # Nodes Viz att
  if (!length(dots$nodesVizAtt$color)) {
    if (length(nodes$color)) {
      dots$nodesVizAtt$color <- nodes$color
    } else 
      dots$nodesVizAtt$color <- NULL
  }
  
  if (!length(dots$nodesVizAtt$size) && length(nodes$size))
    dots$nodesVizAtt$size <- nodes$size
  
  positions <- igraph::graph_attr(g, "layout")
  
  if (!length(dots$nodesVizAtt$position) && length(positions)) {
    dots$nodesVizAtt$position <- viz_att_checks$position(positions)
    
  }
    
  # Edges Viz att
  if (!length(dots$edgesVizAtt$color)) {
    if (length(edges$color)) {
      dots$edgesVizAtt$color <- edges$color
    } else
      dots$edgexVizAtt$color <- NULL
  }
  
  # Edge type
  if (!length(dots$defaultedgetype) && igraph::is.directed(g)) 
    dots$defaultedgetype <- "directed"
  else 
    dots$defaultedgetype <- "undirected"
  
  if (!length(dots$rescale.node.size))
    dots$rescale.node.size <- TRUE
  
  # Building graph
  do.call(gexf, c(
    list(
      nodes = data.frame(
        id   = rownames(nodes),
        name = nodes$label,
        stringsAsFactors = FALSE
        ),
      edges = edges[, c("source", "target")]
      ), dots)
  )

}

#' @export
#' @rdname igraph.to.gexf
gexf.to.igraph <- function(gexf.obj) {

  # Checks the class
  if (!inherits(gexf.obj,"gexf")) stop("-graph- is not of -gexf- class.") 

  g2 <- igraph::graph.data.frame(
    gexf.obj$edges[,c("source","target")],
    directed = gexf.obj$mode[[1]] != "undirected",
    vertices = gexf.obj$nodes[,c("id"),drop=FALSE]
    )
  
  # Labels
  igraph::V(g2)$name <- gexf.obj$nodes$label
  
  # Nodes Viz atts
  if (length(x <- gexf.obj$nodesVizAtt$color)) 
    igraph::V(g2)$color <- grDevices::rgb(x$r/255,x$g/255,x$b/255,x$a)
  
  if (length(x <- gexf.obj$nodesVizAtt$size)) 
    igraph::V(g2)$size <- x$value
  
  if (length(x <- gexf.obj$nodesVizAtt$position))
    g2 <- igraph::set_graph_attr(
      g2, "layout", 
      unname(as.matrix(x))
      )
  
  # Nodes atts
  if (length(x <- gexf.obj$nodes[, !(colnames(gexf.obj$nodes) %in% c("id", "label")), drop=FALSE])) 
    for(i in names(x))
      g2 <- igraph::set.vertex.attribute(g2, i, value=x[,c(i)])
  

  # Edges atts
  if (length(x <- gexf.obj$edges[, !(colnames(gexf.obj$edges) %in% c("id", "source", "target", "weight") )])) 
    for(i in names(x))
      g2 <- igraph::set.edge.attribute(g2, i, value=x[,c(i)])
  
  
  # Edges Viz atts
  if (length(x <- gexf.obj$edgesVizAtt$color)) 
    igraph::E(g2)$color <- grDevices::rgb(x$r/255,x$g/255,x$b/255,x$a)
  
  # Edges weights 
  if (length(x <- gexf.obj$edges$weight)) 
   igraph::E(g2)$weight <- x
  
  
  return(g2)
}

