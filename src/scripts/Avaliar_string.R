####################
### Instalar bibliotecas
#######################

# install.packages(c("dplyr", "ggplot2", "ggraph", "igraph", "readr", "devtools", "remotes", ""))
# remotes::install_github("elizagrames/litsearchr", ref="main")
#########################################################################
library(dplyr)
library(ggplot2)
library(ggraph)
library(igraph)
library(readr)
library(devtools)
library(remotes)
library(litsearchr)
##############################################################################

##########################################################################################
## Mudar o dir do arquivo baseado no dado de vocês
path_bib = "C:/Papers_revis/OIL_review/New_data/TAB_NEW_21_04_2025/WOS_1_500.bib"
naive_results <- import_results(file= path_bib)
nrow(naive_results)
colnames(naive_results)

#Avaliar documentos sem kywords
#naive_results[1, "title"]
#naive_results[4, "keywords"]
#sum(is.na(naive_results[, "keywords"]))
## 
extract_terms(keywords=naive_results[, "keywords"], method="tagged")

keywords <- extract_terms(keywords=naive_results[, "keywords"], method="tagged", min_n=1)
extract_terms(text=naive_results[, "title"], method="fakerake", min_freq=3, min_n=2)

# Primeiro, criamos um vetor com todas as palavras
palavras <- c(
    "advances", "analyse", "analysed", "analyses", "analysing", "analysis", "analyze", "analyzes",
    "analyzed", "analyzing", "assess", "assessed", "assesses", "assessing", "assessment", "assessments",
    "benefit", "based", "benefits", "change", "changed", "changes", "changing", "characteristic",
    "characteristics", "characterize", "characterized", "characterizes", "characterizing", "clinical",
    "cluster", "combine", "combined", "combines", "combining", "comorbid", "comorbidity", "compare",
    "compared", "compares", "comparing", "comparison", "control", "controlled", "controlling", "controls",
    "design", "designed", "designing", "effect", "effective", "effectiveness", "effects", "efficacy",
    "feasible", "feasibility", "follow", "followed", "following", "follows", "group", "groups", "impact",
    "intervention", "interventions", "longitudinal", "moderate", "moderated", "moderates", "moderating",
    "moderator", "moderators", "outcome", "outcomes", "patient", "patients", "people", "pilot", "practice",
    "predict", "predicted", "predicting", "predictor", "predictors", "predicts", "preliminary", "primary",
    "protocol", "quality", "random", "randomise", "randomised", "randomising", "randomize", "randomized",
    "randomizing", "rationale", "reduce", "reduced", "reduces", "reducing", "related", "report", "reported",
    "reporting", "reports", "response", "responses", "result", "resulted", "resulting", "results", "review",
    "studied", "studies", "study", "studying", "systematic", "treat", "treated", "treating", "treatment",
    "treatments", "treats", "trial", "trials", "versus"
)

# Agora, transformamos esse vetor em um dataframe
df_palavras <- data.frame(Palavra = palavras)

# Visualizar
print(df_palavras)


#clinpsy_stopwords <- read_lines(df_palavras)
all_stopwords <- c(get_stopwords("English"), df_palavras)

title_terms <- extract_terms(
    text=naive_results[, "title"],
    method="fakerake",
    min_freq=3, min_n=2,
    stopwords=all_stopwords
)

terms <- unique(c(keywords, title_terms))

############ Redes

docs <- paste(naive_results[, "title"], naive_results[, "abstract"], naive_results[, "keywords"])
dfm <- create_dfm(elements=docs, features=terms)
g <- create_network(dfm, min_studies=3)

### Grafico 

ggraph(g, layout="stress") +
    coord_fixed() +
    expand_limits(x=c(-3, 3)) +
    geom_edge_link(aes(alpha=weight)) +
    geom_node_point(shape="circle filled", fill="white") +
    geom_node_text(aes(label=name), hjust="outward", check_overlap=TRUE) +
    guides(edge_alpha=FALSE)

#### Corte
strengths <- strength(g)

data.frame(term=names(strengths), strength=strengths, row.names=NULL) %>%
    mutate(rank=rank(strength, ties.method="min")) %>%
    arrange(strength) ->
    term_strengths

term_strengths

### Grafico corte
cutoff_fig <- ggplot(term_strengths, aes(x=rank, y=strength, label=term)) +
    geom_line() +
    geom_point() +
    geom_text(data=filter(term_strengths, rank>5), hjust="right", nudge_y=20, check_overlap=TRUE)

cutoff_fig

cutoff_cum <- find_cutoff(g, method="cumulative", percent=0.8)

cutoff_fig +
    eom_hline(yintercept=cutoff_cum, linetype="dashed")

## Lista termos
get_keywords(reduce_graph(g, cutoff_cum))

#######
cutoff_fig +
    geom_hline(yintercept=cutoff_change, linetype="dashed")
##

cutoff_change <- find_cutoff(g, method="changepoint", knot_num=3)
##### Cortes final

g_redux <- reduce_graph(g, cutoff_change[1])
selected_terms <- get_keywords(g_redux)

selected_terms


##### Agrupar termos

grouped_terms <-list(
    oilspill=selected_terms[c(14, 28)],
    models=selected_terms[c(4, 6, 7, 17, 24, 25, 26, 29, 30)],
    trajectory=selected_terms[c(2, 3, 9, 12, 15, 19, 20, 21, 23, 27)]
)

grouped_terms



