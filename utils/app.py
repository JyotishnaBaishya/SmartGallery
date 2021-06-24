from colabcode import ColabCode
from fastapi import FastAPI, File, UploadFile
from utils import tags
from PIL import Image
from io import BytesIO

app=FastAPI()

@app.post("/")
async def index(file: UploadFile = File(...)):
  file=await file.read()
  image = Image.open(BytesIO(file))
  classes=tags(image)
  print(classes)
  res=[]
  for i in range(0, len(classes[0])):
    res.append(classes[0][i][1])
  print(res)
  return {"bsx": res}

server=ColabCode(port=10000, code=False)
server.run_app(app=app)
