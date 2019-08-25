# -*- coding: utf-8 -*-
"""
Created on Tue Jul  9 17:53:06 2019

@author: KhanC
"""

from newspaper import Article 
from googletrans import Translator
import pandas as pd 

translator = Translator()
data = pd.read_csv("moh.csv") 

df = pd.DataFrame(data, columns = ['date', 'url', 'title', 'text'])

for i in range(len(df)):
    if pd.notnull(df['url'][i]) and pd.notna(df['url'][i]):
        url = df['url'][i]
        url = url.split(" ")[0]
        print(url)
        
        try:
            #A new article from WHO
            who_article = Article(url, language="es") # en for English 
            #To download the article 
            who_article.download() 
    
            #To parse the article 
            who_article.parse() 
    
            #To extract title 
            print("Article's Title:") 
            title = translator.translate(who_article.title).text
            df.loc[i,'title'] = title
            print(df.loc[i,'title'])
            
            #To extract text
            print("Article's Text:")
            text = translator.translate(who_article.text).text
            if not text.strip():
                df.loc[i,'text'] = "no result found"
            else:
                df.loc[i,'text'] = text
            print("\n") 
        except:
            df.loc[i,'text'] = "no result found"
        
    else:
        df.loc[i,'text'] = "no result found"


df.to_csv(r'moh_scraped.csv')