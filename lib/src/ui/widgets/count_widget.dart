import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/dialogs/dialogs_helper.dart';
import 'package:sharegospel/src/ui/widgets/dialog_buttons.dart';
import 'package:sharegospel/src/ui/widgets/shares_card.dart';
import 'package:sharegospel/src/ui/widgets/shares_city_card.dart';
import 'package:sharegospel/src/ui/widgets/slider_widget.dart';
import '../../resources/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CountWidget extends StatefulWidget {
  final String city;
  final Stream<QuerySnapshot> stream;

  const CountWidget(this.city, this.stream);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  var _logger = Logger();

  final List<Widget> _imageSliders =
      HOME_IMAGES_URLS.map((imageUrl) => SliderWidget(imageUrl)).toList();

  var _documentUuid;

  var _sharesCount = 0;
  var _savedCount = 0;

  var _isDeviceCountsInitialized = false;
  var _deviceSharesCount = 0;
  var _deviceSavedCount = 0;

  @override
  Widget build(BuildContext context) {
    if (!_isDeviceCountsInitialized) {
      _loadDeviceCounts();
      return Center(child: CircularProgressIndicator());
    }

    _logger.d("CountWidget build");
    return StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            items: _imageSliders,
                          ),
                          SharesCard(
                              title: YOUR_COUNT_TEXT,
                              imagePath: PERSON_ASSET_PATH,
                              sharesCount: _deviceSharesCount,
                              savedCount: _deviceSavedCount),
                          SharesCityCard(
                            title: CITY_COUNT_TEXT,
                            imagePath: CITY_ASSET_PATH,
                            sharesCount: _sharesCount,
                            cityName: widget.city,
                            savedCount: _savedCount,
                            changeCity: DialogHelper.changeCity,
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
                    onPressed: () => _showAddDialog(),
                  ),
                ),
              )
            ],
          );
        });
  }

  _getData(Iterable<DocumentSnapshot> documents) {
    _logger.d("_getData for ${widget.city} docLength=${documents.length}");

    if (!this.mounted) {
      return;
    }

    if (documents.length > 0) {
      var item = documents.first;
      _documentUuid = item.id;
      _sharesCount = item.data()[SHARES_COUNT_KEY] as int;
      _savedCount = item.data()[SAVED_COUNT_KEY] as int;
    }
  }

  _loadDeviceCounts() async {
    _logger.d("_loadDeviceCounts");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _deviceSharesCount = (prefs.getInt(DEVICE_SHARES_COUNT_KEY) ?? 0);
      _deviceSavedCount = (prefs.getInt(DEVICE_SAVED_COUNT_KEY) ?? 0);
      _isDeviceCountsInitialized = true;
    });
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var screenWidth = MediaQuery.of(context).size.width;

          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth > MAX_SCREEN_WIDTH
                      ? MAX_DIALOG_WIDTH
                      : screenWidth,
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
                            DialogButton(
                              text: CANCEL_TEXT,
                              width: 100.0,
                              isPositive: false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DialogButton(
                                  text: NO_TEXT,
                                  width: 60.0,
                                  isPositive: false,
                                  onPressed: () {
                                    _addShare(false);
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                ),
                                DialogButton(
                                  text: YES_TEXT,
                                  width: 60.0,
                                  isPositive: true,
                                  onPressed: () {
                                    _addShare(true);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  _addShare(bool saved) async {
    _logger.d("_addShare $saved");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DEVICE_SHARES_COUNT_KEY, ++_deviceSharesCount);
    if (saved) {
      await prefs.setInt(DEVICE_SAVED_COUNT_KEY, ++_deviceSavedCount);
    }

    FirebaseFirestore.instance
        .collection(getCitiesDB())
        .doc(_documentUuid)
        .update({
      SHARES_COUNT_KEY: _sharesCount + 1,
      SAVED_COUNT_KEY: saved ? _savedCount + 1 : _savedCount
    }).then((result) {
      _logger.d('added');
    }).catchError((onError) {
      _logger.e('error ${onError.toString()}');
    });
  }
}
