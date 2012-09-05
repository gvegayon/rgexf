################################################################################
# Demo of gexf function
################################################################################
pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}
pause()

# Defining a matrix of nodes
pause()
people <- matrix(c(1:4, 'juan', 'pedro', 'matthew', 'carlos'),ncol=2)
people

# Defining a matrix of edges
pause()

relations <- matrix(c(1,4,1,2,1,3,2,3,3,4,4,2,2,4,4,1,4,1), ncol=2, byrow=T)
relations

# Defining a matrix of dynamics (start, end) for nodes and edges
pause()

time.nodes<-matrix(c(10.0,13.0,2.0,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time.nodes

time.edges<-matrix(c(10.0,13.0,2.0,2.0,12.0,1,5,rep(NA,5),rep(c(0,1),3)), ncol=2)
time.edges

# Defining a data frame of attributes for nodes and edges
pause()

node.att <- data.frame(letrafavorita=letters[1:4], numbers=1:4, stringsAsFactors=F)
node.att

edge.att <- data.frame(letrafavorita=letters[1:9], numbers=1:9, stringsAsFactors=F)
edge.att

################################################################################
# First example: a simple net
pause()
gexf(nodes=people, edges=relations)

################################################################################
# Second example: a simple net with nodes attributes
pause()
gexf(nodes=people, edges=relations, nodesAtt=node.att)

################################################################################
# Third example: a simple net with dynamic nodes
pause()
gexf(nodes=people, edges=relations, nodeDynamic=time.nodes)

################################################################################
# Fourth example: a simple net with dynamic nodes with attributes
pause()
gexf(nodes=people, edges=relations, nodeDynamic=time.nodes, nodesAtt=node.att)

################################################################################
# Fifth example: a simple net with dynamic edges with attributes
pause()
gexf(nodes=people, edges=relations, edgeDynamic=time.edges, edgesAtt=edge.att)

################################################################################
# Sixth example: a simple net with dynamic edges and nodes with attributes
pause()
gexf(nodes=people, edges=relations, edgeDynamic=time.edges, edgesAtt=edge.att,
     nodeDynamic=time.nodes, nodesAtt=node.att)