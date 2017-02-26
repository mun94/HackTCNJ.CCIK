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

# Timeline Input 
min_timeline="2013-01-01"
max_timeline="2017-01-01"


# Geographical Location Input 
geo_input = 'NY'

# Geocode
if (geo_input == ""){
  # Use the searchTwitter function to only get tweets within 50 miles of Los Angeles
  tweets <- searchTwitter(topic_input, n=10000, lang="en", since=min_timeline)
  tweets.matrix <- twListToDF(tweets)
  tweets_timeline.df <- subset(tweets.matrix, created >= as.POSIXct(min_timeline) & created <= as.POSIXct(max_timeline))
  
} else if (!is.null(geo_input)){
  switch(geo_input, 
         # Use the searchTwitter function to only get tweets within 50 miles of the location
         'LA'={
           location = '34.0499,-118.2408,200mi'
         },
         'NJ'={
           location = '40.0583,-74.4057,200mi'
         },
         'NY'={
           location = '40.7128,-74.0059,200mi'
         }
  )
  
  if (!is.null(location)){
    # Run Twitter Search. Format is searchTwitter("Search Terms", n=100, lang="en", geocode="lat,lng", also accepts since and until).
    # Use the searchTwitter function to only get tweets within 50 miles of the location
    #tweets <- searchTwitter(topic_input, n=100, lang="en", geocode=location, since=min_timeline)
    #tweets.matrix <- twListToDF(tweets)
    #tweets_timeline.df <- subset(tweets.matrix, created >= as.POSIXct(min_timeline) & created <= as.POSIXct(max_timeline))
  }
}

#setup_twitter_oauth(consumer_key, consumer_secret,access_token, access_secret)
searchTerm = 'hell'
tweets <- searchTwitter(searchTerm, n=100, geocode = location, since=min_timeline)
tweets_text <- sapply(tweets, function(x) x$getText())
tweets_text_corpus <- Corpus(VectorSource(tweets_text))
tweets_text_corpus <- tm_map(tweets_text_corpus, content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')), mc.cores=1)
sentiment <- analyzeSentiment(tweets_text_corpus)
sentimentWords = convertToDirection(sentiment$SentimentGI)
