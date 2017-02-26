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

avg_sentiment = list()
tot_num_tweet = 0
days_week = 7
# It will look at whether the term that people (in a specific region) used is related to a negative or positive sentence on each day.
for(i in 1:days_week){  # i is the current day
  day_index = i + until_timeline_d
  begin_day_str = formatC(day_index, width=2, flag="0")
  until_d = paste("2017-02", begin_day_str, sep="-")
  print(until_d)
  tweets <- searchTwitter("hungry", n=100, since=long_time_ago, until=until_d) # API Call on each day
  if (length(tweets) != 0){
    tweets.matrix <- twListToDF(tweets)
    tweets_text <- sapply(tweets, function(x) x$getText())
    tweets_text_corpus <- Corpus(VectorSource(tweets_text))
    tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
    sentiment <- analyzeSentiment(tweets_text_corpus)
    avg_sentiment[i] = mean(sentiment[,2]) # Find the avg sentiment of each day
    print(avg_sentiment[i])
    tot_num_tweet = tot_num_tweet + length(tweets_text)
  } else {
    avg_sentiment[i] = 0
    print(avg_sentiment[i])
  }
  print(tot_num_tweet)
}

# Graph
plot(avg_sentiment[1:7], type="o", col="blue", ylim=c(-1,1), axes=FALSE, ann=FALSE)
# Make x axis using Day1 to Day7
axis(1, las=1, at=1:7, lab=c("Day 1", "Day 2", "Day 3", "Day 4", "Day 5", "Day 6", "Day 7"))
# Make y axis with horizontal labels that display -1, 0, and 1 as -, neural, and +, repsectively.
axis(2, las=1, at=-1:1, lab=c("Negatve", "Neutral", "Positive"))
# Create box around plot
box()


