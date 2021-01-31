import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:transparent_image/transparent_image.dart';
import 'fragments/gospel_fragment.dart';
import 'fragments/home_page_fragment.dart';
import '../resources/consts.dart';
import 'package:logger/logger.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _pageViewController = PageController();
  int _activePage = 0;
  ConnectivityResult connectionResult;
  var _subscription;
  var logger = Logger();

  final _navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: HOME_PAGE_TEXT,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mood),
      label: GOSPEL_PAGE_TEXT,
    )
  ];

  final List<Widget> _fragments = [
    HomePageFragment(),
    GospelFragment(),
  ];

  @override
  void initState() {
    super.initState();
    logger.d("initState");
    WidgetsBinding.instance.addObserver(this);
    Connectivity().checkConnectivity().then((val) => connectionResult = val);
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      logger.d("internet state changed state=" + result.toString());
      setState(() {
        connectionResult = result;
      });
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      connectionResult = await (Connectivity().checkConnectivity());
      logger.d(
          "didChangeAppLifecycleState resume " + connectionResult.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black26
                : Colors.white,
        title: Text(_navigationItems[_activePage].label),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems,
        currentIndex: _activePage,
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black26
                : Colors.white,
        onTap: (index) {
          _pageViewController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        },
      ),
      body: connectionResult == ConnectivityResult.none
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(NO_INTERNET_ASSET_PATH),
                    height: 150,
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
                  Text(NO_INTERNET_TEXT,
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            )
          : Center(
              child: Container(
                width: screenWidth > MAX_SCREEN_WIDTH
                    ? MAX_SCREEN_WIDTH
                    : screenWidth,
                child: BlocProvider(
                  create: (BuildContext context) =>
                      UserDataBloc()..add(InitUserDataEvent()),
                  child: PageView(
                    controller: _pageViewController,
                    children: _fragments,
                    onPageChanged: (index) {
                      setState(() {
                        _activePage = index;
                      });
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
