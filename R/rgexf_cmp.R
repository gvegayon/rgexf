edge.list <- function(x) {
################################################################################
# Translate a edgelist to two objects list (nodes + edges)
################################################################################
  objClass <- class(x)
  nEdges <- NROW(x)
  nCols <- NCOL(x) == 2
  
  if (objClass %in% c("matrix", "data.frame")) {
    
    if (nCols) {
      # If it is not a factor
      if (!is.factor(x)) x <- factor(c(x[,1], x[,2]))
      edges <- matrix(unclass(x), byrow=F, ncol=2)
      nodes <- data.frame(id=1:nlevels(x), label=levels(x), stringsAsFactors=F)
      
      edgelist <- list(nodes=nodes, edges=edges)
      
      return(edgelist)
    }
    else stop("Insuficcient number of columns")
  }
  else stop(paste(objClass, 
                  "class not allowed, try with a \"matrix\" or a \"data.frame\""))
}

.defAtt <- function(x, parent) {
################################################################################
# Prints the nodes and edges att definition
################################################################################
  apply(x, MARGIN=1,
        function(x, PAR) {
          newXMLNode(name="attribute", parent=PAR, attrs=x)
        }, PAR=parent)
}

.addAtts <- function(attnames, tmpatt, attvec, tmpdoc=NULL) {
################################################################################
# Builds app proper XML attrs statement to be parsed by parseXMLAndAdd
################################################################################
  tmpatt <- data.frame(
    "for"=colnames(tmpatt), 
    value=unlist(tmpatt, recursive=FALSE), check.names=FALSE
    )

  for (i in attvec) 
    tmpdoc <- c(tmpdoc, .writeXMLLine("attvalue", tmpatt[i, ]) , sep="") 

  paste(c("<attvalues>", tmpdoc, "</attvalues>"), sep="", collapse="")
}

.writeXMLLine <- function(type, obj, finalizer=TRUE) {
################################################################################
# Builds as character whatever XML line is needed
################################################################################
  paste("<", type, " " ,
        paste(colnames(obj)[!is.na(obj)],obj[!is.na(obj)], sep="=\"", collapse="\" "),
        ifelse(finalizer, "\"/>","\">"), sep="")
}

.addNodesEdges2 <- function(dataset, PAR, type="node", doc) {
################################################################################
# Prints the nodes and edges
################################################################################  
  
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
    if ((viztness <- any(grepl("^viz[.]thickness",vizattnames)))) {
      vizthk.df <- dataset[,grep("^viz[.]thickness[.]", vizattnames, value=TRUE), drop=FALSE]
      colnames(vizthk.df) <- gsub("^viz[.]thickness[.]", "", colnames(vizthk.df))
    }
  }

  # Free memory
  rm(dataset)
  
  # Loop if there are not any attributes
  if (!attributes && !vizattributes) {
    for (i in vec) 
      parseXMLAndAdd(.writeXMLLine(type, datasetnoatt[i,]),parent=PAR)
    NULL
  }
  
  # Loop if only there are attributes
  if (attributes && !vizattributes) {
    
    for (i in vec) {      
      # Adding directly
      parseXMLAndAdd(
        paste(.writeXMLLine(type, datasetnoatt[i,], finalizer=FALSE), 
              .addAtts(attnames, att[i,], attvec), # Builds atts definition
              "</",type,">",sep=""),
        parent=PAR)
    }
    NULL
  }
  
  # Loop if there are attributes and viz attributes
  if (attributes && vizattributes) {
    fns <- c(dummy = FALSE, default = FALSE)
    for (i in vec) {
      # Node/Edge + Atts 
      tempnode0 <- paste(
        .writeXMLLine(type, datasetnoatt[i,]),
        .addAtts(attnames, att[i,], attvec), sep="")
      
      # Viz Att printing
      # Colors
      if (vizcolors) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:color", vizcol.df[i,]),
                           sep="")
      }
      else
      # Position
      if (vizposition) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:position", vizpos.df[i,]),
                           sep="")
      }
      # Size
      if (vizsize) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:size", vizsiz.df[i,1,drop=FALSE]),
                           sep="")
      }
      # Shape
      if (vizshape) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:shape", vizshp.df[i,1,drop=FALSE]),
                           sep="")
      }
      # Image
      if (vizimage) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:shape", vizimg.df[i,]),
                           sep="")
      }
      # Thickness
      if (viztness) {
        tempnode0 <- paste(tempnode0, .writeXMLLine("viz:thickness", vizthk.df[i,1,drop=FALSE]),
                           sep="")
      }
      doc = xmlTreeParse(paste("<p>",tempnode0, "<",type,"/></p>",sep=""), asText = TRUE, 
                     fullNamespaceInfo=FALSE)
      
      invisible(.Call("R_insertXMLNode", xmlChildren(xmlRoot(doc)), 
                      PAR, -1L, FALSE, PACKAGE = "XML"))
      #parseXMLAndAdd(paste(tempnode0, "<",type,"/>",sep=""), parent=PAR)
    }
    NULL
  }
}

