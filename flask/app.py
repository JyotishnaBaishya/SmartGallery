from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json
from utils.textp import keywords
from utils.v import similarity
# from utils.utils import find_tags
from PIL import Image
from io import BytesIO

app=Flask(__name__)

UPLOAD_FOLDER=os.path.join(app.root_path, 'static/images')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods=['GET'])
def search():
	key=request.args.get('key')
	if not key:
		return jsonify({"Sc": "nokey"})
	res=[]
	with open("static/tags.csv", 'r') as csvfile:
		csvreader = csv.reader(csvfile)
		fields = next(csvreader)
		for row in csvreader:
			sim=similarity(key, row[1])
			if sim>0.001:
				res.append(sim, row[1])
				res.sort()
			# max_sim= sim(keys, li)
			# if max_sim:
			# 	res.append(max_sim,row[0])
			# 	res.sort()
	return jsonify({"SX": res})
	# return render_template('search.html', res=res)
@app.route('/upload', methods=['GET', 'POST'])
def upload():
	if request.method=="POST":
		print("jskdj")
		images=[]
		for x in request.files:
			images.append(request.files[x])
		if not images:
			print("xyz")
			return "dsjbks"
		print(images)
		# restx={}
		for image in images:
			print(image.filename)
			image.save(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)))
			# image_byte=Image.open(BytesIO(image))
			# classes=find_tags(image_byte)
			# tags={}
			# tags['bsx']=[]
			# for i in range(0, len(classes[0])):
			# 	tags['bsx'].append(classes[0][i][1])
			url = "https://b23474af9b59.ngrok.io"
			fn=secure_filename(image.filename)
			print(fn)
			files = {'file': open('static/images/'+fn, 'rb')}
			res=requests.post(url, files=files)
			print(res)
			tags=(json.loads(res.text))
			print(tags)
			row=["/storage/emulated/0/Download/"+image.filename, ",".join(tags["bsx"])]
			# restx[fn]=tags["bsx"]
			with open("static/tags.csv", 'w', newline='') as csvfile:
				csvwriter = csv.writer(csvfile)
				csvwriter.writerow(row)
		return make_response(jsonify({'tags': "okay"}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)