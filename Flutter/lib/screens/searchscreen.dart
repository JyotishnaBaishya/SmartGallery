import 'package:camera_gallery/res/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  late List searchlist = widget.searchlist;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
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
            return ImageGrid(searchlist: this.searchlist);
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