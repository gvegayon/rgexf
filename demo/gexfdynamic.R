################################################################################
# Demo of gexf function
# Author: Jorge Fabrega
################################################################################

pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}

## Demos for rgexf - Nodes and edges with attributes.
## 1. A matrix of nodes 
## 2. A matrix of edges
## 3. A matrix indicating the active period of each node 
## 4. A matrix indicating the active period of each edge
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
time.nodes<-matrix(c(10.0,13.3,2.5,2.0,12.0,rep(NA,3)), nrow=4, ncol=2)
time.edges<-matrix(c(10.0,13.0,2.0,2.0,12.0,1,5,rep(NA,5),rep(c(0,1),3)), ncol=2)

# In this example, the active period of each node is:
pause()
time.nodes

# And for the edges are:
time.edges

################################################################################
# Dynamic network in gexf:
# you create a .gexf archive by adding the expression:
#
#                       ,output="yourgraph.gexf" 
#
# before the last closing 
# parenthesis in the following function
pause()
gexf(nodes=people, edges=relations, nodeDynamic=time.nodes)

