library(ggplot2)
library(syuzhet)
library(dplyr)

news <- read.csv(file="/home/cynthiak/Ebola/all_source_text.csv", header=TRUE, sep=",")

tweet_who<- news$who_text
tweet_moh<- news$moh_text
tweet_moh_twitter<- news$moh_twitter_text
tweet_helen<- news$helen_text
tweet_reuters<- news$reuters_text
tweet_cidrap<- news$cidrap_text
tweet_afp<- news$afp_text
tweet_aljazeera<- news$aljazeera_text
tweet_stat<- news$stat_text

#convert all text to lower case
tweet_who <- tolower(tweet_who)
tweet_moh <- tolower(tweet_moh)
tweet_moh_twitter <- tolower(tweet_moh_twitter)
tweet_helen <- tolower(tweet_helen)
tweet_reuters <- tolower(tweet_reuters)
tweet_cidrap <- tolower(tweet_cidrapo)
tweet_afp <- tolower(tweet_afp)
tweet_aljazeera <- tolower(tweet_aljazeera)
tweet_stat <- tolower(tweet_stat)

# Replace blank space (“rt”)
tweet_who <- gsub("rt", "", tweet_who)
tweet_moh <- gsub("rt", "", tweet_moh)
tweet_moh_twitter <- gsub("rt", "", tweet_moh_twitter)
tweet_helen <- gsub("rt", "", tweet_helen)
tweet_reuters <- gsub("rt", "", tweet_reuters)
tweet_cidrap <- gsub("rt", "", tweet_cidrap)
tweet_afp <- gsub("rt", "", tweet_afp)
tweet_aljazeera <- gsub("rt", "", tweet_aljazeera)
tweet_stat <- gsub("rt", "", tweet_stat)

# Replace @UserName
tweet_who <- gsub("@\\w+", "", tweet_who)
tweet_moh <- gsub("@\\w+", "", tweet_moh)
tweet_moh_twitter <- gsub("@\\w+", "", tweet_moh_twitter)
tweet_helen <- gsub("@\\w+", "", tweet_helen)
tweet_reuters <- gsub("@\\w+", "", tweet_reuters)
tweet_cidrap <- gsub("@\\w+", "", tweet_cidrap)
tweet_afp <- gsub("@\\w+", "", tweet_afp)
tweet_aljazeera <- gsub("@\\w+", "", tweet_aljazeera)
tweet_stat <- gsub("@\\w+", "", tweet_stat)

# Remove punctuation
tweet_who <- gsub("[[:punct:]]", "", tweet_who)
tweet_moh <- gsub("[[:punct:]]", "", tweet_moh)
tweet_moh_twitter <- gsub("[[:punct:]]", "", tweet_moh_twitter)
tweet_helen <- gsub("[[:punct:]]", "", tweet_helen)
tweet_reuters <- gsub("[[:punct:]]", "", tweet_reuters)
tweet_cidrap <- gsub("[[:punct:]]", "", tweet_cidrap)
tweet_afp <- gsub("[[:punct:]]", "", tweet_afp)
tweet_aljazeera <- gsub("[[:punct:]]", "", tweet_aljazeera)
tweet_stat <- gsub("[[:punct:]]", "", tweet_stat)

# Remove links
tweet_who <- gsub("http\\w+", "", tweet_who)
tweet_moh <- gsub("http\\w+", "", tweet_moh)
tweet_moh_twitter <- gsub("http\\w+", "", tweet_moh_twitter)
tweet_helen <- gsub("http\\w+", "", tweet_helen)
tweet_reuters <- gsub("http\\w+", "", tweet_reuters)
tweet_cidrap <- gsub("http\\w+", "", tweet_cidrap)
tweet_afp <- gsub("http\\w+", "", tweet_afp)
tweet_aljazeera <- gsub("http\\w+", "", tweet_aljazeera)
tweet_stat <- gsub("http\\w+", "", tweet_stat)

# Remove tabs
tweet_who <- gsub("[ |\t]{2,}", "", tweet_who)
tweet_moh <- gsub("[ |\t]{2,}", "", tweet_moh)
tweet_moh_twitter <- gsub("[ |\t]{2,}", "", tweet_moh_twitter)
tweet_helen <- gsub("[ |\t]{2,}", "", tweet_helen)
tweet_reuters <- gsub("[ |\t]{2,}", "", tweet_reuters)
tweet_cidrap <- gsub("[ |\t]{2,}", "", tweet_cidrap)
tweet_afp <- gsub("[ |\t]{2,}", "", tweet_afp)
tweet_aljazeera <- gsub("[ |\t]{2,}", "", tweet_aljazeera)
tweet_stat <- gsub("[ |\t]{2,}", "", tweet_stat)

