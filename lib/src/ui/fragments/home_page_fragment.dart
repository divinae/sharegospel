import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/fragments/count_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:logger/logger.dart';

class HomePageFragment extends StatefulWidget {
  final Function _changeFragment;

  HomePageFragment(this._changeFragment);

  @override
  _HomePageFragmentState createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends State<HomePageFragment> {
  ConnectivityResult connectionResult;
  var subscription;
  String _uuid;
  String _city;
  var isDialogVisible = false;

  var logger = Logger();

  @override
  void initState() {
    logger.d("initState");
    Connectivity().checkConnectivity().then((val) => connectionResult = val);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      connectionResult = result;
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        logger.d("internet state changed");
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("build");

    if (_city == null && !isDialogVisible) {
      loadCity(context);
    }

    if (_uuid == null) {
      loadUuid();
    }

    if (_uuid != null && _city != null) {
      logger.d("build Count $_city $_uuid");
      return CountWidget(_uuid, _city);
    } else if (connectionResult == ConnectivityResult.none) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage(NO_INTERNET_ASSET_PATH),
              height: 150,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
            Text(NO_INTERNET_TEXT, style: Theme.of(context).textTheme.subtitle1)
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  loadUuid() async {
    logger.d("loadUuid");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = (prefs.getString(UUID_KEY) ?? null);
    if (uuid == null) {
      logger.d("set uuid");
      uuid = Uuid().v1();
      await prefs.setString(UUID_KEY, uuid);
    }

    logger.d("uiid $uuid");
    setState(() {
      _uuid = uuid;
    });
  }

  loadCity(var context) async {
    logger.d("loadCity");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = (prefs.getString(CITY_KEY) ?? null);

    if (city == null && connectionResult == ConnectivityResult.none) {
      return;
    } else if (city == null && connectionResult != ConnectivityResult.none) {
      isDialogVisible = true;
      List<GroupModel> _group = [];
      int index = 0;

      await FirebaseFirestore.instance
          .collection(CITIES_DB)
          .get()
          .then((QuerySnapshot snapshot) {
        var documents = snapshot.docs;
        documents.sort((a, b) => a
            .data()[CITY_NAME_KEY]
            .toString()
            .compareTo(b.data()[CITY_NAME_KEY].toString()));
        documents.forEach((document) => _group.add(GroupModel(
              text: document.data()[CITY_NAME_KEY],
              index: index++,
            )));
      });

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            int selectedRadio = 0;
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(CHOOSE_CITY_TEXT,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Divider(),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: _group == null ? 1 : _group.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile(
                                title: Text("${_group[index].text}"),
                                groupValue: selectedRadio,
                                value: _group[index].index,
                                onChanged: (index) {
                                  logger.d("select_radio set state");
                                  setState(() {
                                    selectedRadio = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            height: 40,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                city = _group[selectedRadio].text;
                                prefs.setString(CITY_KEY, city);
                                Navigator.pop(context);
                              },
                              child: Text(
                                OK_TEXT,
                                style: TextStyle(
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            );
          });
    }

    logger.d("city $city");
    setState(() {
      _city = city;
      isDialogVisible = false;
    });
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
