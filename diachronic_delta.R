library(dplyr)
library(tidyr)
library(stylo)
library(reshape2)

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

#this is obviously all a catastrophe, but for some reason R gets temperamental whne I try to apply these at once 
fiction_data$word <- gsub('[[:punct:]]+','', fiction_data$word)
poetry_data$word <- gsub('[[:punct:]]+','', poetry_data$word)
drama_data$word <- gsub('[[:punct:]]+','', drama_data$word)
fiction_data$word <- gsub("[[:space:]]", "", fiction_data$word)
poetry_data$word <- gsub('[[:space:]]','', poetry_data$word)
drama_data$word <- gsub('[[:space:]]','', drama_data$word)

fiction_data <- fiction_data[which(!grepl("0", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("1", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("2", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("3", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("4", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("5", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("6", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("7", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("8", fiction_data$word)),]
fiction_data <- fiction_data[which(!grepl("9", fiction_data$word)),]

poetry_data <- poetry_data[which(!grepl("0", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("1", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("2", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("3", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("4", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("5", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("6", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("7", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("8", poetry_data$word)),]
poetry_data <- poetry_data[which(!grepl("9", poetry_data$word)),]

drama_data <- drama_data[which(!grepl("0", drama_data$word)),]
drama_data <- drama_data[which(!grepl("1", drama_data$word)),]
drama_data <- drama_data[which(!grepl("2", drama_data$word)),]
drama_data <- drama_data[which(!grepl("3", drama_data$word)),]
drama_data <- drama_data[which(!grepl("4", drama_data$word)),]
drama_data <- drama_data[which(!grepl("5", drama_data$word)),]
drama_data <- drama_data[which(!grepl("6", drama_data$word)),]
drama_data <- drama_data[which(!grepl("7", drama_data$word)),]
drama_data <- drama_data[which(!grepl("8", drama_data$word)),]
drama_data <- drama_data[which(!grepl("9", drama_data$word)),]

#then we remove all the details we don't want
fiction_data <- fiction_data %>% filter(!word %in% roman_numerals[,1])
poetry_data <- poetry_data %>% filter(!word %in% roman_numerals[,1])
drama_data <- drama_data %>% filter(!word %in% roman_numerals[,1])

fiction_data <- fiction_data %>% filter(word != "")
fiction_data <- fiction_data %>% filter(word != "b")
fiction_data <- fiction_data %>% filter(word != "c")
fiction_data <- fiction_data %>% filter(word != "d")
fiction_data <- fiction_data %>% filter(word != "e")
fiction_data <- fiction_data %>% filter(word != "f")
fiction_data <- fiction_data %>% filter(word != "g")
fiction_data <- fiction_data %>% filter(word != "h")
fiction_data <- fiction_data %>% filter(word != "j")
fiction_data <- fiction_data %>% filter(word != "k")
fiction_data <- fiction_data %>% filter(word != "l")
fiction_data <- fiction_data %>% filter(word != "m")
fiction_data <- fiction_data %>% filter(word != "n")
fiction_data <- fiction_data %>% filter(word != "p")
fiction_data <- fiction_data %>% filter(word != "q")
fiction_data <- fiction_data %>% filter(word != "r")
fiction_data <- fiction_data %>% filter(word != "s")
fiction_data <- fiction_data %>% filter(word != "t")
fiction_data <- fiction_data %>% filter(word != "u")
fiction_data <- fiction_data %>% filter(word != "v")
fiction_data <- fiction_data %>% filter(word != "w")
fiction_data <- fiction_data %>% filter(word != "x")
fiction_data <- fiction_data %>% filter(word != "y")
fiction_data <- fiction_data %>% filter(word != "z")
fiction_data <- fiction_data %>% filter(word != "ALLTOKENS")
fiction_data <- fiction_data %>% filter(word != "DICTIONARYWORD")
fiction_data <- fiction_data %>% filter(word != "ALPHABETIC")

poetry_data <- poetry_data %>% filter(word != "")
poetry_data <- poetry_data %>% filter(word != "b")
poetry_data <- poetry_data %>% filter(word != "c")
poetry_data <- poetry_data %>% filter(word != "d")
poetry_data <- poetry_data %>% filter(word != "e")
poetry_data <- poetry_data %>% filter(word != "f")
poetry_data <- poetry_data %>% filter(word != "g")
poetry_data <- poetry_data %>% filter(word != "h")
poetry_data <- poetry_data %>% filter(word != "j")
poetry_data <- poetry_data %>% filter(word != "k")
poetry_data <- poetry_data %>% filter(word != "l")
poetry_data <- poetry_data %>% filter(word != "m")
poetry_data <- poetry_data %>% filter(word != "n")
poetry_data <- poetry_data %>% filter(word != "p")
poetry_data <- poetry_data %>% filter(word != "q")
poetry_data <- poetry_data %>% filter(word != "r")
poetry_data <- poetry_data %>% filter(word != "s")
poetry_data <- poetry_data %>% filter(word != "t")
poetry_data <- poetry_data %>% filter(word != "u")
poetry_data <- poetry_data %>% filter(word != "v")
poetry_data <- poetry_data %>% filter(word != "w")
poetry_data <- poetry_data %>% filter(word != "x")
poetry_data <- poetry_data %>% filter(word != "y")
poetry_data <- poetry_data %>% filter(word != "z")
poetry_data <- poetry_data %>% filter(word != "ALLTOKENS")
poetry_data <- poetry_data %>% filter(word != "DICTIONARYWORD")
poetry_data <- poetry_data %>% filter(word != "ALPHABETIC")

drama_data <- drama_data %>% filter(word != "")
drama_data <- drama_data %>% filter(word != "b")
drama_data <- drama_data %>% filter(word != "c")
drama_data <- drama_data %>% filter(word != "d")
drama_data <- drama_data %>% filter(word != "e")
drama_data <- drama_data %>% filter(word != "f")
drama_data <- drama_data %>% filter(word != "g")
drama_data <- drama_data %>% filter(word != "h")
drama_data <- drama_data %>% filter(word != "j")
drama_data <- drama_data %>% filter(word != "k")
drama_data <- drama_data %>% filter(word != "l")
drama_data <- drama_data %>% filter(word != "m")
drama_data <- drama_data %>% filter(word != "n")
drama_data <- drama_data %>% filter(word != "p")
drama_data <- drama_data %>% filter(word != "q")
drama_data <- drama_data %>% filter(word != "r")
drama_data <- drama_data %>% filter(word != "s")
drama_data <- drama_data %>% filter(word != "t")
drama_data <- drama_data %>% filter(word != "u")
drama_data <- drama_data %>% filter(word != "v")
drama_data <- drama_data %>% filter(word != "w")
drama_data <- drama_data %>% filter(word != "x")
drama_data <- drama_data %>% filter(word != "y")
drama_data <- drama_data %>% filter(word != "z")
drama_data <- drama_data %>% filter(word != "ALLTOKENS")
drama_data <- drama_data %>% filter(word != "DICTIONARYWORD")
drama_data <- drama_data %>% filter(word != "ALPHABETIC")

#1724, 1746 and 1749 are where the unbroken sequences of years begin, so we sum these into one year for each dataset
fiction_data$year <- plyr::mapvalues(fiction_data$year, 1701:1724, rep(1724, length(1701:1724)))
poetry_data$year <- plyr::mapvalues(poetry_data$year, 1700:1746, rep(1746, length(1700:1746)))
drama_data$year <- plyr::mapvalues(drama_data$year, 1704:1749, rep(1749, length(1704:1749)))

#aggreagate fiction, poetry and drama across year and word
fiction_data <- aggregate(. ~ year + word, fiction_data, sum)
poetry_data <- aggregate(. ~ year + word, poetry_data, sum)
drama_data <- aggregate(. ~ year + word, drama_data, sum)

#pivot the data wider
fiction_data <- fiction_data %>% pivot_wider(names_from = word, values_from = termfreq, values_fill = 0, names_repair = "unique")
poetry_data <- poetry_data %>% pivot_wider(names_from = word, values_from = termfreq, values_fill = 0, names_repair = "unique")
drama_data <- drama_data %>% pivot_wider(names_from = word, values_from = termfreq, values_fill = 0, names_repair = "unique")

#turn all the raw counts into relative frequencies, normalise them by column
fiction_data[,2:dim(fiction_data)[2]] <- scale(fiction_data[,2:dim(fiction_data)[2]] / rowSums(fiction_data[,2:dim(fiction_data)[2]]))
poetry_data[,2:dim(poetry_data)[2]] <- scale(poetry_data[,2:dim(poetry_data)[2]] / rowSums(poetry_data[,2:dim(poetry_data)[2]]))
drama_data[,2:dim(drama_data)[2]] <- scale(drama_data[,2:dim(drama_data)[2]] / rowSums(drama_data[,2:dim(drama_data)[2]]))

#apply cosine distance to the datasets
fiction_dist <- dist.cosine(as.matrix(fiction_data))
poetry_dist <- dist.cosine(as.matrix(poetry_data))
drama_dist <- dist.cosine(as.matrix(drama_data))

#reshape the matrix into dataframes
fiction_dist <- melt(as.matrix(fiction_dist), variable.names(c("to", "from")))
poetry_dist <- melt(as.matrix(poetry_dist), variable.names(c("to", "from")))
drama_dist <- melt(as.matrix(drama_dist), variable.names(c("to", "from")))

#change the column names so we know the direction
colnames(fiction_dist)[1:2] <- c("from", "to")
colnames(poetry_dist)[1:2] <- c("from", "to")
colnames(drama_dist)[1:2] <- c("from", "to")

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

cor(fiction_dist, method = c("pearson", "kendall", "spearman"))
cor(poetry_dist, method = c("pearson", "kendall", "spearman"))
cor(drama_dist, method = c("pearson", "kendall", "spearman"))




