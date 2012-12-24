print.gexf <- function(x, file=NA, replace=F, ...) {
################################################################################
# Printing method
################################################################################
  if (is.na(file)) {
    cat(x[[1]])
  }
  else {
    output <- file(description=file,open="w",encoding='UTF-8')
    write(x$graph, file=output,...)
    close.connection(output)
    message('GEXF graph successfully written at:\n',normalizePath(file))
  }
}