import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("$CITY_TEXT ",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text(
                                  "$cityName",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Row(
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
                                  " $PEOPLE_POSTFIX_TEXT",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(2.0)),
                            Row(
                              children: [
                                Text("$INVITE_JESUS_TEXT ",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text("${savedCount.toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(" $PEOPLE_POSTFIX_TEXT",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          ],
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
          ),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  splashRadius: 25,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    changeCity(context);
                  }))
        ],
      ),
    );
  }
}
