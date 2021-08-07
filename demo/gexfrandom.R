###############################################################################
# Demo of random (art) graph
# Author: George Vega
###############################################################################

pause <- function() {
  invisible(readline("\nPress <return> to continue: "))
}

# This demo will create three randomly connected graphs.
# The colors and everything else are arbitrary.
pause()

# Random graph demo
set.seed(11)

# Vertex
pause()
n <- 30
prb <- .3
vertex1 <- data.frame(id=1:n,label=1:n)
vertex2 <- data.frame(id=(n+1):(2*n),label=(n+1):(2*n))
vertex3 <- data.frame(id=(2*n+1):(3*n),label=(2*n+1):(3*n))

# Edges
pause()
edges1 <- combn(vertex1$label,2)
edges1 <- edges1[,which(runif(ncol(edges1)) > (1-prb))]
edges1 <- data.frame(source=edges1[1,],target=edges1[2,])

edges2 <- combn(vertex2$label,2)
edges2 <- edges2[,which(runif(ncol(edges2)) > (1-prb))]
edges2 <- data.frame(source = edges2[1,],target = edges2[2,])

edges3 <- combn(vertex3$label,2)
edges3 <- edges3[, which(runif(ncol(edges3)) > (1 - prb))]
edges3 <- data.frame(source = edges3[1,], target = edges3[2,])

# Visual attributes
pause()
size   <- runif(n, max = 100)
color  <- terrain.colors(n)
color  <- color[order(runif(n))][1:n]

color2 <- heat.colors(n)
color2 <- color2[order(runif(n))][1:n]

color3 <- topo.colors(n)
color3 <- color3[order(runif(n))][1:n]

# Nice layout
pause()
pos <- matrix(0, nrow=n, ncol=3)

for (i in 2:n) {
  pos[i, 1] <- pos[i - 1, 1] + cos(2*pi*(i*1.7 - 1)/n)
  pos[i, 2] <- pos[i - 1, 2] + sin(2*pi*(i - 1)/n)
}

pos[, 2] <- pos[, 2] - mean(pos[, 2])

pos <- pos/(max(pos) - min(pos))*500
pos2 <- pos
pos2[,1] <- pos2[,1] + max(pos2[,1])-min(pos[,1])
pos3 <- pos
pos3[,1] <- pos3[,1] + max(pos2[,1])-min(pos[,1])

# Plotting
pause()
graph <- gexf(
  rbind(vertex1,vertex2,vertex3),
  rbind(edges1, edges2,edges3),
  nodesVizAtt = list(
    size     = c(size,size,size),
    color    = c(color,color2,color3),
    position = rbind(pos,pos2,pos3)
  ),
  vers = "1.2"
)

# Visualizing
pause()
plot(graph)

# Visualizing with igraph
pause()
plot(gexf.to.igraph(graph))
