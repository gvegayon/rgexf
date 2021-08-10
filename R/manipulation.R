#' Adding and removing nodes/edges from `gexf` objects
#' 
#' Manipulates `gexf` objects adding and removing nodes and edges from
#' both, its dataframe representation and its XML representation.
#' 
#' `new.gexf.graph` Creates a new `gexf` empty object (0 nodes 0
#' edges).
#' 
#' `add.gexf.node` and `add.gexf.edge` allow adding nodes and edges
#' to a `gexf` object (graph) one at a time. `rm.gexf.node` and
#' `rm.gexf.edges` remove nodes and edges respectively.
#' 
#' In the case of `rm.gexf.node`, by default every edge linked to the node
#' that is been removed will also be removed (`rm.edges = TRUE`).
#' 
#' @aliases add.gexf.node add.gexf.edge rm.gexf.node rm.gexf.edge
#' add.node.spell add.edge.spell
#' @param graph A gexf-class object.
#' @param id A node/edge id (normally numeric value).
#' @param label A node/edge label.
#' @param type Type of connection (edge).
#' @param number Index number(s) of a single or a group of nodes or edges.
#' @param weight Edge weight.
#' @param vizAtt A list of node/edge viz attributes (see
#' [write.gexf()]).
#' @param atts List of attributes, currently ignored.
#' @param source Source node's id.
#' @param target Target node's id.
#' @param start Starting time period
#' @param end Ending time period
#' @param rm.edges Whether to remove or not existing edges.
#' @param digits Integer. Number of decimals to keep for nodes/edges sizes. See
#' [print.default()]
#' @return A `gexf` object (see [write.gexf()]).
#' @author George Vega Yon 
#' 
#' Jorge Fabrega Lacoa 
#' @references The GEXF project website: http://gexf.net
#' @keywords manip
#' @examples
#'
#' if (interactive()) {
#'   demo(gexfbuildfromscratch)
#' }
#' 
#' @export add.gexf.node
add.gexf.node <- function(
  graph, 
  id     = NA, 
  label  = NA, 
  start  = NULL, 
  end    = NULL,
  vizAtt = list(
    color    = NULL,
    position = NULL,
    size     = NULL,
    shape    = NULL,
    image    = NULL
  ),
  atts   = NULL
  ) 
  {

  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.")

  # Parses the graph file
  graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
  
  # Gets the number of nodes
  n <- length(graph$graph$doc$children$gexf[["graph"]][["nodes"]])
  
  node <- XML::xmlNode("node", attrs=c(id=id, label=label, start=start, end=end))
  
  # Adds the atts
#   if (length(atts)) {
#     atts.node <- xmlNode("attvalues")
#     for (i in 1:length(atts)) {
#       atts.node <- 
#         addChildren(
#           atts.node, 
#           xmlNode("attvalue", attrs=c("for"=names(atts)[i], value=atts[[i]])))
#       
#       # Checking atts definition
#       if (!length(graph$atts.definitions$node)) {
#         graph$atts.definitions$node <-
#           data.frame(
#             id=names(atts)[i], 
#             title=atts[[i]], 
#             type=.parseDataTypes(atts[[i]])
#             )
#         )
# 
#         # Adding the atts XML definitions
#         tmpattnode <- xmlNode("attributes". attrs=c(class="node", mode="static"))
#         tmpattnode <- 
#           addChildren(tmpattnode, 
#                       xmlNode("attribute",attrs=c("for"=names(atts)[i], value=atts[[i]])))
#         
#         graph$graph$doc$children$gexf[["graph"]] <- tmpattnode
#       }
#       else if (!length(subset(graph$atts.definitions$node, id==names(atts)[i]))) {
#         graph$atts.definitions$node <-
#           rbind(graph$atts.definitions$node,
#           data.frame(
#             id=names(atts)[i],
#             title=atts[[i]],
#             type=.parseDataTypes(atts[[i]])
#             )
#           )
#       }
#     }
#     
#     # Adding new node
#     node <- addChildren(node, atts.node)
#   }
  
  # Adds the viz atts
  if (length(unlist(vizAtt)) > 0) {
    if (length(vizAtt$color) > 0) {
      colnames(vizAtt$color) <- c("r","g","b","a")
      node <- XML::addChildren(node, XML::xmlNode("viz:color", attrs=vizAtt$color))
    }
    if (length(vizAtt$position) > 0) {
      colnames(vizAtt$position) <- c("x","y","z")
      node <- XML::addChildren(node, XML::xmlNode("viz:position", attrs=vizAtt$position))
    }
    if (length(vizAtt$size) > 0) {
      node <- XML::addChildren(node, XML::xmlNode("viz:size", attrs=list(value=vizAtt$size)))
    }
    if (length(vizAtt$image) > 0) node <- XML::addChildren(node, XML::xmlNode("viz:image", attrs=vizAtt$image))
  }
  
  graph$graph$doc$children$gexf[["graph"]][["nodes"]][[n+1]] <- XML::asXMLNode(x=node)
  
  # Adding to data.frame
  tmpdf <- data.frame(id=id, label=label,stringsAsFactors=F)
  for (i in colnames(graph$nodes)) {
    if (!all(i %in% c("id","label"))) {
      tmpdf <- cbind(tmpdf, NA)
      colnames(tmpdf)[length(tmpdf)] <- i
    }
  }
  graph$nodes <- rbind(graph$nodes, tmpdf)
  
  # Saves and returns as char XML
  graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}

