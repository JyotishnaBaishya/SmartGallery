from gensim.models import Word2Vec ,KeyedVectors



path="dataset/GoogleNews-vectors-negative300.bin"
model=KeyedVectors.load_word2vec_format(path,binary= True)
model.init_sims(replace=True)



model.save("word2vec.model")