rm(list = ls())


library(readstata13)
library(ggplot2)
library(igraph)
library(ggraph)
library(readr)
library(tidyverse)
library(plyr)

f <- "E:/Data/Net/"

# Villages are numbered from 1 to 242.
# Villages with IDs 184 & 189 are missing, so they are not included in the loop.
# This loop takes in the Edgelist & Nodelist(created in Stata) for each village,
# creates the network graph where the size of the vertices represent the strength of the network
# through that particular vertex.
# The color of the node(agent/household) represents their caste.
# The plot is then exported to the memory.

for(k in 1:242) {

	if(k==184 || k==189) next

	nodes <- read.dta13(file.path(f, paste0("Node_", k, ".dta")))
        edges <- read.dta13(file.path(f, paste0("Edge_", k, ".dta")))
	
	g1 <- graph_from_data_frame(d=edges, vertices = nodes, directed = F)
	V(g1)$size <- strength(g1)
	
	
	png(paste0(k, ".png"), 3000, 1500)
	
	par(mar=c(0,0,0,0)); plot(g1,
                          vertex.color=vertex_attr(g1)$castecode,
                          vertex.label.color = "black", 
                          vertex.label.cex = .70, 
                          edge.curved=.25, 
                          edge.color="red") 

	dev.off()
	}



