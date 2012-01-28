#rm(list = ls())

#load('C:/Users/George/Documents/Investigacion/Red Publicaciones/2011/ejemplo.RData')
salida <- paste(getwd(),'/printgext.gexf',sep='')
printGexf <- function(
  nodes=letters[1:10],
  links=matrix(c(1:10,10:1), ncol=2),
  linksAtt=1:4,
  nodesAtt=1:4,
  mode='static',
  output = NA
  ) {
  require(XML, quietly = T)
  
  # Defining paramters
  nNodes <- length(nodes)
  nLinks <- length(links)
  nLinksAtt <- ifelse(all(is.na(linksAtt)),NA,NROW(linksAtt))
  nNodesAtt <- ifelse(all(is.na(nodesAtt)),NA,NROW(nodesAtt))
  
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
  
    sapply(nodesAtt,
           function(x) {newXMLNode(name='attribute', parent=xmlAttNodes,attrs=c(
              id=paste('nodeatt',which(nodesAtt %in% x),sep=''),title=x,
              type='string'))
           }
    )
  }

  if (!is.na(nLinksAtt)) {
    xmlAttLinks <- newXMLNode(name='attributes', parent=xmlGraph)
    xmlAttrs(xmlAttLinks) <- c(class='link', mode='static')  
    # links att
    sapply(linksAtt,
           function(x) {newXMLNode(name='attribute', parent=xmlAttLinks,attrs=c(
              id=paste('linkatt',which(linksAtt %in% x),sep=''),title=x,
              type='string'))
           }
    )  
  }
  
  # nodes
  xmlNodes <- newXMLNode(name='nodes', parent=xmlGraph)
  apply(nodes, MARGIN = 1, FUN =
         function(x) {
           x[1] <- as.numeric(x[1])
           x[2] <- as.character(x[2])
           tempnode<-newXMLNode(name='node', parent=xmlNodes, attrs=c(
             id=paste(x[1]), label=paste(x[2])))
           sapply(nodesAtt,
                  function(z) {
                    if (!is.na(nNodesAtt)) {
                      newXMLNode(name='attvalue', attrs=c(
                        'for'=which(nodesAtt %in% z)), parent=tempnode)
                    }
                    }
                    )})

  # links
  xmlEdges <- newXMLNode(name='edges', parent=xmlGraph)
  apply(links, MARGIN = 1, FUN =
         function(x) {
           tempedge<-newXMLNode(name='edge', parent=xmlEdges, attrs=c(
             source=paste(x[1]), target=paste(x[2])))
           sapply(linksAtt,
                  function(z) {
                    if (!is.na(nLinksAtt)) {
                      newXMLNode(name='attvalue', attrs=c(
                        'for'=which(linksAtt %in% z)), parent=tempedge)
                    }
                    }
                    )})
  if (is.na(output)) {
    return(cat(saveXML(xmlFile, encoding='UTF-8')))
  } else {
    output <- file(description=output,encoding='UTF-8')
    cat(saveXML(xmlFile, encoding='UTF-8'),file=output)
    close.connection(output)
  }
}
library(compiler)
printGexf <- cmpfun(printGexf)
#printGexf(linksAtt=NA,nodesAtt=NA,output=salida)
#printGexf()