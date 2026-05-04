# Tests for sigmajs() and gexfjs() htmlwidget APIs

les_mis <- system.file("gexf-graphs/lesmiserables.gexf", package = "rgexf")

# sigmajs() returns an htmlwidget -------------------------------------------
w <- sigmajs(les_mis)
expect_inherits(w, "htmlwidget")
expect_inherits(w, "sigmajs")

# sigmajs() also accepts a gexf object --------------------------------------
g <- read.gexf(les_mis)
w2 <- sigmajs(g)
expect_inherits(w2, "htmlwidget")
expect_inherits(w2, "sigmajs")

# plot.gexf() delegates to sigmajs() ----------------------------------------
w3 <- plot(g)
expect_inherits(w3, "htmlwidget")
expect_inherits(w3, "sigmajs")

# sigmajs() rejects URL schemes (SSRF prevention) ----------------------------
expect_error(sigmajs("http://example.com/graph.gexf"), "URLs are not allowed")
expect_error(sigmajs("https://example.com/graph.gexf"), "URLs are not allowed")

# gexfjs() returns an htmlwidget --------------------------------------------
wg <- gexfjs(les_mis)
expect_inherits(wg, "htmlwidget")
expect_inherits(wg, "gexfjs")

# gexfjs() rejects URL schemes (SSRF prevention) ----------------------------
expect_error(gexfjs("http://example.com/graph.gexf"), "URLs are not allowed")
expect_error(gexfjs("https://example.com/graph.gexf"), "URLs are not allowed")
