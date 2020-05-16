import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/fragments/count_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageFragment extends StatefulWidget {
  final Function _changeFragment;

  HomePageFragment(this._changeFragment);

  @override
  _HomePageFragmentState createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends State<HomePageFragment> {
  String _uuid;
  String _city;
  var isDialogVisible = false;

  //TODO dodać sprawdzenie internetu

  @override
  Widget build(BuildContext context) {
    log("kuba: loadUuid");

    if (_city == null && !isDialogVisible) {
      loadCity(context);
    }

    if (_uuid == null) {
      loadUuid();
    }

    if (_uuid != null && _city != null) {
      log("kuba: build Count $_city $_uuid");
      return CountWidget(SHARES_DB, _uuid, _city);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  loadUuid() async {
    log("kuba: loadUuid");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = (prefs.getString(UUID_KEY) ?? null);
    if (uuid == null) {
      log("kuba: set uuid");
      uuid = Uuid().v1();
      await prefs.setString(UUID_KEY, uuid);
    }

    log("kuba: uiid $uuid");
    setState(() {
      _uuid = uuid;
    });
  }

  loadCity(var context) async {
    log("kuba: loadCity");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = (prefs.getString(CITY_KEY) ?? null);

    if (city == null) {
      isDialogVisible = true;
      List<GroupModel> _group = [];
      int index = 0;

      await Firestore.instance
          .collection(CITIES_DB)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        var documents = snapshot.documents;
        documents.sort((a, b) =>
            a.data[NAME_KEY].toString().compareTo(b.data[NAME_KEY].toString()));
        documents.forEach((document) => _group.add(GroupModel(
              text: document.data[NAME_KEY],
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
                  borderRadius: BorderRadius.circular(20.0)), //this right here
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
                              style: Theme.of(context).textTheme.title),
                        ),
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
                                  log("kuba: select_radio set state");
                                  setState(() {
                                    selectedRadio = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          child: RaisedButton(
                            onPressed: () {
                              city = _group[selectedRadio].text;
                              prefs.setString(CITY_KEY, city);
                              Navigator.pop(context);
                            },
                            child: Text(
                              OK_TEXT,
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
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

    log("kuba: city $city");
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
