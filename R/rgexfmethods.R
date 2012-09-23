print.gexffile <- function(x, file=NA, replace=F, ...) {
  ################################################################################
  # Printing method
  ################################################################################
  if (is.na(file)) {
    cat(x[[1]])
  }
  else {
    output <- file(description=file,open="w",encoding='UTF-8')
    write(x[[1]], file=output,...)
    close.connection(output)
  }
}