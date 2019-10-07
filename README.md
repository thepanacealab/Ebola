# Ebola

1. article_scraper.py - Assuming that urls from each news source are accumulated in seperate csv files (ex: all who article urls should be in a csv called who.csv), the article_scraper.py will scrape each article using the urls and store the article's text and title to adjacent columns. The result will be a dataframe containing column headers: ['date', 'url', 'title', 'text']. 
2. article_scraper_translator.py - This script can be used to scrape and translate articles that are not in english.
3. twitter_scraper.py - This script can be used to scrape tweets, using tweet handles instead of urls.
4. all_source_text.csv - Once articles/tweets from all sources have been accumulated, they can be combined in a single document such as has been done in all_source_text.csv

5. source_bing.R - set the path to the all_source_text.csv file and each of the source_bing.R scripts will generate sentiment scores using the bing library for the articles derived from that news source for each given date. 
6. source_nrc.R - this script would calculate sentiment scores for each article based on the nrc library.

7. the R scripts produce a plot for the sentiments per source per date.
