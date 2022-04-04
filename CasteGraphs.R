setwd("C:/RedsData")



library("plyr")
library("ggplot2")
library("igraph")
library("reshape2")
library("Matrix")
library("data.table")
library(tidyverse)
library(haven)
library(igraph)
library(scales)
library("network")


#PART 1 CASTE LEVEL NETWORK
rm(list = ls())  # clear memory

MonNet <- read_dta(file = "MonCastenet.dta") 

names(MonNet)
# [1] "village"        "villageid"      "state"          "ownsid"        
# [5] "owncastegroup"  "ownjati"        "linksid"        "linkcastegroup"
# [9] "linkjati"       "ownjatisize"    "numberlinks"    "totlinks"      
# [13] "proplinks"   

MonNet<-MonNet[(MonNet$villageid == 1),] #keep data for villageid 1

MonNet <- MonNet[order(MonNet$ownjati),] #order data by jati

nodeattributes <- as.matrix(MonNet[!duplicated(MonNet$ownjati),c(6,5,10)])
#keep a single row for each jati and incldue cloumns for jatiname, castegroup, jatisize

nodes <- nodeattributes[,1]

edges<-as.matrix(MonNet[,c(6,9)]) # coerces the data into a two-column matrix format that igraph likes
edges[,1]=as.character(edges[,1])
edges[,2]=as.character(edges[,2])

edgeweight <-as.matrix(MonNet$proplinks)
nodeweight <- as.numeric(nodeattributes[,3])
nodegroup <- nodeattributes[,2]



g<-graph.edgelist(edges,directed=TRUE) %>% # turns the edgelist into a 'graph object'
set_vertex_attr("weight", value = nodeweight) %>%
set_vertex_attr("castegroup", value = nodegroup)


E(g)$weight <- edgeweight


get.data.frame(g) #check data

#vertex_attr(g) #to see vertex attributes
#vertex_attr_names(g) #to see vertex attributes names
#vertex_attr(g, "name") 

#V(g) #the set of vertices
#V(g)$size <- as.numeric(nodeattributes[,3]) #alternative way to set size

bc <- betweenness(g)
ec <- eigen_centrality(g)
#coords <- layout_(g, as_star()) #helps to fix location of nodes each time, we could use street
coords <- layout.auto(g) # another option


#generate node shapes based on castegroup
shaps <- c("rectangle", "square", "circle", "sphere")
V(g)$shape <- shaps[as.numeric(V(g)$castegroup)]
#castegroup - 1(SC=Rect), 2(ST=Square), 3(OBC=Circle), 4(Other=Sphere)


#the graph should satisfy the following
#node shapes by caste group
#node size by some centrality measure
#node names size by size (no. of hh) of jati

plot(
g, 
layout = coords,
vertex.color = rainbow(length(V(g)$jati), alpha = 0.3),
vertex.size = ec$vector*25L, #size of the vertex depends on centrality
vertex.label.cex = rescale(as.numeric(vertex_attr(g, "weight")), c(.5,1.2)), #size of vertex name depends on jatisize
edge.arrow.size = .3,
edge.color = "gray50",
edge.width = E(g)$weight,
edge.curved = .2,
)


#community structure, this is just one method
cfg <- cluster_fast_greedy(as.undirected(g))

#this plot below includes the community structure overlaid
#the links are undirected here since most inbuilt community detection methods use undirected networks

plot(cfg, 
as.undirected(g),
vertex.size = ec$vector*25L, #size of the vertex depends on centrality
vertex.label.cex = rescale(as.numeric(vertex_attr(g, "weight")), c(.5,1.2)), #size of vertex name depends on jatisize
)


#PART 2 HOUSEHOLD

rm(list = ls())  # clear memory

MonNet <- read_dta(file = "MonNet.dta") 

names(MonNet)
# [1] "village"        "villageid"      "state"          "q3"            
# [5] "ownsid"         "owncastegroup"  "ownjati"        "link"          
# [9] "linksid"        "linkcastegroup" "linkjati"

#  [1] "id"         "pair"       "villageid"  "q3"         "ownsid"    
# [6] "owncaste"   "link"       "sid"        "caste"      "village"   
# [11] "state"      "q11"(own)        "castegroup" (link)

MonNet<-MonNet[(MonNet$villageid == 1),]

MonNet <- MonNet[order(MonNet$q3),]
nodeattributes <- as.matrix(MonNet[!duplicated(MonNet$q3),c(4,7,6)])


nodes <- nodeattributes[,1]
edges<-as.matrix(MonNet[,c(4,8)]) 
edges[,1]=as.numeric(edges[,1])
edges[,2]=as.numeric(edges[,2])

nodejati <-nodeattributes[,2]
nodegroup <- nodeattributes[,3]

g<-graph.edgelist(edges,directed=TRUE) %>% # turns the edgelist into a 'graph object'
	set_vertex_attr("jati", value = nodejati) %>%
	set_vertex_attr("castegroup", value = nodegroup)

bc <- betweenness(g)
ec <- eigen_centrality(g)

cfg <- cluster_fast_greedy(as.undirected(g))
clp <- cluster_label_prop(as.undirected(g))



shaps <- c("rectangle", "square", "circle", "sphere")
V(g)$shape <- shaps[as.numeric(V(g)$castegroup)]
#castegroup - 1(SC=Rect), 2(ST=Square), 3(OBC=Circle), 4(Other=Sphere)


plot(
g, 
#layout = coords,
vertex.color = rainbow(length(V(g)$jati), alpha = 0.3),
vertex.frame.color="#555555",
vertex.label.color = "black", 
vertex.label.cex = .07, 
vertex.size = strength, #size of the vertex depends on centrality
edge.arrow.size = .01,
edge.color = "gray50",
edge.curved = .2
)

#plot - color by jati + shape by castegroup + size by some measure of centrality


V(g)$community <- cfg$membership #not needed for plot

plot(cfg, 
as.undirected(g),
vertex.color = "yellow",
vertex.label.color = "black", 
vertex.label.cex = .07, 
vertex.size = strength, #size of the vertex depends on centrality
edge.arrow.size = .01,
edge.color = "gray50",
edge.curved = .2
)

colrs <- adjustcolor( c("gray50", "tomato", "gold", "yellowgreen"), alpha=.6)
plot(g, vertex.color=colrs[V(g)$community])

