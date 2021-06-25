import re
from nltk.corpus import stopwords
from nltk.stem.snowball import  SnowballStemmer
from nltk import word_tokenize
import csv

def normalize_text(text):
    stopwords_set= set(stopwords.words('english'))
    stemmer = SnowballStemmer('english')
    text = text.replace('\n',' ').lower().strip()
    text = re.sub("[^a-zA-Z]+", " ", text).split()
    text = ' '.join(stemmer.stem(i) for i in text)
    stemmed = ' '.join([word for word in text.split() if word not in stopwords_set])
    return(stemmed)

def find_topic(t):
    t= normalize_text(t)
    words=word_tokenize(t)
    print(words)

find_topic("he is Eating cake cookie")    