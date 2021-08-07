################################################################################
# Demo of gexf functions - Building a graph from scratch
# Author: George Vega
################################################################################

pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}

# Creating a new gexf object
pause()
mygraph <- new.gexf.graph()
mygraph

# Adding nodes
pause()
mygraph <- add.gexf.node(mygraph,1,"george", vizAtt=list(size=10))
mygraph <- add.gexf.node(mygraph,2,"valita", vizAtt=list(color=data.frame(20,20,20,1)))
mygraph <- add.gexf.node(mygraph,3,"pedro")

# Adding a node with node with attributes
mygraph <- add.gexf.node(mygraph,4,"diego")

# Adding spells
pause()
mygraph <- add.node.spell(mygraph, 2, start=0, end=10)
mygraph <- add.node.spell(mygraph, 2, start=15)
mygraph <- add.node.spell(mygraph, 4, start=18)

# Adding edges
pause()
mygraph <- add.gexf.edge(mygraph,1,2)
mygraph <- add.gexf.edge(mygraph,3,1)
mygraph <- add.gexf.edge(mygraph,4,1)
mygraph <- add.gexf.edge(mygraph,4,3)
mygraph <- add.gexf.edge(mygraph,4,2)

# Checking it out
pause()
mygraph

# Removing a specific node and all the edges of it
pause()
mygraph <- rm.gexf.node(mygraph, id="1", rm.edges=T)

mygraph

# Removing edge number two
pause()
rm.gexf.edge(mygraph, number=2)
