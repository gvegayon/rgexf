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

# gexfjs() also accepts a gexf object ---------------------------------------
wg2 <- gexfjs(g)
expect_inherits(wg2, "htmlwidget")
expect_inherits(wg2, "gexfjs")

# gexfjs() rejects URL schemes (SSRF prevention) ----------------------------
expect_error(gexfjs("http://example.com/graph.gexf"), "URLs are not allowed")
expect_error(gexfjs("https://example.com/graph.gexf"), "URLs are not allowed")

# user-supplied width/height are honored -------------------------------------
ws <- sigmajs(les_mis, width = 300, height = 200)
expect_equal(ws$width, 300)
expect_equal(ws$height, 200)

wgs <- gexfjs(les_mis, width = 300, height = 200)
expect_equal(wgs$width, 300)
expect_equal(wgs$height, 200)

# gexfjs() default sizing policy: full width, 400px tall ---------------------
wgd <- gexfjs(les_mis)
expect_equal(wgd$width, "100%")
expect_equal(wgd$height, "400px")
expect_equal(wgd$sizingPolicy$defaultHeight, 400)
expect_equal(wgd$sizingPolicy$knitr$defaultHeight, 400)
expect_false(wgd$sizingPolicy$knitr$figure)