# Remove blank spaces at the beginning
tweet_who <- gsub("^ ", "", tweet_who)
tweet_moh <- gsub("^ ", "", tweet_moh)
tweet_moh_twitter <- gsub("^ ", "", tweet_moh_twitter)
tweet_helen <- gsub("^ ", "", tweet_helen)
tweet_reuters <- gsub("^ ", "", tweet_reuters)
tweet_cidrap <- gsub("^ ", "", tweet_cidrap)
tweet_afp <- gsub("^ ", "", tweet_afp)
tweet_aljazeera <- gsub("^ ", "", tweet_aljazeera)
tweet_stat <- gsub("^ ", "", tweet_stat)

# Remove blank spaces at the end
tweet_who <- gsub(" $", "", tweet_who)
tweet_moh <- gsub(" $", "", tweet_moh)
tweet_moh_twitter <- gsub(" $", "", tweet_moh_twitter)
tweet_helen <- gsub(" $", "", tweet_helen)
tweet_reuters <- gsub(" $", "", tweet_reuters)
tweet_cidrap <- gsub(" $", "", tweet_cidrap)
tweet_afp <- gsub(" $", "", tweet_afp)
tweet_aljazeera <- gsub(" $", "", tweet_aljazeera)
tweet_stat <- gsub(" $", "", tweet_stat)

#getting emotions using in-built function
sentiment_who<-get_nrc_sentiment((tweet_who))
sentiment_moh<-get_nrc_sentiment((tweet_moh))
sentiment_moh_twitter<-get_nrc_sentiment((tweet_moh_twitter))
sentiment_helen<-get_nrc_sentiment((tweet_helen))
sentiment_reuters<-get_nrc_sentiment((tweet_reuters))
sentiment_cidrap<-get_nrc_sentiment((tweet_cidrap))
sentiment_afp<-get_nrc_sentiment((tweet_afp))
sentiment_aljazeera<-get_nrc_sentiment((tweet_aljazeera))
sentiment_stat<-get_nrc_sentiment((tweet_stat))

#calculationg total score for each sentiment
Sentimentscores_who<-data.frame(colSums(sentiment_who[,]))
Sentimentscores_moh<-data.frame(colSums(sentiment_moh[,]))
Sentimentscores_moh_twitter<-data.frame(colSums(sentiment_moh_twitter[,]))
Sentimentscores_helen<-data.frame(colSums(sentiment_helen[,]))
Sentimentscores_reuters<-data.frame(colSums(sentiment_reuters[,]))
Sentimentscores_cidrap<-data.frame(colSums(sentiment_cidrap[,]))
Sentimentscores_afp<-data.frame(colSums(sentiment_afp[,]))
Sentimentscores_aljazeera<-data.frame(colSums(sentiment_aljazeera[,]))
Sentimentscores_stat<-data.frame(colSums(sentiment_stat[,]))


for (row in 1:nrow(news)) {
  date  <- stock[row, "date"]
  
  names(Sentimentscores_who)<-"Score"
  Sentimentscores_who<-cbind("date"=rep(c(date),10), "sentiment"=rownames(Sentimentscores_who),Sentimentscores_who)
  rownames(Sentimentscores_who)<-NULL
  
}
saveRDS(Sentimentscores_who, "who.Rds")
  
#plotting the sentiments with scores
#plotting the sentiments with scores
p <- ggplot(data=Sentimentscores_who,aes(x=date,y=Score, group=sentiment))+ geom_line(aes(color=sentiment))+
  geom_point(aes(color=sentiment))+
  theme(legend.position="right")+
  xlab("Dates")+ylab("scores")+ggtitle("Sentiments of people during Ebola - source WHO")

#p+scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#FF6347", "#228B22", "#008080", "#FFA500", "#800080", "#CCCC00", "#FF69B4"))
p+scale_color_brewer(palette="Paired")  + geom_vline(aes(xintercept = 6)) + geom_vline(aes(xintercept = 14))