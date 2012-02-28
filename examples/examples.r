people <- matrix(c(1:4, 'juan', 'pedro', 'matthew', 'carlos'),ncol=2)

relations <- matrix(c(1,4,1,2,1,3,2,3,3,4,4,2), ncol=2, byrow=T)

x <- gexf(people, relations)