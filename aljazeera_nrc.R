library(ggplot2)
library(syuzhet)
library(dplyr)
library(tidytext)

news <- read.csv(file="/home/cynthiak/Ebola/all_source_text.csv", header=TRUE, sep=",")
Sentimentscores <- read.csv(text="day,month_year,sentiment,score")

head(Sentimentscores)

for (row in 1:nrow(news)) {
  curr_date <-toString(news[row, "date"])
  current_date <- strsplit(curr_date, "-")[[1]]
  month_year <- paste(current_date[2], current_date[3],sep="_")
  
  text  <- news[row, "aljazeera_text"]
  #convert all text to lower case
  text <- tolower(text)
  # Replace blank space (“rt”)
  text <- gsub("rt", "", text)
  # Replace @UserName
  text <- gsub("@\\w+", "", text)
  # Remove punctuation
  text <- gsub("[[:punct:]]", "", text)
  # Remove links
  text <- gsub("http\\w+", "", text)
  # Remove tabs
  text <- gsub("[ |\t]{2,}", "", text)
  # Remove blank spaces at the beginning
  text <- gsub("^ ", "", text)
  # Remove blank spaces at the end
  text <- gsub(" $", "", text)
  #getting emotions using in-built function
  sentiment <-get_nrc_sentiment((text))
  #calculationg total score for each sentiment
  Sentimentscores_1<-data.frame(colSums(sentiment[,]))
  
  names(Sentimentscores_1)<-"Score"
  Sentimentscores_1<-cbind("day"=rep(current_date[1],10),"month_year"=rep(month_year,10),"sentiment"=rownames(Sentimentscores_1),Sentimentscores_1)
  rownames(Sentimentscores_1)<-NULL
  
  Sentimentscores <- rbind(Sentimentscores, Sentimentscores_1)
}

head(Sentimentscores)
names(Sentimentscores)

agg_sentiment <- aggregate(Sentimentscores$Score, by=list(date=Sentimentscores$month_year, sentiment=Sentimentscores$sentiment), FUN=sum)
names(agg_sentiment)[3] <- "Score"

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

dfNorm <- as.data.frame(lapply(agg_sentiment["Score"], normalize))

head(dfNorm)

new <- subset(agg_sentiment, select = -Score )
new <-cbind(new, "Score"=dfNorm)

head(new)

new$date <- as.factor(new$date)

#plotting the sentiments with scores
p <- ggplot(data=new,aes(x=date,y=Score, group=sentiment))+ geom_line(aes(color=sentiment))+
  geom_point(aes(color=sentiment))+
  theme(legend.position="right")+
  xlab("Days")+ylab("scores")+ggtitle("Sentiments nrc - source AlJazeera")

#p+scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#FF6347", "#228B22", "#008080", "#FFA500", "#800080", "#CCCC00", "#FF69B4"))
p+scale_color_brewer(palette="Paired")

positive <- subset(new, sentiment=="positive")

new2 <- rbind(positive, negative)

negative <- subset(new, sentiment=="negative")

anticipation <- subset(new, sentiment=="anticipation")
new2 <- anticipation
fear <- subset(new, sentiment=="fear")
new2 <- rbind(anticipation, fear)

q <- ggplot(data=new2,aes(x=date,y=Score, group=sentiment))+ geom_line(aes(color=sentiment))+
  geom_point(aes(color=sentiment))+
  theme(legend.position="right")+
  xlab("Day")+ylab("scores")+ggtitle("Anticipation/Fear sentiments plot - AlJazeera")


q+scale_color_brewer(palette="Spectral")
q+scale_colour_viridis_d(option = "D")
