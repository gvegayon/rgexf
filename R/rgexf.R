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

.addNodesEdges <- function(dataset, parent, type="node") {
  ################################################################################
  # Prints the nodes and edges
  ################################################################################  
  
  n <- NROW(dataset)
  vec <- 1:n
  xvars <- colnames(dataset)
  
  noattnames <- xvars[grep("(^att[0-9])|(^viz[.])", xvars, invert=T)]
  attributes <- length(grep("^att", xvars)) > 0
  vizattributes <- length(grep("^viz[.]", xvars)) > 0
  
  vizattnames <- colnames(dataset)[grep("^viz[.]", xvars)]
  vizcolors <- any(grepl("^viz[.]color",vizattnames))
  vizposition <- any(grepl("^viz[.]position",vizattnames))
  vizsize <- any(grepl("^viz[.]size",vizattnames))
  vizshape <- any(grepl("^viz[.]shape",vizattnames))
  vizimage <- any(grepl("^viz[.]image",vizattnames))
  vizthickness <- any(grepl("^viz[.]thickness",vizattnames))
  
  # Parsing user-define attributes
  if (attributes) attnames <- colnames(dataset)[grep("^att", xvars)]
  else attnames <- NULL
  
  # Parsing VIZ attributes
  if (vizattributes) vizattnames <- colnames(dataset)[grep("^viz[.]", xvars)]
  else vizattnames <- NULL
  
  lapply(vec, 
         function(x, PAR, type) {
           
           x <- subset(dataset, vec == x)
           
           if (length(attnames) > 0) att <- x[,attnames, drop=F]
           if (length(vizattnames) > 0) vizatt <- x[,vizattnames, drop=F]
           
           tempnode0 <- newXMLNode(name=type, parent=PAR, 
                                   attrs=x[,noattnames, drop=F][,!is.na(x[noattnames]), drop=F])
           
           # Attributes printing        
           if (attributes) {
             tempDF <- data.frame(names(att), t(att))
             
             colnames(tempDF) <- c("for","value")
             
             tempnode2 <- newXMLNode("attvalues", parent=tempnode0)
             
             for (i in 1:NROW(tempDF)) {
               newXMLNode(name="attvalue", parent=tempnode2, attrs=tempDF[i,])
             }
           }
           
           # Viz Att printing
           if (vizattributes) {
             fns <- c(dummy = FALSE, default = FALSE)
             
             # Colors
             if (vizcolors) {
               tempvizatt <- vizatt[,grep("^viz[.]color[.]", vizattnames)]
               names(tempvizatt) <- gsub("^viz[.]color[.]", "", names(tempvizatt))
               tempnode1 <- newXMLNode("viz:color", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
             # Position
             if (vizposition) {
               tempvizatt <- vizatt[,grep("^viz[.]position[.]", vizattnames), drop=F]
               colnames(tempvizatt) <- gsub("^viz[.]position[.]", "", colnames(tempvizatt))
               tempnode1 <- newXMLNode("viz:position", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
             # Size
             if (vizsize) {
               tempvizatt <- vizatt[,grep("^viz[.]size[.]", vizattnames), drop=F]
               colnames(tempvizatt) <- gsub("^viz[.]size[.]", "", colnames(tempvizatt))
               tempnode1 <- newXMLNode("viz:size", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
             # Shape
             if (vizshape) {
               tempvizatt <- vizatt[,grep("^viz[.]shape[.]", vizattnames), drop=F]
               colnames(tempvizatt) <- gsub("^viz[.]shape[.]", "", colnames(tempvizatt))
               tempnode1 <- newXMLNode("viz:shape", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
             # Image
             if (vizimage) {
               tempvizatt <- vizatt[,grep("^viz[.]image[.]", vizattnames), drop=F]
               colnames(tempvizatt) <- c("value", "uri")
               tempnode1 <- newXMLNode("viz:shape", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
             # Thickness
             if (vizthickness) {
               tempvizatt <- vizatt[,grep("^viz[.]thickness[.]", vizattnames), drop=F]
               colnames(tempvizatt) <- gsub("^viz[.]thickness[.]", "", colnames(tempvizatt))
               tempnode1 <- newXMLNode("viz:thickness", parent=tempnode0, attrs=tempvizatt,
                                       fixNamespaces = fns)
             }
           }
         }, PAR=parent, type=type)
}

write.gexf <- function(
################################################################################  
# Prints the gexf file
################################################################################
  nodes,
  edges,
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
    if (NCOL(nodes) != 2) stop(paste("\"nodes\" should have two columns not", NCOL(nodes)))
  }
  else stop("Invalid object type: \"nodes\" should be a two column data.frame or a matrix")
  
  # Edges
  if (is.data.frame(edges) | is.matrix(edges)) {
    if (NCOL(edges) != 2) stop(paste("edges should have two columns not", NCOL(edges)))
  }
  else stop("Invalid object type: \"edges\" should be a two column data.frame or a matrix")
  
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
  xmlFile <- newXMLDoc(addFinalizer=T)
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
    strTime <- min(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=T)
    endTime <- max(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=T)
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
      ), byrow=T, ncol =2)
  
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
    try(nodes <- data.frame(nodes, set), silent=T)
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
  .addNodesEdges(nodes, xmlNodes, "node")

  ##############################################################################
  # The basic dataframe definition  for edges  
  if (dynamic[2]) edgeDynamic <- data.frame(edgeDynamic)
  if (nEdgesAtt > 0) edgesAtt <- data.frame(edgesAtt)
    
  for (set in c(edgeDynamic, edgesAtt, ListEdgesVizAtt)) {
    try(edges <- data.frame(edges, set), silent=T)
  }
    
  # Naming the columns
  attNames <- edgesAttDf["id"]
  if (!is.null(edgeDynamic)) tmeNames <- c("start", "end") else tmeNames <- NULL
  
  # Generating weights
  if (length(edgesWeight) == 0)  edgesWeight <- 1
  edges <- data.frame(edges, x=edgesWeight)
  
  # Seting colnames
  colnames(edges) <- unlist(c("source", "target", tmeNames, attNames, 
                              colnames(ListEdgesVizAtt),"weight"))

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
  
  .addNodesEdges(edges, xmlEdges, "edge")
  
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
    print(results, file=output, replace=T)
  }
}
