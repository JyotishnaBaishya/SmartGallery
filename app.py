from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json
from utils.cleantext import keywords
from utils.utils import find_tags
from PIL import Image
from io import BytesIO

app=Flask(__name__)

UPLOAD_FOLDER=os.path.join(app.root_path, 'static/images')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods=['GET'])
def search():
	key=request.args.get('key')
	if not key:
		return render_template('search.html')
	keys=keywords(key)
	if keys:
		keys=set(keys)
	res=[]
	with open("static/tags.csv", 'r') as csvfile:
		csvreader = csv.reader(csvfile)
		fields = next(csvreader)
		for row in csvreader:
			li=keywords(row[1])
			li=set(li)
			if keys & li:
				res.append(row[0])
	return render_template('search.html', res=res)
@app.route('/upload', methods=['GET', 'POST'])
def upload():
	if request.method=="POST":
		image=request.files.get('image')
		if not image:
			return render_template('form.html', msg="please upload a file")
		image.save(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)))
		image_pil= image.read()
		image_byte = Image.open(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)), mode='r')
		classes=find_tags(image_byte)
		tags={}
		tags['bsx']=[]
		for i in range(0, len(classes[0])):
			tags['bsx'].append(classes[0][i][1])
		# url = "https://e26fcd3cca2a.ngrok.io"
		fn=secure_filename(image.filename)
		# print(fn)
		# files = {'file': open('static/images/'+fn, 'rb')}
		# res=requests.post(url, files=files)
		# tags=(json.loads(res.text))
		# print(tags)
		row=["images/"+fn, ",".join(tags["bsx"])]
		with open("static/tags.csv", 'a+') as csvfile:
			csvwriter = csv.writer(csvfile)
			csvwriter.writerow(row)
		return make_response(jsonify({'tags': tags["bsx"]}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)