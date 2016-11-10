context("gexf function")

nodes <- cbind(a=1:10, b=letters[1:10])
edges <- matrix(sample(1:10, 20, TRUE), ncol=2)

# ------------------------------------------------------------------------------
test_that("data.frame or matrix work OK", {
  
  ans0 <- gexf(as.data.frame(nodes), as.data.frame(edges))
  ans1 <- gexf(nodes, edges)
  
  expect_equal(ans0,ans1)
})

# ------------------------------------------------------------------------------
test_that("errors", {
  # edge.list
  expect_error(edge.list(cbind(1:10)), "number of columns")
  expect_error(edge.list(list), "class not supported")
  
  # gexf
  expect_error(gexf(nodes[,-1,drop=FALSE], edges), "nodes.+columns")
  expect_error(gexf(nodes, edges[,-1,drop=FALSE]), "edges.+columns")
  expect_error(gexf(nodes, edges, digits = 1.1), "digits")
  expect_error(gexf(nodes, edges, nodeDynamic = nodes[-1,,drop=TRUE]),
               "number of rows")
  expect_error(gexf(nodes, edges, edgeDynamic = edges[-1,,drop=TRUE]),
               "number of rows")
  
  expect_error(gexf(nodes, edges, nodeDynamic = list(1)),"should be a ")
  expect_error(gexf(nodes, edges, edgeDynamic = list(1)),"should be a ")
  
})
