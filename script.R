
# load dataset
library(tidyverse)

data_url <- 'https://raw.githubusercontent.com/koimabrian/Datasets/refs/heads/main/Wine.csv'
Wine <- read.csv(data_url, comment = "#")  # Handle potential comments in the CSV

# standardize continuous variables
data <- Wine %>% select(-Obs, -Country) %>% scale()

# create clusters with k-means
kmeans(data, centers = 3, iter.max = 100, nstart = 100)

# determine and visualize optimal number of clusters
library(factoextra)
fviz_nbclust(data, kmeans, method = "wss") 
fviz_nbclust(data, kmeans, method = "silhouette")
fviz_nbclust(data, kmeans, method = "gap_stat") 

# create cluster biplot
fviz_cluster(kmeans(data, centers = 3, iter.max = 100, nstart = 100), data = data)

# visualize clusters using original variables
clusters <- kmeans(data, centers = 3, iter.max = 100, nstart = 100)
Wine <- Wine |> mutate(cluster = clusters$cluster)
Wine |> ggplot(aes(x = Rating, y = Price, col = as.factor(cluster))) + geom_point()
