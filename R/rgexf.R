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
          newXMLNode(name='attribute', parent=PAR, attrs=x)
        }, PAR=parent)
}

.addNodesEdges <- function(data, parent, type='node') {
################################################################################
# Prints the nodes and edges
################################################################################  

  x <- 1:NROW(data)
  xvars <- colnames(data)

  noattnames <- xvars[grep('^(att[0-9])|(viz[.])', xvars, invert=T)]
  attributes <- length(grep('^att', xvars)) > 0
  vizattributes <- length(grep('^viz[.]', xvars)) > 0

  vizattnames <- colnames(data[,grep('^viz[.]', xvars)])
  vizcolors <- any(grepl("^viz[.]color",vizattnames))
  vizposition <- any(grepl("^viz[.]position",vizattnames))
  vizsize <- any(grepl("^viz[.]size",vizattnames))
  vizshape <- any(grepl("^viz[.]shape",vizattnames))
  vizimage <- any(grepl("^viz[.]image",vizattnames))
  vizthickness <- any(grepl("^viz[.]thickness",vizattnames))

  lapply(X=x, 
        function(X, PAR, type) {
          x <- data[X,]
          x <- data.frame(t(x), stringsAsFactors=F)
          
          # Parsing user-define attributes
          if (attributes) {
            att <- x[,grep('^att', xvars), drop=F]
            attnames <- names(att)
          }
          else attnames <- ""
          
          # Parsing VIZ attributes
          if (vizattributes) {
            vizatt <- x[,grep('^viz[.]', xvars), drop=F]
            vizattnames <- names(vizatt)
          }
          else vizattnames <- ""
          
          tempnode0 <- newXMLNode(name=type, parent=PAR)
          
          # Adds every attribute removing leading and ending spaces
          for (i in noattnames) {
            if (!is.na((tempatt <- x[,c(i)]))) xmlAttrs(tempnode0)[i] <-
              tempatt # gsub("[\t ]*$", "", gsub("^[\t ]*", "", 
          }
          
          # Viz Att printing
          if (vizattributes) {
            # Colors
            if (vizcolors) {
              tempvizatt <- vizatt[grep("^viz[.]color[.]", vizattnames)]
              colnames(tempvizatt) <- gsub("^viz[.]color[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:color", parent=tempnode0, attrs=tempvizatt)
            }
            # Position
            if (vizposition) {
              tempvizatt <- vizatt[grep("^viz[.]position[.]", vizattnames)]
              colnames(tempvizatt) <- gsub("^viz[.]position[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:position", parent=tempnode0, attrs=tempvizatt)
            }
            # Size
            if (vizsize) {
              tempvizatt <- vizatt[grep("^viz[.]size[.]", vizattnames)]
              colnames(tempvizatt) <- gsub("^viz[.]size[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:size", parent=tempnode0, attrs=tempvizatt)
            }
            # Shape
            if (vizshape) {
              tempvizatt <- vizatt[grep("^viz[.]shape[.]", vizattnames)]
              colnames(tempvizatt) <- gsub("^viz[.]shape[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:shape", parent=tempnode0, attrs=tempvizatt)
            }
            # Image
            if (vizimage) {
              tempvizatt <- vizatt[grep("^viz[.]image[.]", vizattnames)]
              colnames(tempvizatt) <- c("viz.image.value", "viz.image.uri")
              colnames(tempvizatt) <- gsub("^viz[.]image[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:shape", parent=tempnode0, attrs=tempvizatt)
            }
            # Thickness
            if (vizthickness) {
              tempvizatt <- vizatt[grep("^viz[.]thickness[.]", vizattnames)]
              colnames(tempvizatt) <- gsub("^viz[.]thickness[.]", "", colnames(tempvizatt))
              tempnode1 <- newXMLNode("viz:thickness", parent=tempnode0, attrs=tempvizatt)
            }
          }
          
          # Attributes printing        
          if (attributes) {      
            tempDF <- data.frame(names(att), value=t(att), stringsAsFactors=F)

            colnames(tempDF) <- c('for', 'value')
            
            tempnode2 <- newXMLNode('attvalues', parent=tempnode0)
            
            for (i in 1:NROW(tempDF)) {
              newXMLNode(name='attvalue', parent=tempnode2, attrs=tempDF[i,])
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
  meta = list(creator="NodosChile", description="A graph file writing in R using \'rgexf\'",keywords="gexf graph, NodosChile, R, rgexf")
  ) {
  require(XML, quietly = T)
  
  # Defining paramters
  nEdgesAtt <- ifelse(length(edgesAtt) > 0, NCOL(edgesAtt), 0)
  nNodesAtt <- ifelse(length(nodesAtt) > 0, NCOL(nodesAtt), 0)
  dynamic <- c(length(nodeDynamic) > 0 , length(edgeDynamic) > 0)  
  
  # ID vizatt
  nNodesVizAtt <- unlist(lapply(nodesVizAtt, is.null))
  nEdgesVizAtt <- unlist(lapply(edgesVizAtt, is.null))
  
  nodesVizAtt <- nodesVizAtt[!nNodesVizAtt]
  edgesVizAtt <- edgesVizAtt[!nEdgesVizAtt]
  
  nNodesVizAtt <- ifelse(sum(nNodesVizAtt==F), length(nodesVizAtt), 0)
  nEdgesVizAtt <- ifelse(sum(nEdgesVizAtt==F), length(edgesVizAtt), 0)
  
  if (!any(dynamic)) mode <- 'static' else mode <- 'dynamic'

  # Starting xml
  xmlFile <- newXMLDoc(addFinalizer=T)
  gexf <- newXMLNode(name='gexf', doc = xmlFile)
  
  # gexf att

  newXMLNamespace(node=gexf, namespace='http://www.gexf.net/1.2draft')
  newXMLNamespace(
    node=gexf, namespace='http://www.gexf.net/1.1draft/viz', prefix='viz')
  newXMLNamespace(
    node=gexf, namespace='http://www.w3.org/2001/XMLSchema-instance',
    prefix='xsi'
  ) 
  
  xmlAttrs(gexf) <- c( 
    'xsi:schemaLocation' = 'http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd',
    version=1.2)
  
  # graph
  xmlMeta <- newXMLNode(name='meta', 
                        attrs=list(lastmodifieddate=as.character(Sys.Date())), 
                        parent=gexf)
  newXMLNode(name='creator', meta$creator, parent=xmlMeta)
  newXMLNode(name='description', meta$description, parent=xmlMeta)
  newXMLNode(name='keywords', meta$keywords, parent=xmlMeta)
  
  xmlGraph <- newXMLNode(name='graph', parent=gexf)
  if (mode == 'dynamic') {
    strTime <- min(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=T)
    endTime <- max(c(unlist(nodeDynamic), unlist(edgeDynamic)), na.rm=T)
    xmlAttrs(xmlGraph) <- c(mode=mode, start=strTime, end=endTime,
                            timeformat=tFormat, defaultedgetype=defaultedgetype)
    
    
  } else {
    xmlAttrs(xmlGraph) <- c(mode=mode)
  }

  datatypes <- matrix(
    c(
      'string', 'character',
      'integer', 'integer',
      'float', 'double',
      'boolean', 'logical'
      ), byrow=T, ncol =2)
  
  # nodes att definitions
  if (nNodesAtt > 0) {
    TIT <- colnames(nodesAtt)
    TYPE <- unlist(lapply(nodesAtt, typeof))
    
    nodesAttDf <- data.frame(
      id = paste('att',1:nNodesAtt,sep=''), title = TIT, type = TYPE,
      stringsAsFactors=F
    )
  
    # Fixing datatype
    for (i in 1:NROW(datatypes)) {
      nodesAttDf$type <- gsub(datatypes[i,2], datatypes[i,1], nodesAttDf$type)
    }
    
    xmlAttNodes <- newXMLNode(name='attributes', parent=xmlGraph)
    xmlAttrs(xmlAttNodes) <- c(class='node', mode='static')
    .defAtt(nodesAttDf, parent=xmlAttNodes)
    
  } 
  else {
    nodesAttDf <- NULL
  }

  # edges att
  if (nEdgesAtt > 0) {
    TIT <- colnames(edgesAtt)
    TYPE <- sapply(edgesAtt, typeof)
    
    edgesAttDf <- data.frame(
      id = paste('att',1:nEdgesAtt,sep=''), title = TIT, type = TYPE,
      stringsAsFactors=F
      )
    
    # Fixing datatype
    for (i in 1:NROW(datatypes)) {
      edgesAttDf$type <- gsub(datatypes[i,2], datatypes[i,1], edgesAttDf$type)
    }
    
    xmlAttEdges <- newXMLNode(name='attributes', parent=xmlGraph)
    xmlAttrs(xmlAttEdges) <- c(class='edge', mode='static')
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
      assign(paste("nodes",i,sep=""), as.matrix(nodesVizAtt[[c(i)]]))
      
      if (i == "colors") colnames(nodescolors) <- 
        paste("viz.color", c("r","g","b","a"), sep=".")
      else if (i == "position") colnames(nodesposition) <- 
        paste("viz.position", c("x","y","z"), sep=".")
      else if (i == "size") colnames(nodessize) <- "viz.size.value"
      else if (i == "shape") colnames(nodesshape) <- "viz.shape.value"
      else if (i == "image") {
        nodesimage <- cbind(rep("image",NROW(nodes)), viz.image.uri=nodesimage)
        colnames(nodesimage) <- c("viz.image.value","viz.image.uri")
      }
      
      ListNodesVizAtt <- cbind(ListNodesVizAtt, get(paste("nodes",i,sep="")))
    }
  }
  
  # edges vizatt
  ListEdgesVizAtt <- NULL
  if (nEdgesVizAtt > 0) {
    tempEdgesVizAtt <- names(edgesVizAtt)
    
    for (i in tempEdgesVizAtt) {
      assign(paste("edges",i,sep=""), as.matrix(edgesVizAtt[[c(i)]]))
      
      if (i == "colors") colnames(edgescolors) <- 
        paste("viz.color", c("r","g","b","a"), sep=".")
      else if (i == "thickness") colnames(edgesthickness) <- 
        paste("viz.thickness", c("value"), sep=".")
      else if (i == "shape") colnames(edgesshape) <- "value"
      
      ListEdgesVizAtt <- cbind(ListEdgesVizAtt, get(paste("edges",i,sep="")))
    }
  }
  
  ##############################################################################
  # The basic char matrix definition  for nodes
  nodes <- as.matrix(nodes)
  
  if (dynamic[1]) nodeDynamic <- data.frame(nodeDynamic, stringsAsFactors=F)
  if (nNodesAtt > 0) nodesAtt <- data.frame(nodesAtt, stringsAsFactors=F)
  
  for (set in c(nodeDynamic, nodesAtt, ListNodesVizAtt)) {
    try(nodes <- cbind(nodes, set), silent=T)
  }

  # Naming the columns
  attNames <- nodesAttDf['id']
  if (!is.null(nodeDynamic)) tmeNames <- c('start', 'end') else tmeNames <- NULL
  
  colnames(nodes) <- unlist(c('id', 'label', tmeNames, attNames, colnames(ListNodesVizAtt)))
  
  # NODES
  xmlNodes <- newXMLNode(name='nodes', parent=xmlGraph)
  .addNodesEdges(nodes, xmlNodes, 'node')

  ##############################################################################
  # The basic dataframe definition  for edges
  edges <- as.matrix(edges)
  
  if (dynamic[2]) edgeDynamic <- data.frame(edgeDynamic, stringsAsFactors=F)
  if (nEdgesAtt > 0) edgesAtt <- data.frame(edgesAtt, stringsAsFactors=F)
    
  for (set in c(edgeDynamic, edgesAtt, ListEdgesVizAtt)) {
    try(edges <- cbind(edges, set), silent=T)
  }
    
  # Naming the columns
  attNames <- edgesAttDf['id']
  if (!is.null(edgeDynamic)) tmeNames <- c('start', 'end') else tmeNames <- NULL
  
  # Generating weights
  if (all(is.null(edgesWeight))) {
    pastededges <- apply(edges[,c(2,1)], 1, paste, collapse="")
    for (i in 1:NROW(edges)) {
       edgesWeight <- c(
         edgesWeight, 
         sum(paste(edges[i,1:2], collapse="") %in% pastededges))
    }
    #edgesWeight <- 0
  }
  else edgesWeight <- 0
  edges <- cbind(edges, edgesWeight+1)
  
  # Seting colnames
  colnames(edges) <- unlist(c("source", "target", tmeNames, attNames, colnames(ListEdgesVizAtt),"weight"))

  # EDGES
  xmlEdges <- newXMLNode(name='edges', parent=xmlGraph)
  .addNodesEdges(edges, xmlEdges, 'edge')
  
  results <- list(
    meta=unlist(meta),
    mode=unlist(c(defaultedgetype=defaultedgetype, mode=mode)),
    node.att = nodesAttDf,
    edge.att = edgesAttDf,
    nodes=data.frame(id=nodes[,"id"], label=nodes[,"label"], stringsAsFactors=F
                     , row.names=NULL),
    edges=data.frame(source=edges[,"source"],target=edges[,"target"], stringsAsFactors=F
                     , row.names=NULL),
    graph=saveXML(xmlFile, encoding='UTF-8'))
  class(results) <- "gexf"
  
  if (is.na(output)) {
    return(results)
  } else {
    print(results, file=output, replace=T)
  }
}
