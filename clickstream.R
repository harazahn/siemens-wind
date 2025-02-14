library(clickstream)
library(igraph)

#Markov Chain (takes forever)
mc <- clickstream::fitMarkovChain(clicks)
show(mc)
end_probs <- mc@end

# Get the absorbing states
abs_states <- absorbingStates(mc)

#Markov Chain for visit duration (also takes forever)
mc_dur <- clickstream::fitMarkovChain(clicks_visitduration)
show(mc_dur)
end_probs_dur <- mc_dur@end

# Get the absorbing states
abs_states_dur <- absorbingStates(mc_dur)

# Use igraph package to plot chain
net <- graph_from_adjacency_matrix(as.matrix(mc@transitions$`1`), mode = 'directed', weighted = TRUE)
net <- delete.edges(net, which(E(net)$weight <= 0.4))
net <- delete.vertices(net,which(degree(net)<1))
net <- simplify(net, remove.loops = T)
E(net)$arrow.size <- 0.2
deg <- degree(net, mode = 'all')
colrs <- ifelse(deg > 3, 'red','blue')
plot(net, vertex.shape = 'none',
     vertex.label.color = colrs)

# Two main absorbing states, so try splitting into two clusters
clusters <- clusterClickstreams(clicks, order = 0, centers = 2)
summary(clusters)

# Build Markov Chain off each cluster and check absorbing states
mc1 <- fitMarkovChain(clusters$clusters[1])
mc2 <- fitMarkovChain(clusters$clusters[2])
show(mc1) # Code 10105 Stop Urgency5
show(mc2) # Code 14001 Warning NoStop

#Frequencies
frequencyDF <- frequencies(clicks)

