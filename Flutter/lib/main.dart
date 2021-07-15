// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import './screens/take_pic_screen.dart';
// import './screens/tabs_screen.dart';
// import './providers/pictures.dart';
// import './screens/view_images.dart';
// //import 'package:flutter_search_bar/flutter_search_bar.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<Pictures>(create: (_) => Pictures()),
//       ],
//       child: Container(
//         child: MaterialApp(
//           title: 'Camera and Gallery tutorial',
//           theme: ThemeData(
//             accentColor: Colors.red,
//             fontFamily: 'Lato',
//             textTheme: ThemeData.light().textTheme.copyWith(
//                   title: TextStyle(
//                     fontSize: 20,
//                     fontFamily: 'Lato',
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//           ),
//           routes: {
//             '/': (ctx) => TabsScreen(),
//             TakePicScreen.routeName: (ctx) => TakePicScreen(),
//             ViewImages.routeName: (ctx) => ViewImages(),
//           },
//         ),
//       ),
//     );
//   }
// }

// class FirstRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('First Route'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Open route'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SecondRoute()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class SecondRoute extends StatelessWidget {
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
//           child: Image.file(new File(
//               '/storage/emulated/0/DCIM/Screenshots/IMG_20210709_171743.jpg')),
//           alignment: Alignment.center,
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

final Directory _photoDir = new Directory('/storage/emulated/0/Download');

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageCapture(),
    );
  }
}

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
    SearchBar searchBar;
    List imageList;
    AppBar buildAppBar(BuildContext context) {
      return new AppBar(
          backgroundColor: Colors.red,
          actions: [searchBar.getSearchAction(context)]);
  }
  Future<String> uploadImage(images, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    images.forEach((file) async{
      request.files.add(await http.MultipartFile.fromPath(file.toString(), file));
    });
    http.Response response = await http.Response.fromStream(await request.send());
    return response.body;
  }
   _ImageCaptureState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: FutureBuilder(
          builder: (context, status) {
          this.imageList= _photoDir
          .listSync(recursive: true)
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpeg"))
          .toList(growable: false);
            return ImageGrid(imageList: this.imageList);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          var url="http://127.0.0.1:5000/upload";
          var res = await uploadImage(imageList, url);
          print(res);
        }
      ,
      child: Icon(Icons.add_a_photo_outlined)),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List imageList;

  const ImageGrid({Key key, this.imageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var refreshGridView;
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.6),
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
                  return Text(
                    name
                  );
                }))
                    .then((refreshGridView) {
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
