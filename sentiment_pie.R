R.versionrm(list = ls())
cat("\014") 

library(RCurl)
library(twitteR)
library(plyr)
library(stringr)
library(SentimentAnalysis)
library(NLP)
library(slam)
library(tm)
library(tmap)

consumer_key <- '7Yo0cd9uv5gHOC8hhCCR8WvPY'
consumer_secret <- 'CVGgRLbisnAKpFbLHeniPPo2t8besHDwB71FaXLQ8rcu6OrPbR'
access_token <- '155964171-vUHJU34zk2SzlP5loND2VMIIZ2oCN7vfRrDEM8lL'
access_secret <- 'UedyPjCB114sQvURtGT0vhHo7qwA9iyUDfPjDccx3pqXo'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


# Look at how many people use the topic daily.
location = '34.0499,-118.2408,200mi' # The location of LA
long_time_ago="2016-01-01"
until_timeline="2017-02-19"
until_timeline_num <- strsplit(until_timeline, "\\-")[[1]]
until_timeline_v <- unique(tolower(until_timeline_num))
until_timeline_yr <- as.numeric(until_timeline_v[1])
until_timeline_m <- as.numeric(until_timeline_v[2])
until_timeline_d <- as.numeric(until_timeline_v[3])

ratio_sentiment = list()
tot_num_tweet = 0
# It will look at whether the term that people (in a specific region) used is related to a negative or positive sentence on each day.
days_week = 7
for(i in 1:days_week){
  day_index = i + until_timeline_d
  begin_day_str = formatC(day_index, width=2, flag="0")
  until_d = paste("2017-02", begin_day_str, sep="-")
  print(until_d)
  tweets <- searchTwitter("hungry", n=100, since=long_time_ago, until=until_d)
  if (length(tweets) != 0){
    tweets.matrix <- twListToDF(tweets)
    tweets_text <- sapply(tweets, function(x) x$getText())
    tweets_text_corpus <- Corpus(VectorSource(tweets_text))
    tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
    sentiment <- analyzeSentiment(tweets_text_corpus)
    # Find the ratio of the sentiment of each day
    ratio_sentiment <- c(ratio_sentiment, length(sentiment[,2][sentiment[,2]<0 & !is.na(sentiment[,2])]) , 
                           length(sentiment[,2][sentiment[,2]>0 & !is.na(sentiment[,2])]) ,  
                           length(sentiment[,2][sentiment[,2]==0 & !is.na(sentiment[,2])]) )
    print(ratio_sentiment)
    tot_num_tweet = tot_num_tweet + length(tweets_text)
  } else {
    ratio_sentiment = c(ratio_sentiment, 0, 0, 0)
    print(ratio_sentiment)
  }
  print(tot_num_tweet)
}


# Pie Chart
par(mfrow=c(3,4))
ratio_sentiment_num <- as.numeric(unlist(ratio_sentiment))
pie(ratio_sentiment_num[1:3], main="Sentiment Pie Day 1", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[4:6], main="Sentiment Pie Day 2", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[7:9], main="Sentiment Pie Day 3", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[10:12], main="Sentiment Pie Day 4", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[13:15], main="Sentiment Pie Day 5", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[16:18], main="Sentiment Pie Day 6", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
pie(ratio_sentiment_num[19:21], main="Sentiment Pie Day 7", col=rainbow(3), labels=c("Negative", "Positive","Neutral"))