#' @export
#' @rdname add.gexf.node
add.gexf.edge <- function(
  graph, 
  source, 
  target,  
  id     = NULL,
  type   = NULL,
  label  = NULL,
  start  = NULL,
  end    = NULL,
  weight = 1, 
  vizAtt = list(color=NULL, thickness=NULL, shape=NULL),
  atts   = NULL,
  digits = getOption("digits")
) {
  
  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.")

  # Parses the graph file
  graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
  
  # Gets the number of edges
  n <- length(graph$graph$doc$children$gexf[["graph"]][["edges"]])
  
  if (length(id) == 0) id <- n + 1
  
  # Checking the number of digits
  if (!is.integer(digits)) stop("Invalid number of digits ",digits,
                                ".\n Must be a number between 0 and 22")
  fmt <- sprintf("%%.%gg", digits)
  
  edge <- XML::xmlNode("edge", attrs=c(id=id, type=type, label=label, source=source, 
                                  target=target, start=start, end=end, 
                                  weight=sprintf(fmt,weight)))
  # Adds the atts
#   if (length(atts)) {
#     atts.edge <- xmlNode("attvalues")
#     for (i in 1:length(atts)) {
#       atts.edge <- 
#         addChildren(
#           atts.edge, 
#           xmlNode("attvalue", attrs=c("for"=names(atts)[i], value=atts[[i]])))
#     }
#     edge <- addChildren(edge, atts.edge)
#   }
  
  # Adds the viz atts
  if (length(unlist(vizAtt)) > 0) {
    if (length(vizAtt$color) > 0) {
      edge <- XML::addChildren(edge, XML::xmlNode("viz:color", attrs=vizAtt$color))
    }
    if (length(vizAtt$thickness) > 0) {
      edge <- XML::addChildren(edge, XML::xmlNode("viz:thickness", attrs=vizAtt$position))
    }
    if (length(vizAtt$shape) > 0) {
      edge <- XML::addChildren(edge, XML::xmlNode("viz:shape", attrs=vizAtt$size))
    }
  }
  
  # Adds the new edge
  graph$graph$doc$children$gexf[["graph"]][["edges"]][[n+1]] <- XML::asXMLNode(x=edge)
  
  if (length(label) == 0) label <- id
  
  # Adding to data.frame
  tmpdf <- data.frame(id=id, source=source, target=target, weight=weight,
                      stringsAsFactors=F)
  for (i in colnames(graph$edges)) {
    if (!all(i %in% c("id","source","target","weight"))) {
      tmpdf <- cbind(tmpdf, NA)
      colnames(tmpdf)[length(tmpdf)] <- i
    }
  }
  graph$edges <- rbind(graph$edges, tmpdf)
  
  # Saves and returns as char XML
  graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}



