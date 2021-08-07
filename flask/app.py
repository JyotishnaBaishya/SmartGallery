from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json
# from utils.textp import keywords
# from utils.v import similarity
# from utils.utils import find_tags
from utils.encode import encode_text
from PIL import Image
from io import BytesIO
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
import os
import tempfile

app=Flask(__name__)

UPLOAD_FOLDER=os.path.join(app.root_path, 'static/images')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

cred=credentials.Certificate('./utils/smart-gallery-2af21-firebase-adminsdk-atefv-b46b85fcb6.json')
firebase_admin.initialize_app(cred,{'storageBucket': 'smart-gallery-2af21.appspot.com'})
db = firestore.client()

@app.route('/', methods=['GET'])
def search():
	key=request.args.get('key')
	res=[]
	if not key:
	    return render_template('search.html', res=res)
		# return jsonify({"Sc": "nokey"})
	d_ref=db.collection(u'pictures/some_user/userid')
	userpics=d_ref.get()
	userpics_dict = [ el.to_dict() for el in userpics ]
		
	# with open("static/tags.csv", 'r') as csvfile:
	# 	csvreader = csv.reader(csvfile)
	# 	fields = next(csvreader)
	url="https://8588690db21a.ngrok.io/similarity/"
	for v in userpics_dict:
		res1=requests.post(url, data=json.dumps({'s1': key, 's2': v['tags']}))
		ress=json.loads(res1.text)
		print(ress)
		sim=ress['sim']
		if sim>0.001:
			res.append((sim,v['image']))
	# 			# res.append(row[0])
	# 		# max_sim= sim(keys, li)
	# 		# if max_sim:
	# 		# 	res.append(max_sim,row[0])
	res.sort(reverse=True)
	resx=[]
	for r in res:
		p, q=r
		print(p)
		resx.append(q)
	return jsonify({"SX": resx})
	# return render_template('search.html', res=userpics_dict)
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
			# image.save(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)))
			# image_byte=Image.open(BytesIO(image))
			# classes=find_tags(image_byte)
			# tags={}
			# tags['bsx']=[]
			# for i in range(0, len(classes[0])):
			# 	tags['bsx'].append(classes[0][i][1])
			bucket=storage.bucket()
			temp=tempfile.NamedTemporaryFile(delete=False)
			image.save(temp.name)
			bucket = storage.bucket()
			blob = bucket.blob(temp.name)
			blob.upload_from_filename(temp.name)
			# Opt : if you want to make public access from the URL
			blob.make_public()
			print("your file url", blob.public_url)
			
			bytearr=temp.read()
			# im=encode_text(bytearr)
			url = "https://8588690db21a.ngrok.io"
			fn=secure_filename(image.filename)
			print(fn)
			files = {'file':bytearr}
			res=requests.post(url, files=files)
			print(res)
			tags=(json.loads(res.text))
			print(tags)
			st=",".join(tags["bsx"])
			# Use the application default credentials
			data={
				u'image':blob.public_url,
				u'tags': st,
			}
			# # Add a new doc in collection 'cities' with ID 'LA'
			db.collection(u'pictures/some_user/userid').add(data)
			temp.close()
			
		return make_response(jsonify({'tags': "okay"}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)