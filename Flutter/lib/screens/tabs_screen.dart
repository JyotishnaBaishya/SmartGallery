import 'package:flutter/material.dart';

import './take_pic_screen.dart';
import './view_images.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  SearchBar searchBar;

  final List<Map<String, Object>> _pages = [
    {
      'page': TakePicScreen(),
      'title': 'Smart Gallery IITI',
    },
    {
      'page': ViewImages(),
      'title': 'Your Images',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        backgroundColor: Colors.red,
        actions: [searchBar.getSearchAction(context)]);
  }

  _TabsScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  // final List<Map<String, Object>> _pages = [
  //   {
  //     'page': TakePicScreen(),
  //     'title': 'Smart Gallery IITI',
  //   },
  //   {
  //     'page': ViewImages(),
  //     'title': 'Your Images',
  //   },
  // ];
  // int _selectedPageIndex = 0;

  // void _selectPage(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      // appBar: AppBar(

      //   title: Text(_pages[_selectedPageIndex]['title']),
      //   backgroundColor: Colors.red,
      //   //appBar: searchBar.build(context),
      // ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.image),
            title: Text('Images'),
          ),
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<TabsScreen> {
  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('My Home Page'),
        actions: [searchBar.getSearchAction(context)]);
  }

  _MyHomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: searchBar.build(context));
  }
}