#' Build an empty `gexf` graph
#' 
#' Builds an empty `gexf` object containing all the class's attributes.
#' 
#' 
#' @param defaultedgetype \dQuote{directed}, \dQuote{undirected},
#' \dQuote{mutual}
#' @param meta A List. Meta data describing the graph
#' @return A `gexf` object.
#' @author George Vega Yon 
#' 
#' Jorge Fabrega Lacoa 
#' @references The GEXF project website: http://gexf.net
#' @keywords manip
#' @examples
#' 
#' if (interactive()) {
#'   demo(gexfbuildfromscratch)
#' }
#' 
#' @export new.gexf.graph
new.gexf.graph <- function(
  defaultedgetype = "undirected",
  meta = list(creator="NodosChile", description="A graph file writing in R using \'rgexf\'",
              keywords="gexf graph, NodosChile, R, rgexf")
  ) {
  
  # Building doc
  xmlFile <- XML::newXMLDoc(addFinalizer=T)
  gexf <- XML::newXMLNode(name='gexf', doc = xmlFile)
  
  # Adding gexf attributes
  XML::newXMLNamespace(node=gexf, namespace='http://www.gexf.net/1.2draft')
  XML::newXMLNamespace(
    node=gexf, namespace='http://www.gexf.net/1.1draft/viz', prefix='viz')
  XML::newXMLNamespace(
    node=gexf, namespace='http://www.w3.org/2001/XMLSchema-instance',
    prefix='xsi'
  ) 
  
  XML::xmlAttrs(gexf) <- c( 
    'xsi:schemaLocation' = 'http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd',
    version=1.2)
  
  # graph
  xmlMeta <- XML::newXMLNode(name="meta", 
                        attrs=list(lastmodifieddate=as.character(Sys.Date())), 
                        parent=gexf)
  XML::newXMLNode(name='creator', meta$creator, parent=xmlMeta)
  XML::newXMLNode(name='description', meta$description, parent=xmlMeta)
  XML::newXMLNode(name='keywords', meta$keywords, parent=xmlMeta)
  
  xmlGraph <- XML::newXMLNode(name="graph", parent=gexf)
  
  mode <- "static"
  XML::xmlAttrs(xmlGraph) <- c(mode=mode)
  
  # Nodes
  XML::newXMLNode(name='nodes', parent=xmlGraph)
  
  # Edges
  XML::newXMLNode(name='edges', parent=xmlGraph)
  
  # Return  
  
  build.and.validate.gexf(
    meta        = meta,
    mode        = list(
      defaultedgetype = defaultedgetype,
      mode            = mode
      ),
    atts.definitions = list(
      nodes = NULL,
      edges = NULL
      ),
    nodesVizAtt = NULL,
    edgesVizAtt = NULL,
    nodes = data.frame(
      id        = NULL,
      label     = NULL, 
      row.names = NULL)
    ,
    edges = data.frame(
      id        = NULL,
      source    = NULL,
      target    = NULL,
      weight    = NULL,
      row.names = NULL
      ),
    graph       = XML::saveXML(xmlFile, encoding="UTF-8")
    )
    
}

