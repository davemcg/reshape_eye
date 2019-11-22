# create smoothed distance plot 
# x axis is euc. distance from macula
# y axis is log2 scaled Area from ReShape
# files are the Rdata distance files from `calculate_euc_dist_from_macula.R`
# last input is the name of the plot
# example: 
# Rscript ~/git/reshape_eye/src/plot_all.R *Rdata dist_plot.pdf

library(tidyverse)
library(cowplot)

args <- commandArgs(trailingOnly = TRUE)

files <- args

all <- list()
for (file in (files %>% rev())[2:length(files)]){
  load(file)
  all[[file]] <- downsample_distance
  all[[file]]$Sample <- (str_split(file, '/')[[1]] %>% rev())[1] %>% gsub('_dist.Rdata', '', .)
}

all <- all %>% bind_rows()

pdf(file = (files %>% rev())[1], width = 6, height = 4)
print(
  all %>% 
    ggplot(aes(x=Distance, y = log2(Area), color = Sample)) + 
    #geom_point(size = 0.1) + 
    geom_smooth() + 
    xlab('Euclidean Distance from Macula') +
    theme_cowplot()
)
dev.off()