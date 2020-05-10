import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../resources/consts.dart';
import 'package:connectivity/connectivity.dart';

class CountWidget extends StatefulWidget {
  final String name;
  final Future<String> uuid;
  final Future<String> city;

  const CountWidget(this.name, this.uuid, this.city);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var stream;
  var subscription;
  var uuid;
  ConnectivityResult connectionResult;

  @override
  void initState() {
    widget.uuid.then((String value) {
      uuid = value;
      log("kuba: get uuid in");
    });

    stream = Firestore.instance.collection(widget.name).snapshots();
    Connectivity().checkConnectivity().then((val) => connectionResult = val);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _refreshStream();
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
    return RefreshIndicator(
      onRefresh: () => _refreshStream(),
      child: StreamBuilder(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data.documents.length == 0 &&
                connectionResult == ConnectivityResult.none) {
              return Center(child: Text(NO_INTERNET));
            }

            var count = 0;
            var deviceCount = 0;
            var found = false;

            for (var item in snapshot.data.documents) {
              count += item.data[COUNT_KEY] as int;
              if (item.documentID == uuid) {
                found = true;
                deviceCount = item.data[COUNT_KEY] as int;
                log("kuba: found document");
              }
            }

            if (!found) {
              createDocument();
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    deviceCount.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  MaterialButton(
                    child: Text("Add"),
                    onPressed: () {
                      add(deviceCount);
                    },
                  )
                ],
              ),
            );
          }),
    );
  }

  add(int value) {
    log('kuba: add $value $uuid');
    Firestore.instance
        .collection(widget.name)
        .document(uuid)
        .updateData({COUNT_KEY: ++value}).then((result) {
      log('kuba: added');
    }).catchError((onError) {
      log(
        'kuba: error ${onError.toString()}',
      );
    });
  }

  createDocument() {
    log('kuba: create $uuid');
    Map<String, dynamic> data = new Map<String, dynamic>();
    data[COUNT_KEY] = 0;
    data[CITY_KEY] = "Warszawa";

    Firestore.instance
        .collection(widget.name)
        .document(uuid)
        .setData(data)
        .then((result) {
      log('kuba: added');
    }).catchError((onError) {
      log(
        'kuba: error ${onError.toString()}',
      );
    });
  }

  _refreshStream() async {
    setState(() {
      stream = Firestore.instance.collection(widget.name).snapshots();
    });
  }
}
