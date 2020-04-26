import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../resources/consts.dart';
import 'package:connectivity/connectivity.dart';

class CountWidget extends StatefulWidget {
  final String name;

  const CountWidget(this.name);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var stream;
  var subscription;
  ConnectivityResult connectionResult;

  @override
  void initState() {
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

            return Center(
              child: Text(
                '1',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
    );
  }

  _refreshStream() async {
    setState(() {
      stream = Firestore.instance.collection(widget.name).snapshots();
    });
  }
}
