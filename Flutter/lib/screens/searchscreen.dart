import 'dart:io';
import 'package:camera_gallery/res/custom_colors.dart';
import 'package:camera_gallery/screens/signinscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera_gallery/providers/social_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'dart:convert';
// import 'screens/signinscreen.dart';
// import 'providers/social_auth.dart';
// import 'widgets/google_sign_in_button.dart';

// final Directory _photoDir = new Directory('/storage/emulated/0/Download');

class Search extends StatefulWidget {
  const Search({Key? key, required User user, required this.searchlist})
      : _user = user,
        super(key: key);
  final List searchlist;
  final User _user;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late SearchBar searchBar;
  // late List<Uint8List> imageList;
  late List searchlist = widget.searchlist;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        // onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        //   },
        backgroundColor: CustomColors.firebaseNavy,
        title: Text("Search Result"));
  }

  @override
  void initState() {
    searchlist = widget.searchlist;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: FutureBuilder(
          builder: (context, status) {
            // if (this.searchList == null) {
            // setState(() {
            //   this.searchlist.map(
            //       (item) => {this.imageList.add(Base64Codec().decode(item))});
            // });

            return ImageGrid(searchlist: this.searchlist);
            // }
            // this.imageList = _photoDir
            //     .listSync(recursive: true)
            //     .map((item) => item.path)
            //     .where((item) => item.endsWith(".jpeg"))
            //     .toList(growable: false);
            // return ImageGrid(imageList: this.searchList);
          },
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final List searchlist;

  const ImageGrid({required this.searchlist});

  @override
  Widget build(BuildContext context) {
    var refreshGridView;
    return GridView.builder(
      itemCount: searchlist.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 4.6 / 4.0),
      itemBuilder: (context, index) {
        // File file = new File(imageList[index]);
        // String name = file.path;
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
                  return Text('Refresh');
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
                child: Image.network(searchlist[index], fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }
}

//to be returned
// class ImageGrid2 extends StatelessWidget {
//   final List imageList2;
//   @override
//   // TODO: implement key

//   const ImageGrid2({required this.imageList2});

//   @override
//   Widget build(BuildContext context) {
//     var refreshGridView;
//     print(imageList2);
//     return GridView.builder(
//       itemCount: imageList2.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1, childAspectRatio: 5.0 / 4.0),
//       itemBuilder: (context, index) {
//         File file = new File(imageList2[index]);
//         String name = file.path;
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: InkWell(
//               onTap: () => {
//                 refreshGridView = Navigator.push(context,
//                     MaterialPageRoute(builder: (context) {
//                   return Text(name);
//                 })).then((refreshGridView) {
//                   if (refreshGridView != null) {
//                     build(context);
//                   }
//                 }).catchError((er) {
//                   print(er);
//                 }),
//               },
//               child: Padding(
//                 padding: new EdgeInsets.all(4.0),
//                 child: Image.network(
//                   imageList2[index],
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

//Uint8List bytes = Base64Codec().decode(_base64);