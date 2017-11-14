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

#' This function checks the color specification
#' @noRd
check_and_map_colors <- function(x, type) {
  
  # If specified as a vector
  if (is.vector(x)) {
    
    # If it is integer/numeric, then map it to colors()
    if (is.numeric(x))
      x <- grDevices::colors()[x]
    
    # Coercing to RGBA
    x <- t(grDevices::col2rgb(x, alpha=TRUE))
    
    # Where all colors able to be mapped?
    test <- which(!stats::complete.cases(x))
    if (length(test))
      stop("Not all the specified colors for ", type," were able to be mapped to",
           " RGBA, the following cases were incorrectly specified: ", 
           paste(test, collapse =", "), ".")
    
    # Rescaling the alpha
    x[, 4] <- x[, 4]/255
    
  } else if (is.matrix(x) | is.data.frame(x)) {
    
    # Coercing to a matrix
    x <- as.matrix(x)
    
    # Is numeric
    if (!is.numeric(x))
      stop("When specified as a matrix, colors should be passed as a numeric ",
           "matrix.", call. = FALSE)
    
    # If only three columns
    if (ncol(x) == 3) {
      
      x <- cbind(x, 1.0)
      
    } else if (ncol(x) == 4) {
      
      # Checking the range of colors
      ranges <- apply(x, 2, range)
      if (any(ranges[1, -4] < 0)  | any(ranges[2, -4] > 255))
        stop("The color specification for ", type, " is out of range.", call. = FALSE)
      if (ranges[1, 4] < 0 | ranges[2, 4] > 1)
        stop("The color specification for ", type, " is out of range.", call. = FALSE)
      
    } else if (ncol(x) != 4) {
      
      stop("When specified as a matrix, colors should be specified as RGB using ",
           " either 3 or 4 columns (including alpha) colors.", call. = FALSE)
      
    }
      
  } else
    stop("Color must be either a matrix specifying RGB(A) or a vector.")
  
  dimnames(x) <- list(NULL, paste0("viz.color.", c("r", "g", "b", "a")))
  
  as.data.frame(x)
}

# This function checks whether positions where correctly specified
check_positions <- function(x) {
  
  # Must be able to be coerced to a matrix
  x <- as.matrix(x)
  
  # Is it numeric?
  if (!is.numeric(x))
    stop("-nodesVizAtt$position- should be specified as a numeric matrix.")
  
  # Can all be mapped?
  test <- which(!complete.cases(x))
  if (length(test))
    stop("Some elements in -nodesVizAtt$position- have NA: ",
         paste(test, collapse=", "), ".")
  
  # Adding z?
  if (ncol(x) == 2)
    x <- cbind(x, 0)
  
  dimnames(x) <- list(NULL, paste0("viz.position.",c("x", "y", "z")))
  
  as.data.frame(x)
  
}


# Checks the size of the nodes to be numeric values
check_size <- function(x) {
  
  if (!is.numeric(x))
    stop("-nodesVizAtt$size- must be numeric.")
  
  data.frame(viz.size.value = unname(x))
  
}

check_image <- function(x) {
  
  x <- as.vector(x)
  
  if (!is.character(x))
    stop("-nodesVizAtt$image- should be character.")
  
  data.frame(
    viz.image.value = "image",
    viz.image.uri = unname(x)
    )

}

check_shape <- function(x) {
  
  x <- as.vector(x)
  
  if (!is.character(x))
    stop("-(nodes/edges)VizAtt$shape- should be character.")
  
  data.frame(
    viz.shape.value = unname(x)
  )
  
}

# Visual specifications, functions that take the attribute and 
# sets it according to GEXF standards. Currently the most complex one is
# colors and positions.
vizAttsSpecs <- list(
  color = check_and_map_colors,
  position = check_positions,
  size = check_size, 
  shape = check_shape,
  image = check_image
)

# This function takes any set of visual attributes and checks them accordingly
parseVizAtt <- function(att, dat, n, type=c("nodes", "edges")) {

  # Common checks --------------------------------------------------------------
  
  # If the data is a vector
  if (is.vector(dat)) {
    
    if (length(dat) == 1) {
      
      dat <- rep(dat, n)
      
    } else if (length(dat) < n) {
      
      stop("The attribute -",att,"- has incorrect length (has ",length(dat),
           ", and must have ",n,").")
      
    }
  
  # If the data data frame or a matrix
  } else if (inherits(dat, c("data.frame", "matrix"))) {
    
    if (nrow(dat) == 1) {
      
      dat <- do.call(rbind, replicate(n, dat))
      
    } else if (nrow(dat) != n) 
      stop("The attribute -",att,"- has incorrect number of rows (has ",
           nrow(dat)," and it must have ",n,").")
      
    if (ncol(dat) == 1L)
      dat <- dat[[1L]]
    
  # Otherwise, sorry, but we don't support that yet!
  } else
    stop("The attribute -",att,"- of class -",class(dat),"- is not supported.")
  
  
  # Attribute-specific checks --------------------------------------------------
  
  # What list of attrs
  checks <- if (type=="nodes") c("color", "position", "size", "shape", "image")
  else if (type=="edges") c("color", "size", "shape")
  
  # Applying specific checks
  if (att %in% checks) {
    
    vizAttsSpecs[[att]](dat)
    
  } else 
    stop("The attribute -", att,"- is not supported for -", type,"-. Only '",
            paste(checks, collapse="', '"), " are currently supported.") 
}


