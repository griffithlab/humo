path <- rstudioapi::getActiveDocumentContext()$path
Encoding(path) <- "UTF-8"

setwd(dirname(path))
#setwd("~/Downloads/RotTwo")

fileNames <- list.files("parsed_xenome_classify/", pattern="*.log", full.names=TRUE)

for(fileName in fileNames){
  fileData <- read.table(fileName)
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(fileName, header=TRUE, sep="\t")
    dataset$sample <- basename(fileName)
  }
  
  # if the merged dataset does exist, append to it
  else if (exists("dataset")){
    temp_dataset <- read.table(fileName, header=TRUE, sep="\t")
    temp_dataset$sample <- basename(fileName)
    
    dataset <- rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }

}

library(ggplot2)
library(gridExtra)
countBar <- ggplot(data = dataset, aes(x = sample, y = count, fill = class)) + geom_col() + theme(axis.text.x=element_text(angle=60, size=5, hjust=1))
percentBar <- ggplot(data = dataset, aes(x = sample, y = percent, fill = class)) + geom_col() + theme(axis.text.x=element_text(angle=60, size=5, hjust=1))

grid.arrange(countBar, percentBar, ncol = 2)
