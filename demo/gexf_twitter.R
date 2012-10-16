################################################################################
# Demo of gexf function - An example with real data
################################################################################

pause <- function() {  
  invisible(readline("\nPress <return> to continue: ")) 
}

require(foreign)

# Example to be used as a demo for rgexf
# This example uses follower-following relationships among chilean politicians,
# journalists and political analysists on Twitter (sample) by december 2011. 
# Source: Fabrega and Paredes (2012): "La política en 140 caracteres"
# en Intermedios: medios de comunicación y democracia en Chile. Ediciones UDP

pause()

# inputs: twitter accounts of chilean politicians and the list of following relationships
# among them in the online social network Twitter.
# for more information about Twitter, please visit: www.twitter.com

nodes_att<-read.csv("C:/Users/Jorge/Desktop/Investigacion/rgexf/red_followers_atributos_06012012_nodes.csv", sep=";")
relations_att<-read.csv("C:/Users/Jorge/Desktop/Investigacion/rgexf/red_followers_atributos_06012012_edges.csv", sep="\t")

# preparing data 
nodos<-as.matrix(nodes_att$Label)
num<-length(nodos)
nodos<-cbind(seq(1:num),nodos)
colnames(nodos)<-c("id",'label')

cargo<-as.data.frame(nodes_att$cargo)
partido<-as.data.frame(nodes_att$partido)
sector<-as.data.frame(nodes_att$sector)
categoria<-as.data.frame(nodes_att$categoria)

nodos.att<-cbind(nodes_att$cargo,nodes_att$partido,nodes_att$sector,nodes_att$categoria)
nodos.att<-as.data.frame(nodos.att)
relations<-cbind(relations_att$Source,relations_att$Target)

# Creating the follower-following network in gexf format with some nodes' attribute
pause()

tw_politics_cl<-gexf(nodos,relations,nodesAtt=nodos.att)

print.gexffile(tw_politics_cl, file='example.gexf', replace=T)
