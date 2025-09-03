# """
#     Este scripts será desenvolvido para rodar os pacotes necesarioas para ler os pacotes 
#     os pacotes serão inataladods a partir de 
#     install.packages comand 
#     or no git com remotes::install_github
#     @Argument: 'nome o pacote ' ou vetor c('pacote1', 'pacote 2')

# """
# Define um mirror do CRAN.
# "https://cloud.r-project.org" é um mirror global, geralmente a melhor escolha.
options(repos = "https://cloud.r-project.org")

# install.packages("readr")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")
# install.packages("tidyverse")
# install.packages("languageserver")
# install.packages("bibliometrix", dependencies= T) # para instalar as dependemias = T (true)
install.packages("pak")


# install.packages(c("dplyr", "ggplot2", "ggraph", "igraph", "readr", "devtools", "remotes", ""))
# remotes::install_github("elizagrames/litsearchr", ref="main")
# library(ggraph)
# library(igraph)
# library(readr)
# library(devtools)
# library(remotes)
# library(litsearchr)