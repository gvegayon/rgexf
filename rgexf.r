#rm(list = ls())

#load('C:/Users/George/Documents/Investigacion/Red Publicaciones/2011/ejemplo.RData')
salida <- paste(getwd(),'/printgext.gexf',sep='')
people <- matrix(c(1:4, 'juan', 'pedro', 'mathew', 'carlos'),ncol=2)
relations <- matrix(c(1,4,1,2,1,3,2,3,3,4,4,2), ncol=2, byrow=T)



defNodesAtt <- function(x, parent, ...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  sapply(x,
         function(x) {newXMLNode(name='attribute', parent=parent,attrs=c(
           id=paste('nodeatt',which(X %in% x),sep=''),title=x,
           type='string'))
         }
         )
}

defEdgesAtt <- function(...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  sapply(edgesAtt,
         function(x) {newXMLNode(name='attribute', parent=xmlAttLinks,attrs=c(
           id=paste('linkatt',which(edgesAtt %in% x),sep=''),title=x,
           type='string'))
         }
         )
}

addNodes <- function(x, parent, att=NA, life=NA, ...) {
################################################################################
# Prints the nodes att definition
################################################################################
  if (!all(is.na(life))) {x <- cbind(x, life);time=T} else {time=F}

  apply(x, MARGIN = 1, FUN =
    function(x) {
      x[1] <- as.numeric(x[1])
      x[2] <- as.character(x[2])
      tempnode<-newXMLNode(name='node', parent=parent, attrs=c(
        id=paste(x[1]), label=paste(x[2])))
      if (time) {
        if (!is.na(x[3])) {xmlAttrs(tempnode)['start'] <- as.character(x[3])}
        if (!is.na(x[4])) {xmlAttrs(tempnode)['end'] <- as.character(x[4])}
        }
      # Attributes printing
      sapply(att,
             function(z) {
               if (!all(is.na(att))) {
                 newXMLNode(name='attvalue', attrs=c(
                   'for'=which(att %in% z)), parent=tempnode)
               }
             }
             )})
}

addEdges <- function(x, parent, att=NA, life=NA, ...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  apply(x, MARGIN = 1, FUN =
    function(x) {
      tempedge<-newXMLNode(name='edge', parent=parent, attrs=c(
        source=paste(x[1]), target=paste(x[2])))
      sapply(att,
             function(z) {
               if (!all(is.na(att))) {
                 newXMLNode(name='attvalue', attrs=c(
                   'for'=which(att %in% z)), parent=tempedge)
               }
             }
             )})
}

gexf <- function(
################################################################################  
# Prints the gexf file
################################################################################
  nodes=people,
  edges=relations,
  edgesAtt=NA,
  nodesAtt=NA,
  nodeDynamic=NA,
  output = NA
  ) {
  require(XML, quietly = T)
  
  # Defining paramters
  nNodes <- length(nodes)
  nLinks <- length(edges)
  nLinksAtt <- ifelse(all(is.na(edgesAtt)),NA,NROW(edgesAtt))
  nNodesAtt <- ifelse(all(is.na(nodesAtt)),NA,NROW(nodesAtt))
  if (all(is.na(nodeDynamic))) mode <- 'static' else mode <- 'dinamic'
  
  # Starting xml
  xmlFile <- newXMLDoc(addFinalizer=T)
  gexf <- newXMLNode(name='gexf', doc = xmlFile)
  
  # gexf att
  xmlAttrs(gexf)
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
  xmlGraph <- newXMLNode(name='graph', parent=gexf)

  # nodes att
  if (!is.na(nNodesAtt)) {
    xmlAttNodes <- newXMLNode(name='attributes', parent=xmlGraph)
    xmlAttrs(xmlAttNodes) <- c(class='node', mode='static')
    defNodesAtt(nodesAtt, parent)
  }

  # edges att
  if (!is.na(nLinksAtt)) {
    xmlAttLinks <- newXMLNode(name='attributes', parent=xmlGraph)
    xmlAttrs(xmlAttLinks) <- c(class='link', mode='static')  
    defEdgesAtt()
  }
  
  # nodes
  xmlNodes <- newXMLNode(name='nodes', parent=xmlGraph)
  addNodes(nodes, xmlNodes, nodesAtt, nodeDynamic)

  # edges
  xmlEdges <- newXMLNode(name='edges', parent=xmlGraph)
  addEdges(edges, xmlEdges, edgesAtt)
  
  if (is.na(output)) {
    return(cat(saveXML(xmlFile, encoding='UTF-8')))
  } else {
    output <- file(description=output,encoding='UTF-8')
    cat(saveXML(xmlFile, encoding='UTF-8'),file=output)
    close.connection(output)
  }
}
library(compiler)
gexf <- cmpfun(gexf)
#printGexf(edgesAtt=NA,nodesAtt=NA,output=salida)
z<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
gexf(nodeDynamic=z,output=salida)