#' @name gexf-methods
#' @export
print.gexf <- function(x, file = NA, replace = F, ...) {

  cat(x$graph, "\n")
  invisible(x)

}

#' @name gexf-methods
#' @export
summary.gexf <- function(object, ...) {

  result <- list(
    "N of nodes" = NROW(object$nodes), 
    "N of edges" = NROW(object$edges),
    "Node Attrs" = utils::head(object$atts.definitions$nodes),
    "Edge Attrs" = utils::head(object$atts.definitions$edges)
  )
  
  #class(result) <- "table"
  cat("GEXF graph object\n")
  result

}

build.and.validate.gexf <- function(
  meta = list(
    creator     = "NodosChile",
    description = "A graph file writing in R using \'rgexf\'",
    keywords    = "gexf graph, NodosChile, R, rgexf"
    ),
  mode = list(
    defaultedgetype = "undirected",
    mode            = "static"
    ),
  atts.definitions = list(
    nodes = NULL,
    edges = NULL
    ),
  nodesVizAtt = NULL,
  edgesVizAtt = NULL,
  nodes,
  edges,
  graph
  ) {
  
  # Shorcuts
  .c <- function(x, s) {
      if (NROW(x)) !all(colnames(x) %in% s)
      else return(FALSE)
  }
  .n <- function(x, s) !all(names(x) %in% s)
  
  # Check meta-data
  if (.n(meta, c("creator", "description", "keywords")))
    stop("Invalid meta: Check names")
  else {
    for (i in meta) {
      if (!inherits(i, "character"))
        stop("Invalid meta: only character allowed")
    }
  }
  
  # Check mode
  if (.n(mode, c("defaultedgetype", "mode")))
    stop("Invalid mode: Check names")
  else {
    for (i in mode) {
      if (!inherits(i, "character"))
        stop("Invalid mode: only character allowed")
    }
  }
  
  # Checking atts definition
  if (.n(atts.definitions, c("nodes", "edges"))) 
    stop("Invalid atts.definitions: Check names")
  else {
    for (i in atts.definitions) {
      
      # If its empty, then continue
      if (!length(i)) next
      
      if (!inherits(i, "data.frame"))
        stop("Invalid atts.definitions: only data-frames allowed")
      else {
        if (.c(atts.definitions$nodes, c("id", "title", "type")))
          stop("Invalid atts.definitions: Check -nodes- colnames")
        if (.c(atts.definitions$edges, c("id", "title", "type")))
          stop("Invalid atts.definitions: Check -nodes- colnames")
      }
    }
  }
  
  # Checking nodesVizAtt definition
  if (.n(nodesVizAtt, c("color", "position", "size", "shape", "image")))
    stop("Invalid nodesVizAtt: Check names")
  else {    
    for (i in names(nodesVizAtt)) {
      if (i == "color" & .c(nodesVizAtt[[i]], c("r","g","b","a"))) 
        stop("Invalid nodesVizAtt: Check -color- colnames")
      else if (i == "position" & .c(nodesVizAtt[[i]], c("x","y","z")))
        stop("Invalid nodesVizAtt: Check -position- colnames")
      else if (i == "size" & .c(nodesVizAtt[[i]], "value"))
        stop("Invalid nodesVizAtt: Check -size- colname")        
      else if (i == "shape" & .c(nodesVizAtt[[i]], "value"))
        stop("Invalid nodesVizAtt: Check -shape- colname")
      else if (i == "image" & .c(nodesVizAtt[[i]], c("value","uri"))) 
        stop("Invalid nodesVizAtt: Check -image- colname")
    }
  }
  
  # Checking edgesVizAtt definition
  if (.n(edgesVizAtt, c("color", "size", "shape")))
    stop("Invalid edgesVizAtt: Check names")
  else {
    for (i in names(edgesVizAtt)) {
      if (i == "color" & .c(edgesVizAtt[["i"]], c("r", "g", "b", "a"))) 
        stop("Invalid edgesVizAtt: Check -color- colnames")
      else if (i == "size" & .c(edgesVizAtt[["i"]], "value"))
        stop("Invalid edgesVizAtt: Check -size- colnames")
      else if (i == "shape" & .c(edgesVizAtt[["i"]], "value"))
        stop("Invalid edgesVizAtt: Check -shape- colname")
    }
  }
  
  # Checking nodes
  if (NROW(nodes)) {
    if (!all(c("id", "label") %in% colnames(nodes)))
      stop("Invalid nodes: Check colnames")
    else {
      nodes <- nodes[,unique(c("id", "label", colnames(nodes)))]
      nodes <- nodes[,!grepl("^viz\\.[a-z]*\\.", colnames(nodes))]
    }
  }
  
  # Checking edges
  if (NROW(edges)) {
    if (!all(c("id", "source", "target", "weight") %in% colnames(edges)))
      stop("Invalid edges: Check colnames")
    else {
      edges <- edges[,unique(c("id", "source", "target", "weight",colnames(edges)))]
      edges <- edges[, !grepl("^viz\\.[a-z]*\\.", colnames(edges))]
    }
  }  
  
  # Returns the output
  structure(list(
    meta             = unlist(meta),
    mode             = unlist(mode),
    atts.definitions = atts.definitions,
    nodesVizAtt      = nodesVizAtt,
    edgesVizAtt      = edgesVizAtt,
    nodes            = nodes,
    edges            = edges,
    graph            = graph
    ), class = "gexf")
}


