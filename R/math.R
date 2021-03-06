################################################################################
# COLLECTION OF FUNCTIONS FOR EDGES ANALYSIS
################################################################################



#' Check (and count) duplicated edges
#' 
#' Looks for duplicated edges and reports the number of instances of them.
#' 
#' `check.dpl.edges` looks for duplicated edges reporting duplicates and
#' counting how many times each edge is duplicated.
#' 
#' For every group of duplicated edges only one will be accounted to report
#' number of instances (which will be recognized with a value higher than 2 in
#' the `reps` column), the other ones will be assigned an `NA` at the
#' `reps` value.
#' 
#' @param edges A matrix or data frame structured as a list of edges
#' @param undirected Declares if the net is directed or not (does de difference)
#' @param order.edgelist Whether to sort the resulting matrix or not
#' @return A three column `data.frame` with colnames \dQuote{source},
#' \dQuote{target} \dQuote{reps}.
#' @author George Vega Yon 
#' @keywords manip
#' @examples
#' 
#'   # An edgelist with duplicated dyads
#'   relations <- cbind(c(1,1,3,3,4,2,5,6), c(2,3,1,1,2,4,1,1))
#'   
#'   # Checking duplicated edges (undirected graph)
#'   check.dpl.edges(edges=relations, undirected=TRUE)
#' @family manipulation
#' @export
check.dpl.edges <- function(edges, undirected=FALSE, order.edgelist=TRUE) {
################################################################################
# Checks for duplicated edges, and switchs between source and target
# (optionally).
################################################################################  
  
  if (any(!is.finite(edges) | is.null(edges)))
    stop("No NA, NULL or NaN elements can be passed to this function.")
 
  edges0 <- cbind(edges, id = 1:nrow(edges))
  if (undirected)
    edges <- switch.edges(edges)
  
  # Unique dataset
  edges_unique <- unique(edges)
  
  # Counting
  edges <- cbind(edges, id = 1:nrow(edges))
  edges <- edges[order(edges[,1], edges[,2]), ]
  
  # Binary of counts
  counts <- c(
    TRUE,
    (edges[-1, 1] != edges[-nrow(edges), 1]) |
      (edges[-1, 2] != edges[-nrow(edges), 2])
  )
  
  counts <- cumsum(counts)
  
  # Now we say which to keep, we keep the thing if the count is either equal or smaller
  to_keep <- which( c(counts[-1] > counts[-length(counts)], TRUE))
  
  dupls <- cumsum(
    c(TRUE, (edges[-1, 1] == edges[-nrow(edges), 1]) &
        (edges[-1, 2] == edges[-nrow(edges), 2])
      ))
  
  edges <- cbind(edges, counts = dupls)[to_keep, , drop = FALSE]
  edges[, "counts"] <- edges[, "counts"] - c(1, edges[-nrow(edges), "counts"]) + 1
  edges <- edges[order(edges[, "id"]), , drop = FALSE]
  
  
  result <- data.frame(id = edges[,"id"], reps=edges[,"counts"], check.names=FALSE)
  
  # Merging 
  result <- merge(
    data.frame(source = edges0[,1], target = edges0[,2], id = edges0[,3]),
    subset(result), by = "id", all.x = TRUE
  )
  result <- result[order(result$id),]

  if (order.edgelist) 
    result <- result[order(result[,1], result[,2]),]
  
  return(result[, c("source", "target", "reps")])
}



#' Switches between source and target
#' 
#' Puts the lowest id node among every dyad as source (and the other as target)
#' 
#' `edge.list` transforms the input into a two-elements list containing a
#' dataframe of nodes (with columns \dQuote{id} and \dQuote{label}) and a
#' dataframe of edges. The last one is numeric (with columns \dQuote{source}
#' and \dQuote{target}) and based on auto-generated nodes' ids.
#' 
#' @param edges A matrix or data frame structured as a list of edges
#' @return A list containing two data frames.
#' @author George Vega Yon 
#' @keywords manip
#' @examples
#' 
#'   relations <- cbind(c(1,1,3,4,2,5,6), c(2,3,1,2,4,1,1))
#'   relations
#'   
#'   switch.edges(relations)
#' @export
#' @family manipulation
switch.edges <- function(edges) {
################################################################################
# Orders pairs of edges by putting the lowest id first as source
################################################################################
  if (any(is.na(edges) | is.null(edges) | is.nan(edges))) 
    stop("No NA, NULL or NaN elements can be passed to this function.")

  which_min <- which(max.col(edges) == 1)
  edges[which_min, ] <- edges[which_min, 2:1]
  
  return(
    data.frame(
      source=edges[,1], 
      target=edges[,2],
      check.names=FALSE)
  )
}

#try(dyn.unload("src/RCheckDplEdges.so"))
#dyn.load("src/RCheckDplEdges.so")

#relations <- cbind(c(1,1,3,4,2,5,6), c(2,3,1,2,4,1,1))


#check.dpl.edges(relations)
#ordAndCheckDplEdges(relations, undirected=FALSE)
#switch.edges(relations)
