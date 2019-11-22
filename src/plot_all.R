# create smoothed distance plot 
# x axis is euc. distance from macula
# y axis is log2 scaled Area from ReShape


args <- commandArgs(trailingOnly = TRUE)

args <- c()

load(files[1])
all <- list()
for (file in files){
  load(file)
  all[[file]] <- downsample_distance
}

all <- all %>% bind_rows(.id = 'File')


all %>% 
  ggplot(aes(x=Distance, y = log2(Area), color = File)) + 
  #geom_point(size = 0.1) + 
  geom_smooth() + 
  xlab('Euclidean Distance from Macula')