#' `head` method for gexf objects
#' 
#' List the first `n_nodes` and `n_edges` of the [gexf] file.
#' 
#' @param x An object of class [gexf].
#' @param n_nodes,n_edges Integers. Number of nodes and edges to print
#' @param ... Ignored
#' @examples 
#' fn <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")
#' g  <- read.gexf(fn)
#' head(g, n_nodes = 5)
#' @export
head.gexf <- function(x, n_nodes = 6L, n_edges = n_nodes, ...) {
  
  if (n_nodes == 0L | n_edges == 0L)
    stop("n_nodes and n_edges should be a positive integer.")
  
  # Splitting the XML
  txt <- strsplit(x$graph, split = "\n")[[1L]]
  ids <- 1L
  
  # Finding the start and end point of nodes and edges
  # nodes_start <- which(grepl("^\\s*<node[^>]*>", txt))
  nodes_end <- which(grepl("^\\s*</node[^>]*>", txt))
  n_nodes   <- min(length(nodes_end), n_nodes)
  
  # Extending
  if (n_nodes) {
    ids <- ids:nodes_end[n_nodes]
    nodes_end <- which(grepl("\\s*</nodes>", txt))
  } else {
    nodes_end <- which(grepl("\\s*<nodes/>", txt))
    ids <- ids:nodes_end
  }
  
  # Checking edges now
  edges_start <- which(grepl("^\\s*(<edge[^>]*>)", txt))
  n_edges     <- min(length(edges_start), n_edges)
  
  if (n_edges) {
    
    if (n_edges > 1L)
      edges_end <- c(edges_start[-1L], which(grepl("^\\s*</edges>", txt)))
    else
      edges_end <- edges_start
    
    ids <- c(ids, nodes_end:edges_end[n_edges])
    ids <- c(ids, edges_end[length(edges_end)]:length(txt))
    
  } else 
    ids <- c(ids, nodes_end:length(txt))
  
  ids <- sort(unique(ids))
  
  # Figuring out the print
  txt <- txt[ids]
  if (n_nodes && nrow(x$nodes) > n_nodes) {
    where <- grepl("^\\s*</nodes>", txt)
    txt[where] <- paste("\t\t\t...\n", txt[where])
  }
  
  if (n_edges && nrow(x$edges) > n_edges) {
    where <- grepl("^\\s*</edges>", txt)
    txt[where] <- paste("\t\t\t...\n", txt[where])
  }
  
  cat(txt, sep = "\n")
  # 
  invisible(x)
  
}
