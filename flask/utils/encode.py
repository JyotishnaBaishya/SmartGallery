import base64
from PIL import image

def encode_text(image_path):
    with open(image_path, "rb") as img_file:
        s= base64.b64encode(img_file.read()).decode('utf-8')
        print(s)
        return s
