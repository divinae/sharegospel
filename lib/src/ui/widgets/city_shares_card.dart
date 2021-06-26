import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';
import 'package:transparent_image/transparent_image.dart';
import 'flexible_text.dart';

class CitySharesCard extends StatelessWidget {
  const CitySharesCard({
    Key key,
    @required this.title,
    @required this.imagePath,
    @required this.cityName,
    @required this.sharesCount,
    @required this.savedCount,
    @required this.changeCity,
    @required this.showMore,
  }) : super(key: key);

  final String title;
  final String imagePath;
  final String cityName;
  final int sharesCount;
  final int savedCount;
  final Function changeCity;
  final Function showMore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(6, 16, 6, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    title.tr(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${LocaleKeys.yourCity.tr()} ",
                                  style: Theme.of(context).textTheme.subtitle1),
                              FlexibleText(
                                  text: cityName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(padding: const EdgeInsets.all(2.0)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${LocaleKeys.gospelHeard.tr()} ",
                                  style: Theme.of(context).textTheme.subtitle1),
                              Text(
                                "${sharesCount.toString()} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              FlexibleText(
                                text: getPeoplePostfix(sharesCount),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                          Padding(padding: const EdgeInsets.all(2.0)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${LocaleKeys.inviteJesus.tr()} ",
                                  style: Theme.of(context).textTheme.subtitle1),
                              Text("${savedCount.toString()} ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontWeight: FontWeight.bold)),
                              FlexibleText(
                                  text: getPeoplePostfix(savedCount),
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: AssetImage(imagePath),
                      height: 70,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(
                    height: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                ),
                TextButton(
                    onPressed: showMore,
                    child: Text(LocaleKeys.showMore.tr(),
                        style: Theme.of(context).textTheme.caption)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 4.0),
              child: IconButton(
                  iconSize: 20,
                  splashRadius: 25,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    changeCity(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
