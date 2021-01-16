import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharegospel/src/ui/widgets/shares_card.dart';
import 'package:sharegospel/src/ui/widgets/shares_city_card.dart';
import '../../resources/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

final List<String> imgList = [
  'https://www.csmedia1.com/northwestbaptist.church/the-gospel-the-power-of-god-series.jpg',
  'https://www.john15.rocks/wp-content/uploads/2017/02/bible_good_news-696x464.jpg',
  'https://i2.wp.com/redeeminggod.com/wp-content/uploads/2016/11/ShareTheGospel_630x315.jpg'
];

class CountWidget extends StatefulWidget {
  final String uuid;
  final String city;
  final Function changeCity;

  const CountWidget(this.uuid, this.city, this.changeCity);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var stream;
  var subscription;
  var documentUuid;
  var logger = Logger();

  var sharesCount = 0;
  var savedCount = 0;

  var deviceSharesCount = 0;
  var deviceSavedCount = 0;

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
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
    super.initState();
    stream = FirebaseFirestore.instance
        .collection(SHARES_DB)
        .where(CITY_KEY, isEqualTo: widget.city)
        .snapshots();
  }

  @override
  void didUpdateWidget(CountWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.d("old city=${oldWidget.city} new city= ${widget.city}");
    if (oldWidget.city != widget.city) {
      logger.d("update stream");
      setState(() {
        stream = FirebaseFirestore.instance
            .collection(SHARES_DB)
            .where(CITY_KEY, isEqualTo: widget.city)
            .snapshots();
      });
    }
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

            _getData(snapshot.data.docs);

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
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
                            SharesCard(
                                title: YOUR_COUNT_TEXT,
                                imagePath: PERSON_ASSET_PATH,
                                sharesCount: deviceSharesCount,
                                savedCount: deviceSavedCount),
                            SharesCityCard(
                              title: CITY_COUNT_TEXT,
                              imagePath: CITY_ASSET_PATH,
                              sharesCount: sharesCount,
                              cityName: widget.city,
                              savedCount: savedCount,
                              changeCity: widget.changeCity,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                    child: FloatingActionButton.extended(
                      foregroundColor:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? Colors.black
                              : Colors.white,
                      label: Text(ADD_TEXT),
                      icon: Icon(Icons.add),
                      onPressed: () => {_showAddDialog()},
                    ),
                  ),
                )
              ],
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
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(BEEN_SAVED_TEXT,
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                            width: 100.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                CANCEL_TEXT,
                                style: TextStyle(
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black54),
                              ),
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 60.0,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    _addShare(false);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    NO_TEXT,
                                    style: TextStyle(
                                        color: MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black54),
                                  ),
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                              ),
                              SizedBox(
                                height: 40,
                                width: 60.0,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    _addShare(true);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    YES_TEXT,
                                    style: TextStyle(
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ],
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
    logger.d("_addShare $saved");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DEVICE_SHARES_COUNT_KEY, deviceSharesCount + 1);
    if (saved) {
      await prefs.setInt(DEVICE_SAVED_COUNT_KEY, deviceSavedCount + 1);
    }

    FirebaseFirestore.instance.collection(SHARES_DB).doc(documentUuid).update({
      SHARES_COUNT_KEY: sharesCount + 1,
      SAVED_COUNT_KEY: saved ? savedCount + 1 : savedCount
    }).then((result) {
      logger.d('added');
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
