library(sentimentr)

news <- read.csv(file="/home/cynthiak/Ebola/all_source_text.csv", header=TRUE, sep=",")
Sentimentscores_who <- read.csv(text="day,month_year,score")

for (row in 1:nrow(news)) {
  curr_date <-toString(news[row, "date"])
  current_date <- strsplit(curr_date, "-")[[1]]
  
  month_year <- paste(current_date[2], current_date[3],sep="_")
  
  text  <- news[row, "helen_text"]
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
  
  sentiment=sentiment_by(text)
  Sentimentscores_who[row,"day"] <- current_date[1]
  Sentimentscores_who[row,"month_year"] <- month_year
  Sentimentscores_who[row, "score"] <- sentiment$ave_sentiment
}

head(Sentimentscores_who)
names(Sentimentscores_who)

agg_sentiment <- aggregate(Sentimentscores_who$score, by=list(date=Sentimentscores_who$month_year), FUN=sum)
names(agg_sentiment)
names(agg_sentiment)[2] <- "score"

level_order <- c("Aug_18", "Sep_18", "Oct_18", "Nov_18", "Dec_18", "Jan_19", "Feb_19", "Mar_19", "Apr_19", "May_19", "Jun_19")

head(agg_sentiment_ordered)

#plotting the sentiments with scores - points
p <- ggplot(data=agg_sentiment_ordered,aes(x=factor(date, level = level_order), y=score))+
  geom_point(aes(color=score))+
  theme(legend.position="right")+
  xlab("Days")+ylab("scores")+ggtitle("Sentiments Bing - source Helen Twitter ")
p

#bar plot
b <-ggplot(data=agg_sentiment_ordered, aes(x=factor(date, level = level_order), y=score)) +
  geom_bar(stat="identity")+
  theme(legend.position="right")+
  xlab("Days")+ylab("scores")+ggtitle("Sentiments Bing - source Helen Twitter ")
b
