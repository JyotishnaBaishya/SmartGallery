import base64

def encode_text(img_file):
    s= base64.b64encode(img_file).decode('utf-8')
    # print(s)
    return s
