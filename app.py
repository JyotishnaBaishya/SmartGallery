from flask import Flask, render_template, request, url_for, jsonify, make_response
from werkzeug.utils import secure_filename
import csv, os, requests, json

app=Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def upload():
	if request.method=="POST":
		image=request.files.get('image')
		if not image:
			return render_template('form.html', msg="please upload a file")
		UPLOAD_FOLDER=os.path.join(app.root_path, 'uploads/images')
		image.save(os.path.join(UPLOAD_FOLDER, secure_filename(image.filename)))
		url = "https://d79ce85554a0.ngrok.io"
		fn=secure_filename(image.filename)
		print(fn)
		files = {'file': open('uploads/images/'+fn, 'rb')}
		res=requests.post(url, files=files)
		tags=(json.loads(res.text))
		print(tags)
		row=["uploads/images"+fn, ",".join(tags["bsx"])]
		with open("uploads/tags.csv", 'a+') as csvfile:
			csvwriter = csv.writer(csvfile)
			csvwriter.writerow(row)
		return make_response(jsonify({'tags': tags["bsx"]}), 200)
	return render_template('form.html', msg="")


if __name__ == '__main__':
	app.run(debug=True)