#' @export
#' @rdname add.gexf.node
rm.gexf.node <- function(
  graph,
  id       = NULL,
  number   = NULL,
  rm.edges = TRUE
  ) {

  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.") 
 
  # Checking the node to delete
  if (length(number)==0) {
    if (length(id)==0) stop("No nodes specified.")
    else {
      number <- which(graph$nodes$id == id)
    }
    if (length(number) == 0) stop("No such node.")
  }
  else {
    id <- graph$nodes$id[number]
  }
  
  # Gets the number of nodes
  
  if (NROW(graph$nodes) > 0) {
    # Parses the graph file
    graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
  
    # Removes nodes from XML
    #node$children = unclass(node)$children[-w]
    graph$graph$doc$children$gexf[["graph"]][["nodes"]]$children <- 
      unclass(graph$graph$doc$children$gexf[["graph"]][["nodes"]])$children[-number]
    
    # If removing edges is true
    if (rm.edges) {
      if (length(graph$graph$doc$children$gexf[["graph"]][["edges"]]) > 0) {
        edges.to.rm <- which(graph$edges$source == id | graph$edges$target == id)

        if (length(edges.to.rm) > 0) {          
          # Removing from xml
          for (i in edges.to.rm) {
            graph$graph$doc$children$gexf[["graph"]][["edges"]]$children <- 
              unclass(graph$graph$doc$children$gexf[["graph"]][["edges"]])$children[-i]
          }
          
          # Removing from data frame
          graph$edges <- graph$edges[-edges.to.rm,]
        }
        else {
          warning("No edges to remove found.")
        }
      }
      else {
        warning("No edges to be removed.")
      }
    }
    graph$nodes <- graph$nodes[-number,]
    
    # Saves and returns as char XML
    graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
    return(graph)
  }
  else {
    stop("No nodes to be removed.")
  }
}

#' @export
#' @rdname add.gexf.node
rm.gexf.edge <- function(
  graph, 
  id     = NULL, 
  number = NULL
  ) {

  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.") 

  # Checking the edge to add to
  if (length(number)==0) {
    if (length(id)==0) stop("No edges specified.")
    else {
      number <- which(graph$edges$id == id)
    }
    if (length(number) == 0) stop("No such edge.")
  }
  
  # Checking the node to delete
  if (length(number) == 0)  stop("No edge especified.")
  
  # Gets the number of edges
  if (NROW(graph$edges) > 0) {
    
    # Parses the graph file
    graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
    
    graph$graph$doc$children$gexf[["graph"]][["edges"]]$children <- 
      unclass(graph$graph$doc$children$gexf[["graph"]][["edges"]])$children[-number]
    
    graph$edges <- graph$edges[-number,]
    
    # Saves and returns as char XML
    graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
    return(graph)
  }
  else {
    stop("No edges to be removed.")
  }
}

