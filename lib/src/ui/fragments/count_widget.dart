import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/consts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

final List<String> imgList = [
  'https://www.csmedia1.com/northwestbaptist.church/the-gospel-the-power-of-god-series.jpg',
  'https://i0.wp.com/www.ccf.org.ph/wp-content/uploads/2019/04/Be-a-Blessing.jpg?fit=1920%2C1080&ssl=1',
  'https://content.thriveglobal.com/wp-content/uploads/2020/02/goodnews.jpg',
  'https://images.squarespace-cdn.com/content/v1/5a786461bce176c268dcc0f8/1517912147091-N66MGUYD2L3CGJC0B8HF/ke17ZwdGBToddI8pDm48kPpMuD-lfe4Jlrz6p4sHWIIUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKccU5H_NPXqCiUlaoDXtJ3mr7JUedzcQMnICPKvIuCjp4kBfnH4gFqD3JR_xn45zol/020d1_John_3_16_illustration_EN.jpg?format=1500w',
  'https://www.john15.rocks/wp-content/uploads/2017/02/bible_good_news-696x464.jpg',
  'https://i2.wp.com/redeeminggod.com/wp-content/uploads/2016/11/ShareTheGospel_630x315.jpg'
];

class CountWidget extends StatefulWidget {
  final String uuid;
  final String city;

  const CountWidget(this.uuid, this.city);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var stream;
  var subscription;
  var documentUuid;
  var logger = Logger();

  ConnectivityResult connectionResult;

  var sharesCount = 0;
  var savedCount = 0;

  var deviceSharesCount = 0;
  var deviceSavedCount = 0;

  final List<Widget> imageSliders = imgList
      .map((item) =>
      Container(
        margin: EdgeInsets.all(0.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: CachedNetworkImage(
              width: 1000,
              fit: BoxFit.cover,
              imageUrl: item,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ))
      .toList();

  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection(SHARES_DB)
        .where(CITY_KEY, isEqualTo: widget.city)
        .snapshots();
    Connectivity().checkConnectivity().then((val) => connectionResult = val);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      connectionResult = result;
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

            if (snapshot.data.docs.length == 0 ||
                connectionResult == ConnectivityResult.none) {
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
                    Text(NO_INTERNET_TEXT,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1)
                  ],
                ),
              );
            }

            _getData(snapshot.data.docs);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 1.8,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                        ),
                        items: imageSliders,
                      ),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    YOUR_COUNT_TEXT,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Text(
                                              "$GOSPEL_HEARD_TEXT ${deviceSharesCount
                                                  .toString()} $PEOPLE_POSTFIX_TEXT",
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(2.0)),
                                          Text(
                                              "$INVITE_JESUS_TEXT ${deviceSavedCount
                                                  .toString()} $PEOPLE_POSTFIX_TEXT",
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .subtitle1),
                                        ],
                                      ),
                                      FadeInImage(
                                        placeholder:
                                        MemoryImage(kTransparentImage),
                                        image: AssetImage(PERSON_ASSET_PATH),
                                        height: 80,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 2.0,
                        child: Container(
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  CITY_COUNT_TEXT,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline6,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                            "$GOSPEL_HEARD_TEXT ${sharesCount
                                                .toString()} $PEOPLE_POSTFIX_TEXT",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .subtitle1),
                                        Padding(
                                            padding: const EdgeInsets.all(2.0)),
                                        Text(
                                            "$INVITE_JESUS_TEXT ${savedCount
                                                .toString()} $PEOPLE_POSTFIX_TEXT",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .subtitle1),
                                      ],
                                    ),
                                    FadeInImage(
                                      placeholder:
                                      MemoryImage(kTransparentImage),
                                      image: AssetImage(CITY_ASSET_PATH),
                                      height: 80,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                    child: FloatingActionButton.extended(
                      foregroundColor:
                      MediaQuery
                          .of(context)
                          .platformBrightness ==
                          Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      label: Text(ADD_TEXT),
                      icon: Icon(Icons.add),
                      onPressed: () => {_showAddDialog()},
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  _getData(Iterable<DocumentSnapshot> documents) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      deviceSharesCount = (prefs.getInt(DEVICE_SHARES_COUNT_KEY) ?? 0);
      deviceSavedCount = (prefs.getInt(DEVICE_SAVED_COUNT_KEY) ?? 0);
    });

    if (documents.length > 0) {
      var item = documents.first;
      documentUuid = item.id;
      setState(() {
        sharesCount = item.data()[SHARES_COUNT_KEY] as int;
        savedCount = item.data()[SAVED_COUNT_KEY] as int;
      });
    } else {
      _createDoc();
    }
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(ADD_TEXT,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(BEEN_SAVED_TEXT,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                            width: 110.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                _addShare(false);
                                Navigator.pop(context);
                              },
                              child: Text(
                                NO_TEXT,
                                style: TextStyle(
                                    color: MediaQuery
                                        .of(context)
                                        .platformBrightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black54),
                              ),
                              color: Theme
                                  .of(context)
                                  .dividerColor,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          SizedBox(
                            height: 40,
                            width: 110.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                _addShare(true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                YES_TEXT,
                                style: TextStyle(
                                  color: MediaQuery
                                      .of(context)
                                      .platformBrightness ==
                                      Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              color: Theme
                                  .of(context)
                                  .accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  _addShare(bool saved) async {
    logger.d("_addShare ${saved}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DEVICE_SHARES_COUNT_KEY, ++deviceSharesCount);
    if (saved) {
      await prefs.setInt(DEVICE_SAVED_COUNT_KEY, ++deviceSavedCount);
    }

    FirebaseFirestore.instance.collection(SHARES_DB).doc(documentUuid).update({
      SHARES_COUNT_KEY: ++sharesCount,
      SAVED_COUNT_KEY: saved ? ++savedCount : savedCount
    }).then((result) {
      logger.d(' added');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }

  _createDoc() {
    logger.d('_createDoc ${widget.city}');
    Map<String, dynamic> data = new Map<String, dynamic>();
    data[CITY_KEY] = widget.city;
    data[SHARES_COUNT_KEY] = 0;
    data[SAVED_COUNT_KEY] = 0;

    FirebaseFirestore.instance
        .collection(SHARES_DB)
        .doc()
        .set(data)
        .then((result) {
      logger.d('added');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }

  _refreshStream() async {
    setState(() {
      stream = FirebaseFirestore.instance
          .collection(SHARES_DB)
          .where(CITY_KEY, isEqualTo: widget.city)
          .snapshots();
    });
  }
}
