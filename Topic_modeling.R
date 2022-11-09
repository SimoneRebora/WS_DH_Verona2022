# Topic_modeling

# Welcome!
# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# install and load libraries
install.packages("reshape2")
install.packages("ggplot2")
install.packages("ggwordcloud")
install.packages("stringr")

library(reshape2)
library(ggplot2)
library(ggwordcloud)
library(stringr)

# read the form results
experiment_results <- read.csv("dataset/Topic Modeling Experiment.csv")

# extract the descriptions
descriptions <- experiment_results[,(2*1:10)]
colnames(descriptions) <- substr(colnames(descriptions), 1, 15)
colnames(descriptions) <- paste("Topic", str_pad(string = 1:10, width = 2, pad = 0), "--", colnames(descriptions))

# extract the confidence scores
confidences <- experiment_results[,(2*1:10)+1]
colnames(confidences) <- colnames(descriptions)

# create graph for confidence scores
confidences_melt <- melt(confidences)
ggplot(confidences_melt, aes(x = variable, y = value)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# create graph for descriptions

# prepare the data (quite a complex script, sorry...)
descriptions_list <- lapply(descriptions, function(x) paste(x, collapse = " "))
descriptions_list <- lapply(descriptions_list, tolower)
descriptions_list <- lapply(descriptions_list, function(x) strsplit(x, "\\W"))
descriptions_list <- lapply(descriptions_list, table)

descriptions_df <- data.frame()

for(i in 1:length(descriptions_list)){
  
  tmp_df <- data.frame(topic = names(descriptions_list)[i], 
                       term = names(descriptions_list[[i]]), 
                       weight = as.vector(descriptions_list[[i]]), stringsAsFactors = F)
  descriptions_df <- rbind(descriptions_df, tmp_df)
  
}

# print the data
ggplot(descriptions_df, aes(label = term, size = weight)) +
  geom_text_wordcloud_area() +
  facet_wrap(~topic) +
  scale_size_area(max_size = 10) # you can play a bit with this last number to adapt the graph dimensions

