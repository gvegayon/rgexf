################################################################################
# Demo of gexf function - basic example 
# Author: Jorge Fabrega
################################################################################

pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}

pause()
## Demos for rgexf - Basic example.
## The basic function of rgexf requires: 
## 1. A matrix of nodes 
## 2. A matrix of edges

# Defining a matrix of nodes
people <- data.frame(matrix(c(1:4, 'juan', 'pedro', 'matthew', 'carlos'),
                            ncol=2))
people

# Defining a matrix of edges
relations <- data.frame(matrix(c(1,4,1,2,1,3,2,3,3,4,4,2,2,4,4,1,4,1), 
                               ncol=2, byrow=T))
relations
################################################################################
# Basic network
# you create a .gexf archive by adding the expression:
#
#                       ,output="yourgraph.gexf" 
#
# before the last closing 
# parenthesis in the following function
pause()
gexf(nodes=people, edges=relations)

################################################################################  