write.gexf2 <- function(
  ################################################################################  
  # Prints the gexf file
  ################################################################################
  nodes,
  edges,
  edgesLabel=NULL,
  edgesId=NULL,
  edgesAtt=NULL,
  edgesWeight=NULL,
  edgesVizAtt = list(color=NULL, thickness=NULL, shape=NULL),
  nodesAtt=NULL,
  nodesVizAtt = list(color=NULL, position=NULL, size=NULL, shape=NULL, image=NULL),
  nodeDynamic=NULL,
  edgeDynamic=NULL,
  output = NA,
  tFormat="double",
  defaultedgetype = "undirected",
  meta = list(creator="NodosChile", description="A graph file writing in R using \"rgexf\"",keywords="gexf graph, NodosChile, R, rgexf"),
  keepFactors = TRUE
) {
  
  ##############################################################################
  # CLASS CHECKS AND OTHERS CHECKS
  
  # Nodes
  if (is.data.frame(nodes) | is.matrix(nodes)) {
    if (NCOL(nodes) != 2) stop("\"nodes\" should have two columns not ", NCOL(nodes))
  }
  else stop("Invalid object type: \"nodes\" should be a two column data.frame or a matrix")
  
  # Edges
  if (is.data.frame(edges) | is.matrix(edges)) {
    if (NCOL(edges) != 2) stop("\"edges\" should have two columns not ", NCOL(edges))
  }
  else stop("Invalid object type: \"edges\" should be a two column data.frame or a matrix")
  
  # Edges Label
  if (length(edgesLabel) > 0) {
    if (is.data.frame(edgesLabel) | is.matrix(edgesLabel) | is.vector(edgesLabel)) {
      if (NCOL(edgesLabel) != 1) stop("\"edgesLabel\" should have one column not ", NCOL(edgesLabel))
    }
    else stop("Invalid object type: \"edgesLabel\" should be a one column data.frame or a matrix")
  }
  
  # Edges Id
  if (length(edgesId) > 0) {
    if (is.data.frame(edgesId) | is.matrix(edgesId) | is.vector(edgesId)) {
      if (NCOL(edgesId) != 1) stop("\"edgesId\" should have one column not ", NCOL(edgesId))
    }
    else stop("Invalid object type: \"edgesId\" should be a one column data.frame or a matrix")
  }
  else edgesId <- data.frame(id=0:(NROW(edges) - 1))
  
  # Edges Att
  if ((nEdgesAtt <- length(edgesAtt)) > 0) {
    if (is.data.frame(edgesAtt) | is.matrix(edgesAtt) | is.vector(edgesAtt)) {
      if (NROW(edgesAtt) != NROW(edges)) stop(paste("\"edgesAtt\" should have the same number of rows than edges there are (", NROW(edges),")",sep=""))
    }
    else stop("Invalid object type: \"edgesAtt\" should be a data.frame, a matrix or a vector")
  }
  
  # Edges Weight
  if (length(edgesWeight) > 0) {
    if (is.vector(edgesWeight) | is.data.frame(edgesWeight) | is.matrix(edgesWeight)) {
      if (NROW(edgesWeight) != NROW(edges)) stop("\"edgesWeight\" should have the same number of rows than edges there are (", NROW(edges),")")
      if (NCOL(edgesWeight) > 1) stop("\"edgesWeight should have only one column\"")
    }
    else stop("Invalid object type: \"edgesWeight\" should be a one column data.frame, a matrix or a vector")
  }
  
  # Edges Viz Att
  if (any(lapply(edgesVizAtt, length) > 0)) {
    supportedEdgeVizAtt <- c("color", "thickness", "shape")
    if (all(names(edgesVizAtt) %in% supportedEdgeVizAtt)) {
      if (all(lapply(edgesVizAtt, NROW) == NROW(edges))) {
        nEdgesVizAtt <- length(edgesVizAtt)
      }
      else {
        edgesVizAtt <- lapply(edgesVizAtt, NROW)
        edgesVizAtt <- edgesVizAtt[edgesVizAtt != NROW(edges)]
        stop("Insuficient number of \"edgeVizAtt\" rows: The atts ",
             paste(names(edgesVizAtt), unlist(edgesVizAtt), sep=" (", collapse=" rows), "),")\n",
             "Every att should have the same number of rows than edges there are (",NROW(edges),")")
      }
    }
    else {
      noviz <- names(edgesVizAtt)
      noviz <- noviz[!(noviz %in% supportedEdgeVizAtt)]
      stop("Invalid \"edgesVizAtt\": ",noviz,"\nOnly \"color\", \"thickness\" and \"shape\" are supported")
    }
  }
  else nEdgesVizAtt <- 0
  
  # Nodes Att
  if ((nNodesAtt <- length(nodesAtt)) > 0) {
    if (is.data.frame(nodesAtt) | is.matrix(nodesAtt) | is.vector(nodesAtt)) {
      if (NROW(nodesAtt) != NROW(nodes)) stop("Insuficient number of rows: \"nodesAtt\" (", NROW(nodesAtt)," rows) should have the same number of rows than nodes there are (", NROW(nodes),")")
    }
    else stop("Invalid object type: \"nodesAtt\" should be a data.frame, a matrix or a vector")
  }
  
  # Nodes Viz Att
  if (any(lapply(nodesVizAtt, length) > 0)) {
    supportedNodesVizAtt <- c("color", "position", "size", "shape", "image")
    if (all(names(nodesVizAtt) %in% supportedNodesVizAtt)) {
      if (all(lapply(nodesVizAtt, NROW) == NROW(nodes))) {
        nNodesVizAtt <- length(nodesVizAtt)
      }
      else {
        nodesVizAtt <- lapply(nodesVizAtt, NROW)
        nodesVizAtt <- nodesVizAtt[nodesVizAtt != NROW(nodes)]
        stop("Insuficient number of \"nodeVizAtt\" rows: The atts ",
             paste(names(nodesVizAtt), unlist(nodesVizAtt), sep=" (", collapse=" rows), "),")\n",
             "Every att should have the same number of rows than nodes there are (",NROW(nodes),")")
      }
    }
    else {
      noviz <- names(nodesVizAtt)
      noviz <- noviz[!(noviz %in% supportedNodesVizAtt)]
      stop("Invalid \"nodeVizAtt\": ",noviz,"\nOnly \"color\", \"position\", \"size\", \"shape\" and \"image\" are supported")
    }
  }
  else nNodesVizAtt <- 0
  
  # Dynamics
  dynamic <- c(FALSE, FALSE)
  
  if (length(nodeDynamic) > 0) {
    if (is.data.frame(nodeDynamic) | is.matrix(nodeDynamic)) {
      if (NROW(nodeDynamic) == NROW(nodes)) dynamic[1] <- TRUE
      else stop("Insuficient number of rows: \"nodeDynamic\" (",NROW(nodeDynamic), " rows) should have the same number of rows than nodes there are (", NROW(nodes),")")
    } else stop("Invalid object type: \"nodeDynamic\" should be a two columns data.frame or a matrix")
  }
  
  if (length(edgeDynamic) > 0) {
    if (is.data.frame(edgeDynamic) | is.matrix(edgeDynamic)) {
      if (NROW(edgeDynamic) == NROW(edges)) dynamic[2] <- TRUE
      else stop("Insuficient number of rows: \"edgeDynamic\" (",NROW(edgeDynamic), " rows) should have the same number of rows than edges there are (", NROW(edges),")")
    } else stop("Invalid object type: \"edgeDynamic\" should be a two columns data.frame or a matrix")
  }
  
  ##############################################################################
  # Strings
  old.strAF <- getOption("stringsAsFactors")
  options(stringsAsFactors = FALSE)
  
  if (!any(dynamic)) mode <- "static" else mode <- "dynamic"
  
  # Starting xml
  xmlFile <- newXMLDoc(addFinalizer=TRUE)
  gexf <- newXMLNode(name="gexf", doc = xmlFile)
  
  # gexf att
  
  newXMLNamespace(node=gexf, namespace="http://www.gexf.net/1.2draft")
  newXMLNamespace(
    node=gexf, namespace="http://www.gexf.net/1.1draft/viz", prefix="viz")
  newXMLNamespace(
    node=gexf, namespace="http://www.w3.org/2001/XMLSchema-instance",
    prefix="xsi"
  ) 
  
  xmlAttrs(gexf) <- c( 
    "xsi:schemaLocation" = "http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd",
    version=1.2)
  
  # graph
  xmlMeta <- newXMLNode(name="meta", 
                        attrs=list(lastmodifieddate=as.character(Sys.Date())), 
                        parent=gexf)
  newXMLNode(name="creator", meta$creator, parent=xmlMeta)
  newXMLNode(name="description", meta$description, parent=xmlMeta)
  newXMLNode(name="keywords", meta$keywords, parent=xmlMeta)
  
  xmlGraph <- newXMLNode(name="graph", parent=gexf)
  if (mode == "dynamic") {
    strTime <- min(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=TRUE)
    endTime <- max(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=TRUE)
    xmlAttrs(xmlGraph) <- c(mode=mode, start=strTime, end=endTime,
                            timeformat=tFormat, defaultedgetype=defaultedgetype)
    
    
  } else {
    xmlAttrs(xmlGraph) <- c(mode=mode)
  }
  
  datatypes <- matrix(
    c(
      "string", "character",
      "integer", "integer",
      "float", "double",
      "boolean", "logical"
    ), byrow=TRUE, ncol =2)
  
  # nodes att definitions
  if (nNodesAtt > 0) {
    TIT <- colnames(nodesAtt)
    TYPE <- sapply(nodesAtt, typeof)
    CLASS <- sapply(nodesAtt, class)
    
    # Checks for factors (factor replacing is done later)
    if (keepFactors) TYPE[CLASS == "factor"] <- "integer"
    else TYPE[CLASS == "factor"] <- "string"
    
    nodesAttDf <- data.frame(
      id = paste("att",1:nNodesAtt,sep=""), 
      title = TIT, 
      type = TYPE
    )
    
    # Fixing datatype
    for (i in 1:NROW(datatypes)) {
      nodesAttDf$type <- gsub(datatypes[i,2], datatypes[i,1], nodesAttDf$type)
    }
    
    xmlAttNodes <- newXMLNode(name="attributes", parent=xmlGraph)
    xmlAttrs(xmlAttNodes) <- c(class="node", mode="static")
    .defAtt(nodesAttDf, parent=xmlAttNodes)
    
  } 
  else {
    nodesAttDf <- NULL
  }
  
  # edges att
  if (nEdgesAtt > 0) {
    TIT <- colnames(edgesAtt)
    TYPE <- sapply(edgesAtt, typeof)
    CLASS <- sapply(edgesAtt, class)
    
    # Checks for factors (factor replacing is done later)
    if (keepFactors) TYPE[CLASS == "factor"] <- "integer"
    else TYPE[CLASS == "factor"] <- "string"
    
    edgesAttDf <- data.frame(
      id = paste("att",1:nEdgesAtt,sep=""), 
      title = TIT, 
      type = TYPE
    )
    
    # Fixing datatype
    for (i in 1:NROW(datatypes)) {
      edgesAttDf$type <- gsub(datatypes[i,2], datatypes[i,1], edgesAttDf$type)
    }
    
    xmlAttEdges <- newXMLNode(name="attributes", parent=xmlGraph)
    xmlAttrs(xmlAttEdges) <- c(class="edge", mode="static")
    .defAtt(edgesAttDf, parent=xmlAttEdges)
  } 
  else {
    edgesAttDf <- NULL
  }
  
  # nodes vizatt
  ListNodesVizAtt <- NULL
  if (nNodesVizAtt > 0) {
    tempNodesVizAtt <- names(nodesVizAtt)
    for (i in tempNodesVizAtt) {      
      tmpAtt <- data.frame(nodesVizAtt[[i]])
      
      if (i == "color") colnames(tmpAtt) <- paste("viz.color", c("r","g","b","a"), sep=".")
      else if (i == "position") colnames(tmpAtt) <- paste("viz.position", c("x","y","z"), sep=".")
      else if (i == "size") colnames(tmpAtt) <- "viz.size.value"
      else if (i == "shape") colnames(tmpAtt) <- "viz.shape.value"
      else if (i == "image") {
        tmpAtt <- data.frame(x=rep("image",NROW(nodes)), viz.image.uri=tmpAtt)
        colnames(tmpAtt) <- c("viz.image.value","viz.image.uri")
      }
      if (length(ListNodesVizAtt) == 0) ListNodesVizAtt <- tmpAtt
      else ListNodesVizAtt <- data.frame(ListNodesVizAtt, tmpAtt)
    }
  }
  
  # edges vizatt
  ListEdgesVizAtt <- NULL
  if (nEdgesVizAtt > 0) {
    tempEdgesVizAtt <- names(edgesVizAtt)
    
    for (i in tempEdgesVizAtt) {
      tmpAtt <- data.frame(edgesVizAtt[[i]])
      
      if (i == "color") colnames(tmpAtt) <- paste("viz.color", c("r","g","b","a"), sep=".")
      else if (i == "thickness") colnames(tmpAtt) <- "viz.thickness.value"
      else if (i == "shape") colnames(tmpAtt) <- "value"
      
      if (length(ListEdgesVizAtt) == 0) ListEdgesVizAtt <- tmpAtt
      else ListEdgesVizAtt <- data.frame(ListEdgesVizAtt, tmpAtt)
    }
  }
  
  ##############################################################################
  # The basic char matrix definition  for nodes
  if (dynamic[1]) nodeDynamic <- data.frame(nodeDynamic)
  if (nNodesAtt > 0) nodesAtt <- data.frame(nodesAtt)
  
  for (set in c(nodeDynamic, nodesAtt, ListNodesVizAtt)) {
    try(nodes <- data.frame(nodes, set), silent=TRUE)
  }
  
  # Naming the columns
  attNames <- nodesAttDf["id"]
  if (!is.null(nodeDynamic)) tmeNames <- c("start", "end") else tmeNames <- NULL
  
  colnames(nodes) <- unlist(c("id", "label", tmeNames, attNames, colnames(ListNodesVizAtt)))
  
  # Fixing factors
  if (keepFactors) {
    for (i in colnames(nodes)) {
      if (class(nodes[[i]]) == "factor") nodes[[i]] <- as.numeric(nodes[[i]])
    }
  }
  else {
    for (i in colnames(nodes)) {
      if (class(nodes[[i]]) == "factor") nodes[[i]] <- as.character(nodes[[i]])
    } 
  }
  
  # NODES
  xmlNodes <- newXMLNode(name="nodes", parent=xmlGraph)
  .addNodesEdges2(nodes, xmlNodes, "node")
  
  ##############################################################################
  # The basic dataframe definition  for edges  
  if (dynamic[2]) edgeDynamic <- data.frame(edgeDynamic)
  if (nEdgesAtt > 0) edgesAtt <- data.frame(edgesAtt)
  
  # Adding edge id
  try(edgesId <- cbind(edgesId, edgesLabel), silent=TRUE)
  edges <- cbind(edgesId, edges)
  for (set in c(edgeDynamic, edgesAtt, ListEdgesVizAtt)) {
    try(edges <- data.frame(edges, set), silent=TRUE)
  }
  
  # Naming the columns
  attNames <- edgesAttDf["id"]
  if (!is.null(edgeDynamic)) tmeNames <- c("start", "end") else tmeNames <- NULL
  
  # Generating weights
  if (length(edgesWeight) == 0)  edgesWeight <- 1
  edges <- data.frame(edges, x=edgesWeight)
  
  # Seting colnames
  if (length(edgesLabel) > 0) edgesLabelCName <- "label"
  else edgesLabelCName <- NULL
  colnames(edges) <- unlist(c("id", edgesLabelCName, "source", "target", 
                              tmeNames, attNames, colnames(ListEdgesVizAtt),
                              "weight"))
  
  # EDGES
  xmlEdges <- newXMLNode(name="edges", parent=xmlGraph)
  
  # Fixing factors
  if (keepFactors) {
    for (i in colnames(edges)) {
      if (class(edges[[i]]) == "factor") edges[[i]] <- as.numeric(edges[[i]])
    }
  }
  else {
    for (i in colnames(edges)) {
      if (class(edges[[i]]) == "factor") edges[[i]] <- as.character(edges[[i]])
    } 
  }
  
  .addNodesEdges2(edges, xmlEdges, "edge")
  
  results <- list(
    meta=unlist(meta),
    mode=unlist(c(defaultedgetype=defaultedgetype, mode=mode)),
    node.att = nodesAttDf,
    edge.att = edgesAttDf,
    nodes=data.frame(id=nodes[,"id"], label=nodes[,"label"], row.names=NULL),
    edges=data.frame(source=edges[,"source"],target=edges[,"target"], row.names=NULL),
    graph=saveXML(xmlFile, encoding="UTF-8"))
  class(results) <- "gexf"
  
  # Strings As Factors
  options(stringsAsFactors = old.strAF)
  
  # Returns
  if (is.na(output)) {
    return(results)
  } else {
    print(results, file=output, replace=TRUE)
  }
}


library(XML)

.addAtts <- compiler::cmpfun(.addAtts)
.addNodesEdges2 <- compiler::cmpfun(.addNodesEdges2)
write.gexf2 <- compiler::cmpfun(write.gexf2)
