# script which takes as input two csv files
# first csv is macula only
# second csv is entire eye
# third value is the downsample 
# fourth value is the new file name

# calculates euclidean distance from all points in eye to the macula center
args <- commandArgs(trailingOnly = TRUE)

library(tidyverse)
macula <- readr::read_csv(args[1])
full <- readr::read_csv(args[2])

euc.dist <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))

macula_center <- c(macula$X %>% mean, macula$Y %>% mean)

# calculate distance for 150000 points from center
downsample_distance <- full %>% 
  sample_n(args[3] %>% as.numeric()) %>% 
  rowwise() %>% 
  mutate(Distance = euc.dist(macula_center, c(X,Y)))

save(downsample_distance, file = args[4])
