library(RCurl)
library(twitteR)
library(plyr)
library(SentimentAnalysis)
library(NLP)
library(slam)


setup_twitter_oauth(consumer_key, consumer_secret,access_token, access_secret)
searchTerm = 'hackathon'
tweets = searchTwitter(searchTerm, n= 1000)
tweets.text = laply(tweets, function(t)t$getText())
sentiment = analyzeSentiment(tweets.text)
sentimentWords = convertToDirection(sentiment$SentimentGI)
