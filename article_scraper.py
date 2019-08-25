# -*- coding: utf-8 -*-
"""
Created on Tue Jul  9 08:38:07 2019

@author: KhanC
"""

from newspaper import Article 
import pandas as pd 

data = pd.read_csv("cidrap.csv") 

df = pd.DataFrame(data, columns = ['date', 'url', 'title', 'text'])

for i in range(len(df)):
    if pd.notnull(df['url'][i]) and pd.notna(df['url'][i]):
        url = df['url'][i]
        url = url.split(" ")[0]
        print(url)
        
        try:
            #A new article from WHO
            who_article = Article(url, language="en") # en for English 
            #To download the article 
            who_article.download() 
    
            #To parse the article 
            who_article.parse() 
    
            #To extract title 
            print("Article's Title:") 
            df.loc[i,'title'] = who_article.title
            print(df['title'][i]) 
            print("\n") 
    
            #To extract text 
            print("Article's Text:") 
            text = who_article.text
            if not text.strip():
                df.loc[i,'text'] = "no result found"
            else:
                df.loc[i,'text'] = text
            print("\n") 
        except:
            df.loc[i,'text'] = "no result found"
        
    else:
        df.loc[i,'text'] = "no result found"


df.to_csv(r'cidrap_scraped.csv')


