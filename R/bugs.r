#' Checks for correct time format
#' 
#' Checks time
#' 
#' 
#' @param x A string or vector char
#' @param format String, can be \dQuote{date}, \dQuote{dateTime},
#' \dQuote{float}
#' @return Logical.
#' @author George Vega Yon 
#' 
#' Jorge Fabrega Lacoa 
#' @keywords utilities
#' @examples
#' 
#'   test <- c("2012-01-17T03:46:41", "2012-01-17T03:46:410")
#'   checkTimes(test, format="dateTime")
#'   checkTimes("2012-02-01T00:00:00", "dateTime")
#' @export
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

vizAttsSpecs <- list(
  color = function(x) {
    if (is.vector(x) || ncol(x) == 1) {
      warning("Trying to coerce colors into RGBA")
      return( cbind(t(col2rgb(x)), 1) )
    } else if (ncol(x) != 4) # Must be 4-columns
      stop("the color attribute must have 4 columns (RGBA).")
    
    # Must have the right range
    if (max(x[,-4]) > 255 || min(x[,-4]) < 0) 
      stop("The RGB colors must be in the range [0,255].")
    
    if (max(x[,4]) > 1 | min(x[,4]) < 0)
      stop("The alpha part of the colors (4th column) must be within [0,1].")
    
    return(x)
    
  },
  position = function(x) x,
  size = function(x) x, 
  shape = function(x) x,
  image = function(x) x
)

parseVizAtt <- function(att, dat, n, type=c("nodes", "edges")) {
  # Generic checks
  if (is.vector(dat)) {
    if (length(dat) < n)
      stop("The attribute -",att,"- has incorrect length (has ",length(dat),
           ", and must have ",n,").")
  } else if (inherits(dat, c("data.frame", "matrix"))) {
    if (nrow(dat) != n)
      stop("The attribute -",att,"- has incorrect number of rows (has ",
           nrow(dat)," and it must have ",n,").")
  } else stop("The attribute -",att,"- of class -",class(dat),"- is not supported.")
  
  # What list of attrs
  checks <- if (type=="nodes") c("color", "position", "size", "shape", "image")
  else if (type=="edges") c("color", "size", "shape")
  
  if (att %in% checks) vizAttsSpecs[[att]](dat)
  else stop("The attribute -", att,"- is not supported for -", type,"-. Only '",
            paste(checks, collapse="', '"), " are currently supported.") 
}

.parseEdgesWeight <- function(edgesWeight, edges) {
################################################################################
# Parses edges weights checking dimentions and classes
################################################################################
  if (length(edgesWeight) > 0) {
    if (is.vector(edgesWeight) | is.data.frame(edgesWeight) | is.matrix(edgesWeight)) {
      if (NROW(edgesWeight) != NROW(edges)) stop("\"edgesWeight\" should have the same number of rows than edges there are (", NROW(edges),")")
      if (NCOL(edgesWeight) > 1) stop("\"edgesWeight should have only one column\"")
    }
    else stop("Invalid object type: \"edgesWeight\" should be a one column data.frame, a matrix or a vector")
  }
}

.parseEdgesAtt <- function(edgesAtt, edges) {
################################################################################
# Parses edges attributes checking dimentions and classes
################################################################################
  if ((nEdgesAtt <- length(edgesAtt)) > 0) {
    if (is.data.frame(edgesAtt) | is.matrix(edgesAtt) | is.vector(edgesAtt)) {
      if (NROW(edgesAtt) != NROW(edges)) stop(paste("\"edgesAtt\" should have the same number of rows than edges there are (", NROW(edges),")",sep=""))
      else return(nEdgesAtt)
    }
    else stop("Invalid object type: \"edgesAtt\" should be a data.frame, a matrix or a vector")
  }
  else return(0)
}

.parseEdgesId <- function(edgesId, edges) {
################################################################################
# Parses edges Ids and if does not exists it creates them
################################################################################
  if (length(edgesId) > 0) {
    if (is.data.frame(edgesId) | is.matrix(edgesId) | is.vector(edgesId)) {
      if (NCOL(edgesId) != 1) stop("\"edgesId\" should have one column not ", NCOL(edgesId))
    }
    else stop("Invalid object type: \"edgesId\" should be a one column data.frame or a matrix")
  }
  else return(data.frame(id=0:(NROW(edges) - 1)))
}

.parseNodesAtt <- function(nodesAtt, nodes) {
################################################################################
# Parses nodes attributes checking dimentions
################################################################################
  if ((nNodesAtt <- length(nodesAtt)) > 0) {
    if (is.data.frame(nodesAtt) | is.matrix(nodesAtt) | is.vector(nodesAtt)) {
      if (NROW(nodesAtt) != NROW(nodes)) stop("Insuficient number of rows: \"nodesAtt\" (", NROW(nodesAtt)," rows) should have the same number of rows than nodes there are (", NROW(nodes),")")
      else return(nNodesAtt)
    }
    else stop("Invalid object type: \"nodesAtt\" should be a data.frame, a matrix or a vector")
  }
  else return(0)
}

.parseEdgesLabel <- function(edgesLabel, edges) {
################################################################################
# Parses edges labels checking dimentions
################################################################################
  if (length(edgesLabel) > 0) {
    if (is.data.frame(edgesLabel) | is.matrix(edgesLabel) | is.vector(edgesLabel)) {
      if (NCOL(edgesLabel) != 1) stop("\"edgesLabel\" should have one column not ", NCOL(edgesLabel))
    }
    else stop("Invalid object type: \"edgesLabel\" should be a one column data.frame or a matrix")
  }
}

.parseDataTypes <- function(x, keepFactors=TRUE) {
################################################################################
# Parses edges labels checking dimentions
################################################################################
  # Whether to keep factors as numeric values or not
  if (keepFactors) x <- as.numeric(x)
  else x <- as.character(x)
  
  # Data
  type <- typeof(x)
  if (type == "character") return("string")
  else if (type == "double") return("float")
  else if (type == "logical") return("boolean")
  else return(type)        
}