#' @export
#' @rdname add.gexf.node
#' @section Spells:
#' While the `start` and `end` attributes can be included in nodes and edges,
#' spells provide a way to represent presence and absence of elements throughout
#' time.
#' 
#' We can use spells to indicate windows during which the element is present
#' or not. For example, a node that shows up from time 1 to time two and
#' re-appears after time four can have two spells:
#' 
#' ```
#' <spell start="1.0" end="2.0">
#' <spell start="4.0">
#' ```
#' 
#' In the case of the functions `add.edge.spell` and `add.node.spell`, edges and
#' nodes to which you want to add spells should already exist.
#' 
#' @examples 
#' # Creating spells ------------------------------------------------------
#' g <- new.gexf.graph()
#' 
#' # Adding a few nodes + edges
#' g <- add.gexf.node(g, id = 0, label = "A")
#' g <- add.gexf.node(g, id = 1, label = "B")
#' g <- add.gexf.node(g, id = 2, label = "C")
#' 
#' g <- add.gexf.edge(g, source = 0, target = 1)
#' g <- add.gexf.edge(g, source = 0, target = 2)
#' 
#' # Now we add spells:
#' # - Node 0: 1.0 -> 2.0, 3.0 -> Inf
#' # - edge 1: 1.0 -> 2.0, 3.5 -> Inf
#' g <- add.node.spell(g, 0, start = 1, end = 2)
#' g <- add.node.spell(g, 0, start = 3)
#' 
#' g <- add.edge.spell(g, 1, start = 1, end = 2)
#' g <- add.edge.spell(g, 1, start = 3.5)
#' 
#' g
#' 
add.node.spell <- function(
  graph, 
  id     = NULL,
  number = NULL,
  start  = NULL, 
  end    = NULL,
  digits = getOption("digits")
  ) {
 
  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.")

  # Checking the node to add to
  if (length(number)==0) {
    if (length(id)==0) stop("No nodes specified.")
    else {
      number <- which(graph$nodes$id == id)
    }
    if (length(number) == 0) stop("No such node.")
  }
  
  # Parses the graph file
  graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
  
  # Gets the number of nodes
  n <- length(graph$graph$doc$children$gexf[["graph"]][["nodes"]][[number]][["spells"]])
  if (n == 0) {
    natts <- length(graph$graph$doc$children$gexf[["graph"]][["nodes"]][[number]])
    graph$graph$doc$children$gexf[["graph"]][["nodes"]][[number]][[natts + 1]] <-
      XML::asXMLNode(XML::xmlNode("spells"))
  }
    
  # Checking the number of digits
  if (!is.integer(digits)) stop("Invalid number of digits ",digits,
                                ".\n Must be a number between 0 and 22")
  fmt <- sprintf("%%.%gg", digits)
  
  # Checking classes
  if (inherits(start, "numeric") && inherits(start, "numeric")) {
    start <- sprintf(fmt,start)
    end <- sprintf(fmt,end)
  } 
  
  nodespell <- XML::xmlNode("spell", attrs=c(start=start, end=end))
  
  graph$graph$doc$children$gexf[["graph"]][["nodes"]][[number]][["spells"]][[n+1]] <- 
    XML::asXMLNode(x=nodespell)
    
  # Saves and returns as char XML
  graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}

#' @export
#' @rdname add.gexf.node
add.edge.spell <- function(
  ################################################################################
  # Add nodes to gexf class object
  ################################################################################
  graph, 
  id=NULL,
  number=NULL,
  start=NULL, 
  end=NULL,
  digits=getOption("digits")
) {

  # Checks the class
  if (!inherits(graph,"gexf")) stop("-graph- is not of -gexf- class.") 

  # Checking the edge to add to
  if (length(number)==0) {
    if (length(id)==0) stop("No edges specified.")
    else {
      number <- which(graph$edges$id == id)
    }
    if (length(number) == 0) stop("No such edge.")
  }
  
  # Parses the graph file
  graph$graph <- XML::xmlTreeParse(graph$graph, encoding="UTF-8")
  
  # Gets the number of edges
  n <- length(graph$graph$doc$children$gexf[["graph"]][["edges"]][[number]][["spells"]])
  if (n == 0) {
    natts <- length(graph$graph$doc$children$gexf[["graph"]][["edges"]][[number]])
    graph$graph$doc$children$gexf[["graph"]][["edges"]][[number]][[natts + 1]] <-
      XML::asXMLNode(XML::xmlNode("spells"))
  }
  
  # Checking the number of digits
  if (!is.integer(digits)) stop("Invalid number of digits ",digits,
                                ".\n Must be a number between 0 and 22")
  fmt <- sprintf("%%.%gg", digits)
  
  # Checking classes
  if (inherits(start, "numeric") && inherits(start, "numeric")) {
    start <- sprintf(fmt,start)
    end <- sprintf(fmt,end)
  } 

  edgespell <- XML::xmlNode("spell", attrs=c(start=start, end=end))
  
  graph$graph$doc$children$gexf[["graph"]][["edges"]][[number]][["spells"]][[n+1]] <- 
    XML::asXMLNode(x=edgespell)
  
  # Saves and returns as char XML
  graph$graph <- XML::saveXML(XML::xmlRoot(graph$graph), encoding="UTF-8")
  return(graph)
}


