################################################################################
# Demo of gexf functions - Building a graph from scratch
# Author: George Vega
################################################################################

pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}

pause()
# Creating a new gexf object
mygraph <- new.gexf.graph()
mygraph

pause()
# Adding nodes
mygraph <- add.gexf.node(mygraph,1,"george")
mygraph <- add.gexf.node(mygraph,2,"valita")
mygraph <- add.gexf.node(mygraph,3,"pedro")
mygraph <- add.gexf.node(mygraph,4,"diego")

pause()
# Adding edges
mygraph <- add.gexf.edge(mygraph,1,2)
mygraph <- add.gexf.edge(mygraph,3,1)
mygraph <- add.gexf.edge(mygraph,4,1)
mygraph <- add.gexf.edge(mygraph,4,3)
mygraph <- add.gexf.edge(mygraph,4,2)

pause()
# Checking it out
mygraph

pause()
# Removing a specific node and all the edges of it
mygraph <- rm.gexf.node(mygraph, id="1", rm.edges=T)

mygraph
pause()
# Removing edge number two
mygraph <- rm.gexf.edge(mygraph, number=2)
