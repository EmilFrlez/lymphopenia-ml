# https://www.r-bloggers.com/correlation-network_plot-with-corrr/
# Install the development version of corrr
#install.packages("devtools")
#devtools::install_github("drsimonj/corrr")
library(corrr)
library(dplyr)
library(ggthemes)
library(ggplot2)
# you have to execute this in terminal window!
datasets::airquality %>% correlate() %>% network_plot(min_cor = .1)


datasets::airquality %>% correlate() %>% network_plot(min_cor = .1)
