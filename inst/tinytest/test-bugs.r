# context("Checking functions")

# test_that("check_and_map_colors", {
  set.seed(11)
  net <- igraph::barabasi.game(20)
  
  expect_error(igraph.to.gexf(net, nodesVizAtt = list(color=rep(-1L, 20))), "negative")
  col <- t(grDevices::col2rgb(1:20 + 20))
  col[1,1] <- -1
  expect_error(igraph.to.gexf(net, nodesVizAtt = list(color=col)), "range")
  
# })
