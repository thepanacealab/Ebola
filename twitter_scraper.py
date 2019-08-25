import tweepy
import json
import pandas as pd
from googletrans import Translator

with open('api_keys.json') as f:
    keys = json.load(f)

auth = tweepy.OAuthHandler(keys['consumer_key'], keys['consumer_secret'])
auth.set_access_token(keys['access_token'], keys['access_token_secret'])
api = tweepy.API(auth)

translator = Translator()
data = pd.read_csv("moh_twitter.csv") 

df = pd.DataFrame(data, columns = ['date', 'url', 'title', 'text'])

for i in range(len(df)):
    if pd.notnull(df['url'][i]) and pd.notna(df['url'][i]):
        url = df['url'][i]
        
        url = url.split(" ")[0]
        print(url)
        
        try:
            tweetid = [url.split("/")[-1]]
            print(tweetid)
            tweet = api.statuses_lookup(tweetid)[0].text
            
            whitelist = set('1234567890abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ')
            tweet = ''.join(filter(whitelist.__contains__, tweet))
            tweet = translator.translate(tweet).text
        
            df.loc[i,'title'] = tweetid
            
            #To extract text 
            print("Article's Text:") 
            #text = translator.translate(tweet).text
            text = tweet
            if not text.strip():
                df.loc[i,'text'] = "no result found"
            else:
                df.loc[i,'text'] = text
                print("\n") 
        except:
            df.loc[i,'text'] = "no result found"
        
    else:
        df.loc[i,'text'] = "no result found"

df.to_csv(r'moh_tweet_scraped.csv')
