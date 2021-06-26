import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:sharegospel/src/bloc/add_share_bloc.dart';
import 'package:sharegospel/src/resources/firestore_helper.dart';
import 'package:sharegospel/src/ui/data/add_share_data.dart';
import 'package:sharegospel/src/ui/data/personal_shares.dart';
import 'package:sharegospel/src/utils/dialogs_helper.dart';
import 'package:sharegospel/src/ui/widgets/personal_shares_card.dart';
import 'package:sharegospel/src/ui/widgets/city_shares_card.dart';
import 'package:sharegospel/src/ui/widgets/slider_widget.dart';
import 'package:sharegospel/src/utils/logger.dart';
import '../../resources/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';

import '../city_stats_page.dart';
import '../personal_stats_page.dart';

class CountWidget extends StatefulWidget {
  final String city;
  final Stream<DocumentSnapshot> stream;

  const CountWidget(this.city, this.stream);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  final List<Widget> _imageSliders = HOME_SLIDER_IMAGES_PATHS
      .map((imagePath) => SliderWidget(imagePath))
      .toList();

  var _sharesCount = 0;
  var _savedCount = 0;
  var _shares;

  var _isDeviceCountsInitialized = false;
  var _deviceSharesCount = 0;
  var _deviceSavedCount = 0;

  var box = Hive.box<PersonalShares>(SHARES_BOX_KEY);

  @override
  Widget build(BuildContext context) {
    if (!_isDeviceCountsInitialized) {
      _loadDeviceCounts();
    }

    logger.d("CountWidget build ${widget.stream}");

    return BlocListener<AddShareBloc, AddShareData>(
      listener: (context, addShareData) {
        _addShare(addShareData.saved);
      },
      child: StreamBuilder(
        stream: widget.stream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          logger.d("CountWidget stream builder hasData=${snapshot.hasData}");

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          logger.d(
              "CountWidget stream builder data.exists=${snapshot.data.exists}");

          _getData(snapshot.data);

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(8.0),
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
                  PersonalSharesCard(
                      title: LocaleKeys.yourCount,
                      imagePath: PERSON_ASSET_PATH,
                      sharesCount: _deviceSharesCount,
                      savedCount: _deviceSavedCount,
                      showMore: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalStatsPage(
                                      personalShares: box.toMap())),
                            )
                          }),
                  CitySharesCard(
                    title: LocaleKeys.cityCount,
                    imagePath: CITY_ASSET_PATH,
                    sharesCount: _sharesCount,
                    cityName: widget.city,
                    savedCount: _savedCount,
                    changeCity: DialogHelper.changeCity,
                    showMore: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CityStatsPage(
                                  shares: _shares,
                                  city: widget.city,
                                )),
                      )
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  _getData(DocumentSnapshot document) {
    logger.d("${widget.city} ${document.exists}");

    if (!this.mounted) {
      return;
    }

    if (document.exists) {
      _shares = document.data();
      _sharesCount =
          document["${DateTime.now().month}." + SHARES_COUNT_KEY] as int;
      _savedCount =
          document["${DateTime.now().month}." + SAVED_COUNT_KEY] as int;
    } else {
      FirestoreHelper.createShareDoc(widget.city.toLowerCase());
    }
  }

  _loadDeviceCounts() {
    logger.d("load device counts");
    var personalShares = box.get(DateTime.now().year.toString());

    if (personalShares != null) {
      logger.d(
          "load device counts ${personalShares.shares} ${personalShares.saved}");

      _deviceSharesCount =
          personalShares.shares[DateTime.now().month.toString()];
      _deviceSavedCount = personalShares.saved[DateTime.now().month.toString()];
    } else {
      personalShares = PersonalShares();
      personalShares.shares = Map.from(EMPTY_PERSONAL_SHARES_MAP);
      personalShares.saved = Map.from(EMPTY_PERSONAL_SHARES_MAP);
      box.put(DateTime.now().year.toString(), personalShares);
    }

    logger.d("load device counts $_deviceSharesCount $_deviceSavedCount");

    _isDeviceCountsInitialized = true;
  }

  _addShare(bool saved) {
    logger.d("$saved");
    var personalShares = box.get(DateTime.now().year.toString());

    personalShares.shares[DateTime.now().month.toString()] =
        ++_deviceSharesCount;
    if (saved) {
      personalShares.saved[DateTime.now().month.toString()] =
          ++_deviceSavedCount;
    }
    personalShares.save();

    FirestoreHelper.incrementShareCounter(saved, widget.city.toLowerCase());
  }
}
