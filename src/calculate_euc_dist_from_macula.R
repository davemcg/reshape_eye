# script which takes as input two csv files
# first csv is macula only
# second csv is entire eye
# third value is the downsample 
# fourth value is the new file name
# if fifth value given, then outputs a pdf (named with fifth value) showing 
# where the macula is calculated
# example:
# Rscript ~/git/reshape_eye/src/calculate_euc_dist_from_macula.R 18-0761-W-\(OD\)-48_P1F.csv 18-0761-W-\(OD\)/18-0761-W-\(OD\)-48_Data.csv 200000 18_0761_dist.Rdata test.pdf


# calculates euclidean distance from all points in eye to the macula center
args <- commandArgs(trailingOnly = TRUE)

library(tidyverse)
library(cowplot)
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

if (!is.na(args[5])){
  pdf(args[5], width = 7, height = 5)
  print(
    full %>% 
      sample_n(50000) %>% 
      ggplot(aes(x=X,y=-Y, color = log2(Area))) + 
      geom_point(size = 0.3, alpha = 0.8) + 
      geom_vline(aes(xintercept=macula_center[1])) + 
      geom_hline(aes(yintercept = -macula_center[2])) + 
      theme_cowplot() +
      scale_color_viridis_c()
  )
  dev.off()
}