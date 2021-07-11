import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';
import '../models/picture.dart';
import '../providers/pictures.dart';
import './view_images.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class TakePicScreen extends StatefulWidget {
  static const routeName = '/take-pic';

  @override
  _TakePicScreenState createState() => _TakePicScreenState();
}

class _TakePicScreenState extends State<TakePicScreen> {
  File _takenImage;
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _takenImage = imageFile;
    });

    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    var _imageToStore = Picture(picName: savedImage);
    _storeImage() {
      Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore);
    }

    _storeImage();
  }

  Future<void> _takePicture1() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _takenImage = imageFile;
    });

    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    var _imageToStore = Picture(picName: savedImage);
    _storeImage() {
      Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore);
    }

    _storeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //child: FlatButton.icon(
            //button for gallery
            new FlatButton.icon(
              icon: Icon(
                Icons.photo_album,
                size: 100,
                color: Colors.black,
              ),
              label: Text(''),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture,
            ),
            //child: FlatButton.icon(
            //button for camera
            new FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                size: 100,
                color: Colors.black,
              ),
              label: Text(''),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture1,
            ),
            // ElevatedButton(
            //   child: Text('Open route'),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => SecondRoute()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

// class SecondRoute extends StatelessWidget {
//   SearchBar searchBar;

//   AppBar buildAppBar(BuildContext context) {
//     return new AppBar(
//       title: new Text('My Home Page'),
//       actions: [searchBar.getSearchAction(context)]
//     );
//   }

//   SecondRoute() {
//     searchBar = new SearchBar(
//       inBar: false,
//       setState: setState,
//       onSubmitted: print,
//       buildDefaultAppBar: buildAppBar
//     );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:io';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Image Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Image Demo'),
//         ),
//         body: new Container(
//           color: Colors.grey[200],
//           child:
//               Image.file(new File('/storage/emulated/0/DCIM/Screenshots/IMG_20210709_171743.jpg')),
//           alignment: Alignment.center,
//         ),
//       ),
//     );
//   }
// }
