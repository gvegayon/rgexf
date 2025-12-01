# context("igraph back and forth")
# 
# test_that("viz attributes are kept", {
  
  set.seed(1)
  net <- igraph::barabasi.game(10)
  igraph::V(net)$color <- colors()[1:10]
  igraph::V(net)$size  <- runif(10, 10, 20)
  igraph::V(net)$att1  <- rnorm(10)
  igraph::graph_attr(net, "layout") <- igraph::layout_with_fr(net)
    
  net1 <- igraph.to.gexf(net, rescale.node.size=TRUE)
  net2 <- gexf.to.igraph(net1)
  
  # plot(net)
  # plot(net1)
  # 
  
  # Structure is the same
  ne <- igraph::ecount(igraph::difference(net, net2, byname=FALSE))
  expect_equal(ne, 0L)
  
  # Attributes are the same
  expect_equal(igraph::V(net)$att1, igraph::V(net2)$att1)
  
  # Viz attributes are (somewhat) the same
  norml <- function(x) {
    for (i in 1:ncol(x)) {
      pran <- range(x[,i])
      if (pran[1] == pran[2])
        next
      
      x[,i] <- (x[,i] - pran[1])/(pran[2] - pran[1])
    }
      
    x
  }
  
  layout  <- norml(igraph::graph_attr(net, "layout"))
  layout2 <- norml(igraph::graph_attr(net2, "layout"))
  expect_equal(layout[, 1:2], layout2[, 1:2])
  
    
# })
