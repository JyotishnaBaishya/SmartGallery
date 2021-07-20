from gensim.models  import KeyedVectors

from textp import keywords
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

from collections import Counter
import itertools
model=KeyedVectors.load("word2vec.model",mmap='r')
print(model.vector_size)
def map_word_frequency(document):
    return Counter(itertools.chain(*document))

def get_sif_feature_vectors(sentence1, sentence2, word_emb_model=model):
    sentence1 = [token for token in sentence1.split() if token in word_emb_model.index_to_key]
    sentence2 = [token for token in sentence2.split() if token in word_emb_model.index_to_key]
    word_counts = map_word_frequency((sentence1 + sentence2))
    embedding_size = 300 # size of vectore in word embeddings
    a = 0.001
    sentence_set=[]
    for sentence in [sentence1, sentence2]:
        vs = np.zeros(embedding_size)
        sentence_length = len(sentence)
        for word in sentence:
            a_value = a / (a + word_counts[word]) # smooth inverse frequency, SIF
            vs = np.add(vs, np.multiply(a_value, word_emb_model[word])) # vs += sif * word_vector
        vs = np.divide(vs, sentence_length) # weighted average
        sentence_set.append(vs)
    return sentence_set

def get_cosine_similarity(feature_vec_1, feature_vec_2):
    return cosine_similarity(feature_vec_1.reshape(1, -1), feature_vec_2.reshape(1, -1))[0][0]
def similarity(s1, s2):
    s1=' '.join(map(str, keywords(s1)))
    s2=' '.join(map(str, keywords(s2)))
    print(s1)
    print(s2)
    senset=get_sif_feature_vectors(s1, s2)
    return get_cosine_similarity(senset[0], senset[1])

