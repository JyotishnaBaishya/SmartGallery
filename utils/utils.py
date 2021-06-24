from tensorflow.keras.applications.vgg19 import VGG19
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.vgg19 import preprocess_input, decode_predictions
from tensorflow.keras.models import Model
import numpy as np

def tags(image):
  model=VGG19()
  image=np.asarray(image.resize((224, 224)))[..., :3]
  image=np.expand_dims(image, 0)
  image=preprocess_input(image)
  x=model.predict(image)
  classes=decode_predictions(x)
  return classes