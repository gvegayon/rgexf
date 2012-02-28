gexf <-
function(
################################################################################  
# Prints the gexf file
################################################################################
  nodes,
  edges,
  edgesAtt=NA,
  nodesAtt=NA,
  nodeDynamic=NA,
  output = NA,
  tFormat='double',
  defaultedgetype = 'undirected'
  ) {
  require(XML, quietly = T)
  
  # Defining paramters
  nNodes <- length(nodes)
  nLinks <- length(edges)
  nLinksAtt <- ifelse(all(is.na(edgesAtt)),NA,NROW(edgesAtt))
  nNodesAtt <- ifelse(all(is.na(nodesAtt)),NA,NROW(nodesAtt))
  if (all(is.na(nodeDynamic))) mode <- 'static' else mode <- 'dynamic'

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
  if (mode == 'dynamic') {
    strTime <- min(nodeDynamic, na.rm=T)
    endTime <- max(nodeDynamic, na.rm=T)
    xmlAttrs(xmlGraph) <- c(mode=mode, start=strTime, end=endTime,
                            timeformat=tFormat, defaultedgetype=defaultedgetype)
    
    
  } else {
    xmlAttrs(xmlGraph) <- c(mode=mode)
  }

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
    results <- saveXML(xmlFile, encoding='UTF-8')
    class(results) <- 'gexf'
    return(results)
  } else {
    output <- file(description=output,encoding='UTF-8')
    cat(saveXML(xmlFile, encoding='UTF-8'),file=output)
    close.connection(output)
    cat('GEXF graph written successfuly\n')
  }
}

