defEdgesAtt <-
function(...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  sapply(edgesAtt,
         function(x) {newXMLNode(name='attribute', parent=xmlAttLinks,attrs=c(
           id=paste('linkatt',which(edgesAtt %in% x),sep=''),title=x,
           type='string'))
         }
         )
}

