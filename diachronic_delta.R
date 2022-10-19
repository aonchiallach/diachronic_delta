#load the libraries we need
library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
library(stylo)
library(glmnet)

#declare the funtions we're going to use

#clean_data highlights elements in the word vector we want rid of 
clean_data <- function(x) {
  x <- gsub('[[:punct:]]+','', x)
  x <- gsub("[[:space:]]", "", x)
  x[which(grepl("0", x))] <- "NULL"
  x[which(grepl("1", x))] <- "NULL"
  x[which(grepl("2", x))] <- "NULL"
  x[which(grepl("3", x))] <- "NULL"
  x[which(grepl("4", x))] <- "NULL"
  x[which(grepl("5", x))] <- "NULL"
  x[which(grepl("6", x))] <- "NULL"
  x[which(grepl("7", x))] <- "NULL"
  x[which(grepl("8", x))] <- "NULL"
  x[which(grepl("9", x))] <- "NULL"
  x[which(grepl("Â", x))] <- "NULL"
  x[which(grepl("â", x))] <- "NULL"
  x[which(grepl("2", x))] <- "NULL"
  x[which(grepl("3", x))] <- "NULL"
  x[which(grepl("4", x))] <- "NULL"
  x[which(grepl("5", x))] <- "NULL"
  x[which(grepl("6", x))] <- "NULL"
  x[which(grepl("7", x))] <- "NULL"
  x[which(grepl("8", x))] <- "NULL"
  x[which(grepl("9", x))] <- "NULL"
  return(x)
}

#normalise data aggregates, pivots and normalises the relative frequency table 
normalise_data <- function(x) {
  x <- aggregate(. ~ year + word, x, sum)
  x <- x %>% pivot_wider(names_from = word, values_from = termfreq, values_fill = 0, names_repair = "unique")
  x[,2:dim(x)[2]] <- scale(x[,2:dim(x)[2]] / rowSums(x[,2:dim(x)[2]]))
  return(x)
}

#return_dist_object gives us a relatively neatly separated out distance matrix
return_dist_object <- function(x) {
  x <- dist.cosine(as.matrix(x))
  x <- melt(as.matrix(x), variable.names(c("to", "from")))
  colnames(x)[1:2] <- c("from", "to")
  return(x)
}

#correlation analysis gives us a neat object that can be used to carry out a rudimentary topic model, i.e. filtering for words like 'love', or 'home' to see what terms correlate positively or negatively across time
correlation_analysis <- function(x) {
  y <- x[, !sapply(x, is.character)]
  y$year...1 <- NULL
  y <- as.data.frame(y)
  y[,apply(y, 2, sd) == 0] <- NULL
  y <- cor(y)
  y <- na.omit(as_tibble(data.frame(row=rownames(y)[row(y)], col=colnames(y)[col(y)], y=c(y))))
  y <- y %>% filter(y >= 0.7 | y <= -0.7)
  y$y <- round(y$y, 2)
  y <- y[!y$row == y$col,]
  return(y)
}

#load in our data
fiction_data <- read.csv("fiction_yearly_summary.csv", stringsAsFactors = F)
poetry_data <- read.csv("poetry_yearly_summary.csv", stringsAsFactors = F)
drama_data <- read.csv("drama_yearly_summary.csv", stringsAsFactors = F)

#read in roman numerals text file
roman_numerals <- read.csv("romannumerals.txt", stringsAsFactors = F)

#drop these columns as we do not need them
fiction_data$correctionapplied <- NULL
poetry_data$correctionapplied <- NULL
drama_data$correctionapplied <- NULL

#strip spaces and punctuation from the word columns
fiction_data$word <- gsub('[[:punct:]]+','', fiction_data$word)
poetry_data$word <- gsub('[[:punct:]]+','', poetry_data$word)
drama_data$word <- gsub('[[:punct:]]+','', drama_data$word)
fiction_data$word <- gsub("[[:space:]]", "", fiction_data$word)
poetry_data$word <- gsub('[[:space:]]','', poetry_data$word)
drama_data$word <- gsub('[[:space:]]','', drama_data$word)

#apply clean data to each of the word vectors
fiction_data$word <- clean_data(fiction_data$word)
poetry_data$word <- clean_data(poetry_data$word)
drama_data$word <- clean_data(drama_data$word)

#create alpha_vector which contains every letter of the alphabet, except a and i, an empty element, roman numerals and a few other artefacts we want to tidy up 
alpha_vector <- c("", "ALLTOKENS", "DICTIONARYWORD", "ALPHABETIC", letters[-c(1, 9)], roman_numerals[,1], "NULL")

