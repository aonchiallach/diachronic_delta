#load the libraries we need
library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
library(stylo)

#declare the funtions we're going to use; clean_data highlights elements in the word vector we want rid of and return_dist_object takes the completed relative frequency table and gives us the results of a distance algorithm
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

return_dist_object <- function(x) {
  x <- aggregate(. ~ year + word, x, sum)
  x <- x %>% pivot_wider(names_from = word, values_from = termfreq, values_fill = 0, names_repair = "unique")
  x[,2:dim(x)[2]] <- scale(x[,2:dim(x)[2]] / rowSums(x[,2:dim(x)[2]]))
  y <- dist.cosine(as.matrix(x))
  y <- melt(as.matrix(y), variable.names(c("to", "from")))
  colnames(y)[1:2] <- c("from", "to")
  return(y)
}

#load in our data
fiction_data <- read.csv("fiction_yearly_summary.csv", stringsAsFactors = F)
poetry_data <- read.csv("poetry_yearly_summary.csv", stringsAsFactors = F)
drama_data <- read.csv("drama_yearly_summary.csv", stringsAsFactors = F)

#read in roman numerals text file
roman_numerals <- read.csv("romannumerals.txt", stringsAsFactors = F)

#drop this column as we do not need it
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



#get rid of the character columns
fiction_data_corr <- fiction_data[, !sapply(fiction_data, is.character)]

fiction_data_corr$year...1 <- NULL

#convert fiction_data_corr into a fiction_data_corrframe
fiction_data_corr <- as.data.frame(fiction_data_corr)

#remove the columns where standard deviation is zero
fiction_data_corr[,apply(fiction_data_corr, 2, sd) == 0] <- NULL

#create a correlation matrix
fiction_data_corr <- cor(fiction_data_corr)

#now we turn the correlation matrix into a fiction_data_corr frame and then a tibble
fiction_data_corr <- na.omit(as_tibble(data.frame(row=rownames(fiction_data_corr)[row(fiction_data_corr)], col=colnames(fiction_data_corr)[col(fiction_data_corr)], fiction_data_corr=c(fiction_data_corr))))

#remove every insignificant effect size
fiction_data_corr <- fiction_data_corr %>% filter(fiction_data_corr >= 0.7 | fiction_data_corr <= -0.7)

#round the correlation coefficients to two decimal points
fiction_data_corr$fiction_data_corr <- round(fiction_data_corr$fiction_data_corr, 2)

#remove autocorrelations
fiction_data_corr <- fiction_data_corr[!fiction_data_corr$row == fiction_data_corr$col,]






data <- readRDS("fiction_frequencies.rds")

#then we remove the first four characters from the colnames of 
#data so that the colnames can be accurate
for(i in 1:length(colnames(data))) {
  colnames(data)[i] <- substr(colnames(data)[i], 5, 
                              nchar(colnames(data)[i]))
}

#replace the first colname with Date
colnames(data)[1] <- "Date"

#create yearvector which is going to hold all our dates so 
#we can call on them easily
yearvector <- data$Date

#our most pronounced break is 1837 so we need the we need the 
#82 years which exist on either side of 1837, partitioned into 
#two separate tibbles, pre and post
pre <- data %>% filter(Date < 1837)
pre <- pre %>% filter(Date > 1755)
post <- data %>% filter(Date > 1837)
post <- post %>% filter(Date < 1919)

#replace the date column with either zero or one
pre$Date <- 0
post$Date <- 1

pre <- as.data.frame(pre)
post <- as.data.frame(post)

#create analysis, which incorporates both pre and post
analysis <- rbind(pre, post)

#turn our date column into a factor
analysis$Date <- as.factor(analysis$Date)

#take the ID variable out of the dataframe
ID <- analysis$Date

confusionone <- 0
upwordsone <- 0
downwordsone <- 0

for(i in 1:100) {
  #create our trainining data, which randomly samples 20% 
  #of our pre and post datasets
  train <- rbind(analysis[sample(which(analysis$Date == 0), 
                                 round(0.2*length(which(analysis$Date == 0)))), ],                                               analysis[sample(which(analysis$Date == 1),                                                    round(0.2*length(which(analysis$Date == 1)))), ])
  #create our test data, which will incorporate everything 
  #from analysis not contained in our training data
  test <- anti_join(analysis, train)
  #take our training and test data 
  #from the train and test dataframes
  trainID <- train$Date
  testID <- test$Date
  #drop these columns from the training, test
  train$Date <- NULL
  test$Date <- NULL
  #we convert the data into a matrix as 
  #this is the data structure glmnet needs
  train <- as.matrix(train)
  test <- as.matrix(test)
  #we then perform a cross-validated fit
  cvfit <- cv.glmnet(train, trainID, family = "binomial", 
                     type.measure = "class", alpha = 0)
  #create a confusion matrix to see how often 
  #one was predicted as the other and vice versa
  confusionmatrix <- confusion.glmnet(cvfit, newx = test, 
                                      newy = testID, s = "lambda.min")
  #extract confusionmatrix values
  confusionone <- c(confusionone, round((confusionmatrix[1] 
                                         + confusionmatrix[4]) / 
                                          sum(confusionmatrix) * 100, 2))
  analysisduplicate <- analysis
  analysisduplicate$Date <- NULL
  #re-create analysis as a matrix
  analysisduplicate <- as.matrix(analysisduplicate)
  #extract the prediction statistics
  predictions <- predict(cvfit, analysisduplicate, 
                         s = "lambda.min", type = "response")
  #and print the words which are positively correlated
  upword <- as_tibble(cor(predictions, 
                          analysisduplicate))[which(as_tibble(cor(predictions, 
                                                                  analysisduplicate)) >= 0.7)]
  upwordsone <- c(upwordsone, upword)
  #and the negatively correlated words
  downword <- as_tibble(cor(predictions, 
                            analysisduplicate))[which(as_tibble(cor(predictions, 
                                                                    analysisduplicate)) <= -0.7)]
  downwordsone <- c(downwordsone, downword)
}




