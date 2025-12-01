#' Decompose an edge list
#' 
#' Generates two data frames (nodes and edges) from a list of edges
#' 
#' `edge.list` transforms the input into a two-elements list containing a
#' dataframe of nodes (with columns \dQuote{id} and \dQuote{label}) and a
#' dataframe of edges. The last one is numeric (with columns \dQuote{source}
#' and \dQuote{target}) and based on auto-generated nodes' ids.
#' 
#' @param x A matrix or data frame structured as a list of edges
#' @return A list containing two data frames.
#' @author George Vega Yon 
#' 
#' Jorge Fabrega Lacoa 
#' @keywords manip
#' @examples
#' 
#'   edgelist <- matrix(
#'     c("matthew","john",
#'       "max","stephen",
#'       "matthew","stephen"),
#'     byrow=TRUE, ncol=2)
#'   
#'   edge.list(edgelist)
#' 
#' @export
edge.list <- function(x) {

  objClass <- class(x)
  k        <- ncol(x)
  
  if (any(c("matrix", "data.frame") %in% objClass)) {
    
    if (k == 2) {
      # If it is not a factor
      if (!is.factor(x)) x <- factor(c(x[,1], x[,2]))
      edges <- matrix(unclass(x), byrow=FALSE, ncol=2)
      colnames(edges) <- c("source","target")
      nodes <- data.frame(id=1:nlevels(x), label=levels(x), stringsAsFactors=FALSE)
      
      return(list(nodes=nodes, edges=edges))
    }
    else stop("Insufficient number of columns (", k,")")
  }
  else stop("-", objClass, 
                  "- class not supported, try with a \"matrix\" or a \"data.frame\"")
}

#' Prints the nodes and edges att definition
#' @noRd
.defAtt <- function(x, parent) {

  apply(
    x, MARGIN=1L,
    function(x, PAR) {
      XML::newXMLNode(name = "attribute", parent = PAR, attrs = x)
    },
    PAR = parent
  )
}

#' Builds app proper XML attrs statement to be parsed by parseXMLAndAdd
#' @noRd
.addAtts <- function(tmpatt, attvec, tmpdoc = NULL) {

  tmpatt <- data.frame(
    "for" = paste0("att", attvec), 
    value = unlist(tmpatt, recursive = FALSE), check.names = FALSE
    )

  for (i in attvec) 
    tmpdoc <- c(tmpdoc, .writeXMLLine("attvalue", tmpatt[i,,drop=FALSE ]) , sep="") 

  paste0(c("<attvalues>", tmpdoc, "</attvalues>"), collapse = "")
}

#' Builds as character whatever XML line is needed
#' @noRd 
.writeXMLLine <- function(type, obj, finalizer=TRUE) {

  paste0(
    "<", type, " " ,
    paste(colnames(obj)[!is.na(obj)],obj[!is.na(obj)], sep="=\"", collapse="\" "),
    ifelse(finalizer, "\"/>","\">")
    )
}