#remove every element in alpha vector from the data
fiction_data <- fiction_data %>% filter(!word %in% alpha_vector)
poetry_data <- poetry_data %>% filter(!word %in% alpha_vector)
drama_data <- drama_data %>% filter(!word %in% alpha_vector)

#1724, 1746 and 1749 are where the unbroken sequences of years begin, so we sum these into one year for each dataset
fiction_data$year <- plyr::mapvalues(fiction_data$year, 1701:1724, rep(1724, length(1701:1724)))
poetry_data$year <- plyr::mapvalues(poetry_data$year, 1700:1746, rep(1746, length(1700:1746)))
drama_data$year <- plyr::mapvalues(drama_data$year, 1704:1749, rep(1749, length(1704:1749)))

#call normalise data on each corpus
fiction_data <- normalise_data(fiction_data)
poetry_data <- normalise_data(poetry_data)
drama_data <- normalise_data(drama_data)

#call correlation analysis on each corpus and assign the result to new correlation objects
fiction_data_corr <- correlation_analysis(fiction_data)
poetry_data_corr <- correlation_analysis(poetry_data)
drama_data_corr <- correlation_analysis(drama_data)

#call the function on each dataset
fiction_dist <- return_dist_object(fiction_data)
poetry_dist <- return_dist_object(poetry_data)
drama_dist <- return_dist_object(drama_data)

#and map our values
fiction_dist$from <- plyr::mapvalues(fiction_dist$from, 1:199, fiction_data$year...1)
fiction_dist$to <- plyr::mapvalues(fiction_dist$to, 1:199, fiction_data$year...1)
poetry_dist$from <- plyr::mapvalues(poetry_dist$from, 1:177, poetry_data$year...1)
poetry_dist$to <- plyr::mapvalues(poetry_dist$to, 1:177, poetry_data$year...1)
drama_dist$from <- plyr::mapvalues(drama_dist$from, 1:174, drama_data$year...1)
drama_dist$to <- plyr::mapvalues(drama_dist$to, 1:174, drama_data$year...1)

#remove all our empty distances
fiction_dist <- fiction_dist %>% filter(value != 0)
poetry_dist <- poetry_dist %>% filter(value != 0)
drama_dist <- drama_dist %>% filter(value != 0)

#divide our dataframe into distances forward
fiction_dist_forward <- fiction_dist %>% filter(to > from)
poetry_dist_forward <- poetry_dist %>% filter(to > from)
drama_dist_forward <- drama_dist %>% filter(to > from)

#and back
fiction_dist_backward <- fiction_dist %>% filter(to < from)
poetry_dist_backward <- poetry_dist %>% filter(to < from)
drama_dist_backward <- drama_dist %>% filter(to < from)

#mean fiction poetry and drama by where the distance is coming from
fiction_dist_forward <- fiction_dist_forward %>% group_by(from) %>% summarise(value = mean(value))
poetry_dist_forward <- poetry_dist_forward %>% group_by(from) %>% summarise(value = mean(value))
drama_dist_forward <- drama_dist_forward %>% group_by(from) %>% summarise(value = mean(value))
fiction_dist_backward <- fiction_dist_backward %>% group_by(from) %>% summarise(value = mean(value))
poetry_dist_backward <- poetry_dist_backward %>% group_by(from) %>% summarise(value = mean(value))
drama_dist_backward <- drama_dist_backward %>% group_by(from) %>% summarise(value = mean(value))

#change the column names
colnames(fiction_dist_forward)[2] <- "transience"
colnames(poetry_dist_forward)[2] <- "transience"
colnames(drama_dist_forward)[2] <- "transience"
colnames(fiction_dist_backward)[2] <- "novelty"
colnames(poetry_dist_backward)[2] <- "novelty"
colnames(drama_dist_backward)[2] <- "novelty"

#full join the backwards and forwards data frames
fiction_dist <- full_join(fiction_dist_backward, fiction_dist_forward, by = "from")
poetry_dist <- full_join(poetry_dist_backward, poetry_dist_forward, by = "from")
drama_dist <- full_join(drama_dist_backward, drama_dist_forward, by = "from")

#remove nas
fiction_dist <- fiction_dist[complete.cases(fiction_dist), ]
poetry_dist <- poetry_dist[complete.cases(poetry_dist), ]
drama_dist <- drama_dist[complete.cases(drama_dist), ]

