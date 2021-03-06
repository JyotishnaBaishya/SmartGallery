import 'dart:io';
import 'package:camera_gallery/res/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera_gallery/screens/searchscreen.dart';

final Directory _photoDir = new Directory('/storage/emulated/0/SmartGallery');

class ImageCapture extends StatefulWidget {
  const ImageCapture({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  late SearchBar searchBar;
  late List imageList;
  late User user = widget._user;
  late Map<String, dynamic> fle;
  late List imagesupload;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title: Image.asset(
          'assets/images/appbar_logo.png',
          fit: BoxFit.contain,
          height: 80,
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  Future<String> uploadImage(images, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['email'] = this.user.email;
    int i = 0;
    images.forEach((file) async {
      request.files
          .add(await http.MultipartFile.fromPath(file.toString(), file));
    });
    print(request.files);

    http.Response response =
        await http.Response.fromStream(await request.send());
    return response.body;
  }

  Future<String> search(key) async {
    var params = {
      'key': key,
      'email': user.email,
    };
    var res =
        await http.get(Uri.https("smartgalleryapi.herokuapp.com", '/', params));
    print(res.body);
    return res.body;
  }

  void onSubmitted(String keyword) async {
    var res = await search(keyword);
    print(res);
    var values = json.decode(res);
    late List searchList;
    searchList = values["SX"];
    print(searchList);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Search(
          user: user,
          searchlist: searchList,
        ),
      ),
    );
  }

  _ImageCaptureState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar);
  }
  @override
  void initState() {
    user = widget._user;
    imagesupload = ['init'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: FutureBuilder(
          builder: (context, status) {
            this.imageList = _photoDir
                .listSync(recursive: true)
                .map((item) => item.path)
                .where((item) => item.endsWith(".jpg"))
                .toList(growable: false);
            return ImageGrid(imageList: this.imageList);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var url = "https://smartgalleryapi.herokuapp.com/upload";
            var res = await uploadImage(this.imageList, url);
            print(res);
          },
          child: Icon(Icons.add_a_photo_outlined)),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List imageList;

  const ImageGrid({required this.imageList});

  @override
  Widget build(BuildContext context) {
    var refreshGridView;
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 4.6 / 4.0),
      itemBuilder: (context, index) {
        File file = new File(imageList[index]);
        String name = file.path;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => {
                refreshGridView = Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Text(name);
                })).then((refreshGridView) {
                  if (refreshGridView != null) {
                    build(context);
                  }
                }).catchError((er) {
                  print(er);
                }),
              },
              child: Padding(
                padding: new EdgeInsets.all(4.0),
                child: Image.file(
                  File(imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}




