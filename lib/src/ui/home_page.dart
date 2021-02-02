import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:sharegospel/src/ui/dialogs/dialogs_helper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'fragments/gospel_fragment.dart';
import 'fragments/home_page_fragment.dart';
import '../resources/consts.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';

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
  var _logger = Logger();

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.homePage.tr();
      case 1:
        return LocaleKeys.gospelPage.tr();
    }

    return "";
  }

  final List<Widget> _fragments = [
    HomePageFragment(),
    GospelFragment(),
  ];

  @override
  void initState() {
    super.initState();
    _logger.d("initState");
    WidgetsBinding.instance.addObserver(this);
    Connectivity().checkConnectivity().then((val) => connectionResult = val);
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _logger.d("internet state changed state=" + result.toString());
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
      _logger.d(
          "didChangeAppLifecycleState resume " + connectionResult.toString());
      setState(() {});
    }
  }

  void _handleClick(BuildContext context, String value) {
    _logger.d("_handleClick");
    switch (value) {
      case CHANGE_LANGUAGE_KEY:
        DialogHelper.chooseLanguage(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    _logger.d("build");

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black26
                : Colors.white,
        title: Text(_getPageTitle(_activePage)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => _handleClick(context, value),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: CHANGE_LANGUAGE_KEY,
                  child: Text(LocaleKeys.changeLanguage.tr()),
                )
              ];
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _activePage == 0
          ? FloatingActionButton(
              foregroundColor:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
              onPressed: () {
                DialogHelper.addNewShare(context);
              },
              tooltip: LocaleKeys.add.tr(),
              child: Icon(Icons.add),
              elevation: 2.0,
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: LocaleKeys.homePage.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              label: LocaleKeys.gospelPage.tr(),
            )
          ],
          currentIndex: _activePage,
          backgroundColor:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.black45
                  : Colors.white,
          onTap: (index) {
            _pageViewController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          },
        ),
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
                  Text(LocaleKeys.noInternet.tr(),
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
