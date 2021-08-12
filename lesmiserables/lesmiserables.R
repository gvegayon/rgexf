library(rgexf)

# Accessing the path of the file
fn    <- system.file(
  "gexf-graphs/lesmiserables.gexf", package = "rgexf"
)
lesmi <- read.gexf(fn)

plot(lesmi, dir = "lesmiserables", overwrite = TRUE, copy.only = TRUE)
