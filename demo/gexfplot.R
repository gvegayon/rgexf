# Tested in Chrome and Firefox
pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}


#### Simple ####
pause()
people <- data.frame(id = c(1:4), label = c('juan', 'pedro', 'matthew', 'carlos'))
relations <- data.frame(source = c(1,1,1,2,3,4), target = c(4,2,3,3,4,2))
node.att <- data.frame(letrafavorita=letters[1:4], numbers=1:4)

# No position arguments, so it will be random.
pause()
simple.gexf <- gexf(nodes=people, edges=relations, nodesAtt=node.att)

# Plot
pause()
plot(simple.gexf)

#### 'Les Miserable's example of Sigmajs ####
pause()
lesmiserables <- read.gexf(system.file("gexf-graphs/lesmiserables.gexf", package="rgexf"))
plot(lesmiserables)

pause()
plot(lesmiserables, curvedEdges=FALSE)

#### A more complex example ####
if (require(twitterR) & require(plyr)) {

  library(twitteR)
  library(stringr)
  library(plyr)
  library(sna)
  pause()

  tweets <- tolower(twListToDF(searchTwitter(searchString="#rstats", n=1500))$text)
  head(tweets)
  hashtags_remove <- c("#rstats", "#r")


  for(term in hashtags_remove)
    tweets <- gsub(term, "", tweets)

  hashtags <- unique(unlist(str_extract_all(tolower(tweets), "#\\w+")))
  hashtags <- setdiff(hashtags, hashtags_remove)

  nodesizes <- laply(hashtags, function(hashtag) {
    sum(grepl(hashtag, tweets))
  })

  # scaling  sizes
  nodesizes <-  1 + log(nodesizes, base = 3)

  nodes <- data.frame(id = c(1:length(hashtags)), label = hashtags)

  relations <- ldply(hashtags, function(hashtag) {

    hashtag_related <- unlist(str_extract_all(tweets[grepl(hashtag, tweets)], "#\\w+"))
    hashtag_related <- setdiff(hashtag_related, hashtag) 

    if(length(hashtag_related)==0){
      return(data.frame())

    data.frame(source = which(hashtags==hashtag), target =  which(hashtags %in% hashtag_related))
  }
  )

  # Is an undirected graph
  for(row in 1:nrow(relations)){  
    relations[row,] <- sort(relations[row,])
  }

  relations <- unique(relations)


  # Color by sizes
  nodecolors <- data.frame(
    r = sample(1:249, size = nrow(nodes), replace=T),
    g = sample(1:249, size = nrow(nodes), replace=T),
    b = sample(1:249, size = nrow(nodes), replace=T),
    a = 1
  )

  links <- matrix(rep(0, length(hashtags)^2), ncol = length(hashtags))
  for(edge in 1:nrow(relations))
    links[(relations[edge,]$target), (relations[edge,]$source)] <- 1

  positions <- gplot.layout.kamadakawai(links, layout.par=list())
  positions <- cbind(positions, 0) # needs a z axis

  graph <- gexf(
    nodes       = nodes,
    edges       = relations,
    nodesVizAtt = list(
      color    = nodecolors,
      size     = nodesizes,
      position = positions
    )
  )


  plot.gexf(graph, curvedEges="line")

}






