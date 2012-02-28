addEdges <-
function(x, parent, att=NA, life=NA, ...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  apply(x, MARGIN = 1, FUN =
    function(x) {
      tempedge<-newXMLNode(name='edge', parent=parent, attrs=c(
        source=paste(x[1]), target=paste(x[2])))
      sapply(att,
             function(z) {
               if (!all(is.na(att))) {
                 newXMLNode(name='attvalue', attrs=c(
                   'for'=which(att %in% z)), parent=tempedge)
               }
             }
             )})
}

