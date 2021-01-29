import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/utils.dart';
import '../../resources/consts.dart';
import 'package:transparent_image/transparent_image.dart';

class SharesCityCard extends StatelessWidget {
  const SharesCityCard({
    Key key,
    @required this.title,
    @required this.imagePath,
    @required this.cityName,
    @required this.sharesCount,
    @required this.savedCount,
    @required this.changeCity,
  }) : super(key: key);

  final String title;
  final String imagePath;
  final String cityName;
  final int sharesCount;
  final int savedCount;
  final Function changeCity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Container(
            height: 140,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("$CITY_TEXT ",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    "$cityName",
                                    overflow: kIsWeb
                                        ? TextOverflow.clip
                                        : TextOverflow.fade,
                                    softWrap: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("$GOSPEL_HEARD_TEXT ",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text(
                                  "${sharesCount.toString()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " ${getPeoplePostfix(sharesCount)}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("$INVITE_JESUS_TEXT ",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text("${savedCount.toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(" ${getPeoplePostfix(savedCount)}",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: AssetImage(imagePath),
                        height: 80,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 4.0),
              child: IconButton(
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
