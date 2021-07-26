import re, nltk
nltk.download("stopwords")
nltk.download("punkt")
nltk.download("wordnet")
from nltk.corpus import stopwords, wordnet as wn
from nltk.stem import PorterStemmer, WordNetLemmatizer
from nltk import word_tokenize
import csv

def normalize_text(text):
    lem=WordNetLemmatizer()
    stopwords_set= set(stopwords.words('english'))
    text = text.replace('\n',' ').lower().strip()
    text = re.sub("[^a-zA-Z]+", " ", text).split()
    text = ' '.join(lem.lemmatize(i) for i in text)
    lemmated = ' '.join([word for word in text.split() if word not in stopwords_set])
    return(lemmated)

def keywords(t):
    t= normalize_text(t)
    words=word_tokenize(t)
    print(words)
    return words

# def sim(word1, word2):
#     max_sim=0
#     for net1 in wn.synsets(word1):
#         for net2 in wn.synsets(word2):
#             try:
#                 lch = net1.lch_similarity(net2)
#             except:
#                 continue
#             # The value to compare the LCH to was found empirically.
#             # (The value is very application dependent. Experiment!)
#             if lch >= lch_threshold:
#                 max_sim=max(max_sim,lch)
#     return max_sim