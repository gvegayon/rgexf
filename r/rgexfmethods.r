print.gexf <- function(x, file=NA, replace=F, ...) {
  ################################################################################
  # Printing method
  ################################################################################
  if (is.na(file)) {
    cat(x)
  }
  else {
    output <- file(description=file,open="w",encoding='UTF-8')
    write(x, file=output,...)
    close.connection(output)
  }
}