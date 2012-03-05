print.gexf <- function(x, file=NA, replace=F, ...) {
  ################################################################################
  # Printing method
  ################################################################################
  if (is.na(file)) {
    cat(x)
  }
  else {
    output <- file(description=file,encoding='UTF-8')
    cat(x, file=output,...)
    close.connection(output)
  }
}