parseVectors <- function(x, n, attr.name) {
  
  x <- as.vector(x)
  
  # Checking length first
  if (length(x) == 1) {
    
    x <- rep(x, n)
    
  } else if (length(x) != n)
    stop("Incorrect length of -",attr.name,"-. It should be a vector of length ",
         n, ".", call. = FALSE)
  
  
}

# Parses edges weights checking dimentions and classes
.parseEdgesWeight <- function(edgesWeight, edges) {

  if (length(edgesWeight) == 0)
    return(invisible(NULL))
  
  # Coercing into the right class
  if (is.vector(edgesWeight))
    edgesWeight <- matrix(edgesWeight, ncol=1)
  else if (is.data.frame(edgesWeight))
    edgesWeight <- as.matrix(edgesWeight)
  
  if (is.matrix(edgesWeight)) {
    
    if (nrow(edgesWeight) != nrow(edges))
      stop("-edgesWeight- should have the same number of rows than edges",
           " there are (", nrow(edges),"). ", call. = FALSE)
    
    if (ncol(edgesWeight) > 1)
      stop("-edgesWeight- should have only one column.", call. = FALSE)
    
  } else
    stop("Invalid object type: -edgesWeight- should be a one column",
         "data.frame, a matrix or a vector.", call. = FALSE)
  
}

# Parses edges attributes checking dimentions and classes
.parseEdgesAtt <- function(edgesAtt, edges) {

  if ((nEdgesAtt <- length(edgesAtt)) == 0)
    return(0)
  
  if (is.data.frame(edgesAtt) | is.matrix(edgesAtt) | is.vector(edgesAtt)) {
    
    if (nrow(edgesAtt) != nrow(edges))
      stop("-edgesAtt- should have the same number of rows than edges there are (",
           nrow(edges),").", call. = FALSE)
    else
      return(nEdgesAtt)
    
  }
  else
    stop("Invalid object type: -edgesAtt- should be a data.frame, a matrix",
         "or a vector", call. = FALSE)
    
  
}


# Parses edges Ids and if does not exists it creates them
.parseEdgesId <- function(edgesId, edges) {

  if (length(edgesId) == 0)
    return(data.frame(id=0:(NROW(edges) - 1)))
  
  if (is.data.frame(edgesId) | is.matrix(edgesId) | is.vector(edgesId)) {
    
    if (ncol(edgesId) != 1)
      stop("-edgesId- should have one column not ", ncol(edgesId), ".",
           call. = FALSE)
    
  } else
    stop("Invalid object type: -edgesId- should be a one column data.frame or",
         "a matrix", call. = FALSE)
    
}


# Parses nodes attributes checking dimentions
.parseNodesAtt <- function(nodesAtt, nodes) {

  if ((nNodesAtt <- length(nodesAtt)) > 0) {
    
    if (is.data.frame(nodesAtt) | is.matrix(nodesAtt) | is.vector(nodesAtt)) {
      
      if (NROW(nodesAtt) != NROW(nodes))
        stop("Insuficient number of rows: -nodesAtt- (", nrow(nodesAtt),
             " rows) should have the same number of rows than nodes there are (",
             nrow(nodes),")", call. = FALSE)
      else
        return(nNodesAtt)
      
    } else
      stop("Invalid object type: -nodesAtt- should be a data.frame, a matrix",
           " or a vector.", call. = FALSE)
    
  }
  else return(0)
}


# Parses edges labels checking dimentions
.parseEdgesLabel <- function(edgesLabel, edges) {

  # Is there anything to do?
  if (length(edgesLabel) == 0)
    return(invisible(NULL))
  
  if (is.data.frame(edgesLabel) | is.matrix(edgesLabel) | is.vector(edgesLabel)) {
    
    if (ncol(edgesLabel) != 1)
      stop("-edgesLabel- should have one column not ", ncol(edgesLabel), ".",
           call. = FALSE)
    
  } else
    stop("Invalid object type: -edgesLabel- should be a one column",
         " data.frame or a matrix.", call. = FALSE)

  
}

# Parses edges labels checking dimentions
.parseDataTypes <- function(x, keepFactors=TRUE) {

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
