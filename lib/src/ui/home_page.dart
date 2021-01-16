import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fragments/gospel_fragment.dart';
import 'fragments/home_page_fragment.dart';
import '../resources/consts.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: HOME_PAGE_TEXT,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mood),
      label: GOSPEL_PAGE_TEXT,
    )
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _fragments = [
    HomePageFragment(),
    GospelFragment(),
  ];

  _getItemWidget(int pos) {
    return _fragments[pos];
  }

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWellPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.black26
                  : Colors.white,
          title: Text(widget.navigationItems[_selectedIndex].label),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: widget.navigationItems,
          currentIndex: _selectedIndex,
          backgroundColor:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.black26
                  : Colors.white,
          onTap: _onSelectItem,
        ),
        body: Center(
          child: Container(
            width:
                screenWidth > MAX_SCREEN_WIDTH ? MAX_SCREEN_WIDTH : screenWidth,
            child: _getItemWidget(_selectedIndex),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWellPop() {
    if (_selectedIndex == 0) {
      SystemNavigator.pop();
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }

    return new Future(() => false);
  }
}
