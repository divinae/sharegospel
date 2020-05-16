import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import '../../resources/consts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carousel_slider/carousel_slider.dart';

//TODO dodać swoje obrazki o ewangelii
final List<String> imgList = [
  'https://images.squarespace-cdn.com/content/v1/5a786461bce176c268dcc0f8/1517912147091-N66MGUYD2L3CGJC0B8HF/ke17ZwdGBToddI8pDm48kPpMuD-lfe4Jlrz6p4sHWIIUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKccU5H_NPXqCiUlaoDXtJ3mr7JUedzcQMnICPKvIuCjp4kBfnH4gFqD3JR_xn45zol/020d1_John_3_16_illustration_EN.jpg?format=1500w',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80'
];

class CountWidget extends StatefulWidget {
  final String name;
  final String uuid;
  final String city;

  const CountWidget(this.name, this.uuid, this.city);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var stream;
  var subscription;
  ConnectivityResult connectionResult;

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0)
                    ],
                  )),
            ),
          ))
      .toList();

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
              return Center(child: Text(NO_INTERNET_TEXT));
            }

            var count = 0;
            var deviceCount = 0;
            var found = false;

            for (var item in snapshot.data.documents) {
              if (item.data[CITY_KEY] == widget.city) {
                //TODO rozdzielenie na ogolnie/miesiac
                count += item.data[COUNT_KEY] as int;
                if (item.documentID == widget.uuid) {
                  found = true;
                  deviceCount = item.data[COUNT_KEY] as int;
                  log("kuba: found document");
                }
              }
            }

            if (!found) {
              createDocument();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 1.6,
                            viewportFraction: 1.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                          ),
                          items: imageSliders,
                        ),
                      ),
                      Text(
                        CITY_COUNT_TEXT,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            CITY_ALL_COUNT_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            count.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            COUNT_POSTFIX_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            CITY_MONTH_COUNT_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            count.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            COUNT_POSTFIX_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        YOUR_COUNT_TEXT,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            YOUR_ALL_COUNT_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            deviceCount.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            PEOPLE_POSTFIX_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            YOUR_MONTH_COUNT_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            deviceCount.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            PEOPLE_POSTFIX_TEXT,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: FloatingActionButton.extended(
                      foregroundColor: Colors.white,
                      label: Text(ADD_TEXT),
                      icon: Icon(Icons.add),
                      onPressed: () {
                        add(deviceCount);
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  add(int value) {
    log('kuba: add $value ${widget.uuid} ${widget.city}');
    Firestore.instance
        .collection(widget.name)
        .document(widget.uuid)
        .updateData({COUNT_KEY: ++value}).then((result) {
      log('kuba: added');
    }).catchError((onError) {
      log(
        'kuba: error ${onError.toString()}',
      );
    });
  }

  createDocument() {
    log('kuba: create ${widget.uuid} ${widget.city}');
    Map<String, dynamic> data = new Map<String, dynamic>();
    data[COUNT_KEY] = 0;
    data[CITY_KEY] = widget.city;

    Firestore.instance
        .collection(widget.name)
        .document(widget.uuid)
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
