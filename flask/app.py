from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json
# from utils.textp import keywords
# from utils.v import similarity
# from utils.utils import find_tags
from utils.encode import encode_text
from PIL import Image
from io import BytesIO
# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore

app=Flask(__name__)

UPLOAD_FOLDER=os.path.join(app.root_path, 'static/images')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods=['GET'])
def search():
	key=request.args.get('key')
	res=[]
	if not key:
	    return render_template('search.html', res=res)
		# return jsonify({"Sc": "nokey"})

	with open("static/tags.csv", 'r') as csvfile:
		csvreader = csv.reader(csvfile)
		fields = next(csvreader)
		url="https://f679eeaaf26c.ngrok.io/similarity/"
		for row in csvreader:
			res1=requests.post(url, data=json.dumps({'s1': key, 's2': row[1]}))
			ress=json.loads(res1.text)
			print(ress)
			sim=ress['sim']
			if sim>0.001:
				res.append((sim, row[0]))
				# res.append(row[0])
			# max_sim= sim(keys, li)
			# if max_sim:
			# 	res.append(max_sim,row[0])
		res.sort(reverse=True)
		resx=[]
		for r in res:
			p, q=r
			print(p)
			resx.append(q)
	return jsonify({"SX": resx})
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
		# cred=credentials.Certificate('flask/utils/google-services.json')
		# firebase_admin.initialize_app(cred)
		# db = firestore.client()
		for image in images:
			print(image.filename)
			# image.save(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)))
			# image_byte=Image.open(BytesIO(image))
			# classes=find_tags(image_byte)
			# tags={}
			# tags['bsx']=[]
			# for i in range(0, len(classes[0])):
			# 	tags['bsx'].append(classes[0][i][1])
			bytearr=image.read()
			im=encode_text(bytearr)
			url = "https://f679eeaaf26c.ngrok.io"
			fn=secure_filename(image.filename)
			print(fn)
			files = {'file': bytearr}
			res=requests.post(url, files=files)
			print(res)
			tags=(json.loads(res.text))
			print(tags)
			st=",".join(tags["bsx"])
			# Use the application default credentials
			# data={
			# 	u'image': im,
			# 	u'tags': st,
			# }
			# # Add a new doc in collection 'cities' with ID 'LA'
			# db.collection(u'pictures').document(u'some_user').set(data)
			with open("static/tags.csv", 'a+', newline='') as csvfile:
				csvwriter = csv.writer(csvfile)
				csvwriter.writerow([im, st])
		return make_response(jsonify({'tags': "okay"}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)