defNodesAtt <-
function(x, parent, ...) {
################################################################################
# Prints the nodes att definition
################################################################################  
  sapply(x,
         function(x) {newXMLNode(name='attribute', parent=parent,attrs=c(
           id=paste('nodeatt',which(X %in% x),sep=''),title=x,
           type='string'))
         }
         )
}

