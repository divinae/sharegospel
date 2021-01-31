import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharesCard extends StatelessWidget {
  const SharesCard({
    Key key,
    @required this.title,
    @required this.imagePath,
    @required this.sharesCount,
    @required this.savedCount,
  }) : super(key: key);

  final String title;
  final String imagePath;
  final int sharesCount;
  final int savedCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
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
                            Text("${AppLocalizations.of(context).gospelHeard} ",
                                style: Theme.of(context).textTheme.subtitle1),
                            Text(
                              "${sharesCount.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${getPeoplePostfix(context, sharesCount)}",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        Padding(padding: const EdgeInsets.all(2.0)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${AppLocalizations.of(context).inviteJesus} ",
                                style: Theme.of(context).textTheme.subtitle1),
                            Text("${savedCount.toString()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text(" ${getPeoplePostfix(context, savedCount)}",
                                style: Theme.of(context).textTheme.subtitle1),
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
    );
  }
}
