import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharegospel/src/bloc/add_share_bloc.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/add_share_data.dart';
import 'package:sharegospel/src/utils/dialogs_helper.dart';
import 'package:sharegospel/src/ui/widgets/shares_card.dart';
import 'package:sharegospel/src/ui/widgets/shares_city_card.dart';
import 'package:sharegospel/src/ui/widgets/slider_widget.dart';
import 'package:sharegospel/src/utils/logger.dart';
import '../../resources/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';

class CountWidget extends StatefulWidget {
  final String city;
  final Stream<QuerySnapshot> stream;

  const CountWidget(this.city, this.stream);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
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
    logger.d("build count widget $_isDeviceCountsInitialized");

    if (!_isDeviceCountsInitialized) {
      _loadDeviceCounts();
      return Center(child: CircularProgressIndicator());
    }

    return BlocListener<AddShareBloc, AddShareData>(
      listener: (context, addShareData) {
        _addShare(addShareData.saved);
      },
      child: StreamBuilder(
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
                              title: LocaleKeys.yourCount,
                              imagePath: PERSON_ASSET_PATH,
                              sharesCount: _deviceSharesCount,
                              savedCount: _deviceSavedCount),
                          SharesCityCard(
                            title: LocaleKeys.cityCount,
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
            ],
          );
        },
      ),
    );
  }

  _getData(Iterable<DocumentSnapshot> documents) {
    logger.d("${widget.city} docLength=${documents.length}");

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
    logger.d("load device counts");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _deviceSharesCount = (prefs.getInt(DEVICE_SHARES_COUNT_KEY) ?? 0);
      _deviceSavedCount = (prefs.getInt(DEVICE_SAVED_COUNT_KEY) ?? 0);
      _isDeviceCountsInitialized = true;
    });
  }

  _addShare(bool saved) async {
    logger.d("$saved");

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
      logger.d('added');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }
}
