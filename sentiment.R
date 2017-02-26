library(RCurl)
library(twitteR)
library(plyr)
library(stringr)
library(SentimentAnalysis)
library(NLP)
library(slam)


consumer_key <- ''
consumer_secret <- ''
access_token <- ''
access_secret <- ''
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


#setup_twitter_oauth(consumer_key, consumer_secret,access_token, access_secret)
searchTerm = 'hell'
tweets <- searchTwitter(searchTerm, n=100, geocode = location, since=min_timeline)
tweets_text <- sapply(tweets, function(x) x$getText())
tweets_text_corpus <- Corpus(VectorSource(tweets_text))
tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
sentiment <- analyzeSentiment(tweets_text_corpus)
sentimentWords = convertToDirection(sentiment$SentimentGI)
