checkTimes <- function(x, format='date') {
  ################################################################################
  # A a function of format, checks that all data has the correct format
  ################################################################################
  
  # Defining regular expressions to match
  if (format=='date') {
    match <- '^[0-9]{4}[-]{1}[01-12]{2}[-]{1}[01-31]{2}$'
  }
  else if (format == 'dateTime') {
    match <- '^[0-9]{4}[-][0-9]{2}[-][0-9]{2}[T][0-9]{2}[:][0-9]{2}[:][0-9]{2}$'
  }
  else if (format == 'float') {
    match <- '^[0-9]+[.]{1}[0-9]+$'
  }
  
  # Defining matchin function
  FUN <- function(x, pattern,...) {
    x <- grepl(pattern, x)
  }
  # listapply
  result <- lapply(x, FUN, pattern=match)
  result <- unlist(result, use.names=F)
  return(result)
}

#test <- c('2012-01-17T03:46:41', '2012-01-17T03:46:410')

#checkTimes(test, format='dateTime')
#checkTimes('2012-02-01T00:00:00', 'dateTime')