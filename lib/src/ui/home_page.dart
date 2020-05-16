import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fragments/home_page_fragment.dart';
import 'fragments/about_fragment.dart';
import '../resources/consts.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem(HOME_PAGE_TEXT, Icons.home),
    DrawerItem(ABOUT_TEXT, Icons.info),
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePageFragment(_changeFragment);
      case 1:
        return AboutFragment();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return WillPopScope(
      onWillPop: _onWellPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.drawerItems[_selectedDrawerIndex].title),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  child: Center(
                      child: Text(
                    TITLE_TEXT,
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
              Column(children: drawerOptions)
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  Future<bool> _onWellPop() {
    if (_selectedDrawerIndex == 0) {
      SystemNavigator.pop();
    } else {
      setState(() {
        _selectedDrawerIndex = 0;
      });
    }

    return new Future(() => false);
  }

  void _changeFragment(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
  }
}
