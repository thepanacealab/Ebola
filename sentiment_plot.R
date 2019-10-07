head(Sentimentscores_who)

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

dfNorm <- as.data.frame(lapply(["Score"], normalize))

head(dfNorm)

new <- subset( new, select = -Score )
new <-cbind(new, "Score"=dfNorm)

head(new)

new$day <- as.factor(new$day)

#plotting the sentiments with scores
p <- ggplot(data=new,aes(x=day,y=Score, group=sentiment))+ geom_line(aes(color=sentiment))+
  geom_point(aes(color=sentiment))+
  theme(legend.position="right")+
  xlab("Days")+ylab("scores")+ggtitle("Sentiments of people during Hurricane Maria Sept 16 to Oct 03, 2017")

#p+scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#FF6347", "#228B22", "#008080", "#FFA500", "#800080", "#CCCC00", "#FF69B4"))
p+scale_color_brewer(palette="Paired")  + geom_vline(aes(xintercept = 6)) + geom_vline(aes(xintercept = 14))