#' Prints the nodes and edges
#' @noRd
.addNodesEdges <- function(dataset, PAR, type="node", doc) {

  n <- NROW(dataset)
  vec <- 1:n
  xvars <- colnames(dataset)
  
  noattnames <- xvars[grep("(^att[0-9])|(^viz[.])", xvars, invert=T)]
  datasetnoatt <- dataset[, noattnames, drop=FALSE]
  
  # Parsing user-define attributes
  if (attributes <- length(grep("^att", xvars)) > 0) {
    attnames <- colnames(dataset)[grep("^att", xvars)]
    att <- dataset[,attnames, drop=FALSE]
    attvec <- 1:length(attnames)
  }
  
  # Parsing VIZ attributes
  if ((vizattributes <- length(grep("^viz[.]", xvars)) > 0)) {
    vizattnames <- colnames(dataset)[grep("^viz[.]", xvars)]
    
    # Color atts
    if ((vizcolors <- any(grepl("^viz[.]color",vizattnames)))) {
      vizcol.df <- dataset[,grep("^viz[.]color[.]", vizattnames, value=TRUE)]
      colnames(vizcol.df) <- gsub("^viz[.]color[.]", "", colnames(vizcol.df))
    }
    
    # Pos att
    if ((vizposition <- any(grepl("^viz[.]position",vizattnames)))) {
      vizpos.df <- dataset[,grep("^viz[.]position[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizpos.df) <- gsub("^viz[.]position[.]", "", colnames(vizpos.df))
    }
    
    # Size att
    if ((vizsize <- any(grepl("^viz[.]size",vizattnames)))) {
      vizsiz.df <- dataset[,grep("^viz[.]size[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizsiz.df) <- gsub("^viz[.]size[.]", "", colnames(vizsiz.df))
    }
    
    # Shape att
    if ((vizshape <- any(grepl("^viz[.]shape",vizattnames)))) {
      vizshp.df <- dataset[,grep("^viz[.]shape[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizshp.df) <- gsub("^viz[.]shape[.]", "", colnames(vizshp.df))
    }
    
    # Image att
    if ((vizimage <- any(grepl("^viz[.]image",vizattnames)))) {
      vizimg.df <- dataset[,grep("^viz[.]image[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizimg.df) <- c("value", "uri")
    }
    
    # Thickness att
    if ((viztness <- any(grepl("^viz[.]size",vizattnames)))) {
      vizthk.df <- dataset[,grep("^viz[.]size[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizthk.df) <- gsub("^viz[.]size[.]", "", colnames(vizthk.df))
    }
  }

  # Free memory
  rm(dataset)
  
  # Loop if there are not any attributes
  if (!attributes && !vizattributes) {
    for (i in vec) {
      XML::parseXMLAndAdd(.writeXMLLine(type, datasetnoatt[i,,drop=FALSE]),parent=PAR)
    }
    return(NULL)
  }
  
  # Loop if only there are attributes
  if (attributes && !vizattributes) {
    
    for (i in vec) {      
      # Adding directly
      XML::parseXMLAndAdd(
        paste(.writeXMLLine(type, datasetnoatt[i,,drop=FALSE], finalizer=FALSE), 
              .addAtts(att[i,], attvec), # Builds atts definition
              "</",type,">",sep=""),
        parent=PAR)
    }
    return(NULL)
  }
  
  # Loop if there are attributes and viz attributes
  for (i in vec) {
    # Node/Edge + Atts 
    if (attributes) {
      tempnode0 <- paste(
        .writeXMLLine(type, datasetnoatt[i,,drop=FALSE], finalizer=FALSE),
        .addAtts(att[i,], attvec), sep="")
    }
    else tempnode0 <- .writeXMLLine(type, datasetnoatt[i,,drop=FALSE], finalizer=FALSE)
    
    # Viz Att printing
    # Colors
    if (vizcolors) {
      tempnode0 <- paste(tempnode0, .writeXMLLine("color", vizcol.df[i,,drop=FALSE]),
                         sep="")
    }
    # Position
    if (vizposition) {
      tempnode0 <- paste(tempnode0, .writeXMLLine("position", vizpos.df[i,,drop=FALSE]),
                         sep="")
    }
    # Size
    if (vizsize) {
      tempnode0 <- paste(tempnode0, .writeXMLLine("size", vizsiz.df[i,1, drop=FALSE]),
                         sep="")
    }
    # Shape
    if (vizshape) {
      tempnode0 <- paste(tempnode0, .writeXMLLine("shape", vizshp.df[i,1,drop=FALSE]),
                         sep="")
    }
    # Image
    if (vizimage) {
      tempnode0 <- paste(tempnode0, .writeXMLLine("shape", vizimg.df[i,,drop=FALSE]),
                         sep="")
    }
    XML::parseXMLAndAdd(sprintf("%s</%s>",tempnode0, type), parent=PAR)
  }
  return(NULL)
}






#' @export
#' @rdname gexf-class
write.gexf <- function(nodes, ...) {
  
  if (!inherits(nodes, "gexf")) {
    gexf(nodes, ...)
    
  } else if (length(list(...)$output)) {
    
    output <- list(...)$output
    
    f <- file(description = output, open="w",encoding='UTF-8')
    write(nodes$graph, file=f)
    close.connection(f)
    message('GEXF graph successfully written at:\n',normalizePath(output))
    return(invisible(nodes))
    
  }
}