#calculate resonance and attach it to the dataframe
fiction_dist$resonance <- fiction_dist$novelty - fiction_dist$transience
poetry_dist$resonance <- poetry_dist$novelty - poetry_dist$transience
drama_dist$resonance <- drama_dist$novelty - drama_dist$transience

#scale novelty, transience and resonance
fiction_dist[,2:4] <- scale(fiction_dist[,2:4])
poetry_dist[,2:4] <- scale(poetry_dist[,2:4])
drama_dist[,2:4] <- scale(drama_dist[,2:4])

#change the column names
colnames(fiction_dist)[1] <- "year"
colnames(poetry_dist)[1] <- "year"
colnames(drama_dist)[1] <- "year"

#run a correlation analysis across the three datasets
cor(fiction_dist)
cor(poetry_dist)
cor(drama_dist)

#produce a scatter plot of the relationship between population and number of branches in each LA
p <- ggplot(fiction_dist, aes(novelty, resonance)) + 
  labs(title = "Relationship between novelty and resonance in the fiction corpus") +
  geom_point() +
  stat_smooth(method = "lm") +
  xlab("Novelty") +
  ylab("Resonance")

#print the plot
p

#produce a scatter plot of the relationship between population and number of branches in each LA
p <- ggplot(poetry_dist, aes(novelty, resonance)) + 
  labs(title = "Relationship between novelty and resonance in the poetry corpus") +
  geom_point() +
  stat_smooth(method = "lm") +
  xlab("Novelty") +
  ylab("Resonance")

p

#produce a scatter plot of the relationship between population and number of branches in each LA
p <- ggplot(drama_dist, aes(novelty, resonance)) + 
  labs(title = "Relationship between novelty and resonance in the drama corpus") +
  geom_point() +
  stat_smooth(method = "lm") +
  xlab("Novelty") +
  ylab("Resonance")

p

#there are no years which score both a resonance and novelty of over 2 in the fiction dataset, 1750 comes closest
fiction_dist %>% filter(novelty > 2)

#in poetry 1748 does
poetry_dist %>% filter(novelty > 2 & resonance > 2)

#and in drama 1756
drama_dist %>% filter(novelty > 2 & resonance > 2)

#our most pronounced break is 1750 so we need the we need the 82 years which exist on either side of 1837, partitioned into two separate tibbles, pre and post
pre <- fiction_data %>% filter(year...1 < 1750)
post <- fiction_data %>% filter(year...1 < 1777 & year...1 > 1750)

#replace the date column with either zero or one
pre$year...1 <- 0
post$year...1 <- 1

#turn pre and post into dataframes
pre <- as.data.frame(pre)
post <- as.data.frame(post)

#create analysis, which incorporates both pre and post
analysis <- rbind(pre, post)

#turn our year column into a factor
analysis$year...1 <- as.factor(analysis$year...1)

#create empty varibles for our confusion
fiction_confusion_one <- 0
fiction_upwords_one <- 0
fiction_downwords_one <- 0

#create a train set
sample <- sample(c(TRUE, FALSE), nrow(analysis), replace=TRUE, prob=c(0.7,0.3))
train <- analysis[sample,]
test <- analysis[!sample,]

#take our training and test data from the train and test dataframes
trainID <- train$year...1
testID <- test$year...1

#drop these columns from the training, test
train$year...1 <- NULL
test$year...1 <- NULL

#we convert the data into a matrix as this is the data structure glmnet needs
train <- as.matrix(train)
test <- as.matrix(test)

#we then perform a cross-validated fit
cvfit <- cv.glmnet(train, trainID, family = "binomial", type.measure = "class", alpha = 0)

#create a confusion matrix to see how often one was predicted as the other and vice versa
confusion_matrix <- confusion.glmnet(cvfit, newx = test, newy = testID, s = "lambda.min")

#call the confusion matrix
confusion_matrix

#drop the year column from analysis
analysis$year...1 <- NULL

#re-create analysis as a matrix
analysis <- as.matrix(analysis)

#extract the prediction statistics
predictions <- predict(cvfit, analysis, s = "lambda.min", type = "response")

#and print the words which are positively correlated
fiction_upwords_one <- as_tibble(cor(predictions, analysis))[which(as_tibble(cor(predictions,analysis)) >= 0.7)]

#and the negatively correlated words
fiction_downwords_one <- as_tibble(cor(predictions, analysis))[which(as_tibble(cor(predictions, analysis)) <= -0.7)]




