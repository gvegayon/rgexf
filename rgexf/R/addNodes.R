addNodes <-
function(x, parent, att=NA, life=NA, ...) {
################################################################################
# Prints the nodes att definition
################################################################################
  if (!all(is.na(life))) {x <- cbind(x, life);time=T} else {time=F}

  apply(x, MARGIN = 1, FUN =
    function(x) {
      x[1] <- as.numeric(x[1])
      x[2] <- as.character(x[2])
      tempnode<-newXMLNode(name='node', parent=parent, attrs=c(
        id=paste(x[1]), label=paste(x[2])))
      if (time) {
        if (!is.na(x[3])) {xmlAttrs(tempnode)['start'] <- as.character(x[3])}
        if (!is.na(x[4])) {xmlAttrs(tempnode)['end'] <- as.character(x[4])}
        }
      # Attributes printing
      sapply(att,
             function(z) {
               if (!all(is.na(att))) {
                 newXMLNode(name='attvalue', attrs=c(
                   'for'=which(att %in% z)), parent=tempnode)
               }
             }
             )})
}

