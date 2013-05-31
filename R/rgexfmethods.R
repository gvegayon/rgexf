print.gexf <- function(x, file=NA, replace=F, ...) {
################################################################################
# Printing method
################################################################################
  if (is.na(file)) {
    cat(x$graph)
  }
  else {
    output <- file(description=file,open="w",encoding='UTF-8')
    write(x$graph, file=output,...)
    close.connection(output)
    message('GEXF graph successfully written at:\n',normalizePath(file))
  }
}

summary.gexf <- function(object, ...) {
  ################################################################################
  # Printing method
  ################################################################################
  result <- list("N of nodes"=NROW(object$nodes), 
                 "N of edges"=NROW(object$edges),
                 "Node Attrs"=head(object$atts.definitions$node.att),
                 "Edge Attrs"=head(object$atts.definitions$edge.att))
  #class(result) <- "table"
  cat("GEXF graph object\n")
  result
}
