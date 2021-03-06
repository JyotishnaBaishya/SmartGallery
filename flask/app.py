from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json
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
	userid=request.args.get('email')
	res=[]
	if not key:
		return jsonify({"Sc": "nokey"})
	d_ref=db.collection(u'pictures/some_user/'+userid)
	userpics=d_ref.get()
	userpics_dict = [ el.to_dict() for el in userpics ]
	url="https://8588690db21a.ngrok.io/similarity/"
	for v in userpics_dict:
		res1=requests.post(url, data=json.dumps({'s1': key, 's2': v['tags']}))
		ress=json.loads(res1.text)
		print(ress)
		sim=ress['sim']
		if sim>0.5:
			res.append((sim,v['image']))
	res.sort(reverse=True)
	resx=[]
	for r in res:
		p, q=r
		print(p)
		resx.append(q)
	return jsonify({"SX": resx})
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

		for image in images:
			print(image.filename)
			bucket=storage.bucket()
			temp=tempfile.NamedTemporaryFile(delete=False)
			image.save(temp.name)
			bucket = storage.bucket()
			blob = bucket.blob(temp.name)
			blob.upload_from_filename(temp.name)
			blob.make_public()
			print("your file url", blob.public_url)

			bytearr=temp.read()
			url = "https://8588690db21a.ngrok.io"
			fn=secure_filename(image.filename)
			print(fn)
			files = {'file':bytearr}
			res=requests.post(url, files=files)
			print(res)
			tags=(json.loads(res.text))
			print(tags)
			st=",".join(tags["bsx"])
			data={
				u'image':blob.public_url,
				u'tags': st,
			}
			db.collection(u'pictures/some_user/'+userid).add(data)
			temp.close()

		return make_response(jsonify({'tags': "okay"}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)