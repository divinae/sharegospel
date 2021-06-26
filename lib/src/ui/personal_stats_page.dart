import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharegospel/src/ui/data/personal_shares.dart';
import 'package:sharegospel/src/utils/logger.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PersonalStatsPage extends StatefulWidget {
  const PersonalStatsPage({Key key, @required this.personalShares})
      : super(key: key);

  final Map<dynamic, PersonalShares> personalShares;

  @override
  _PersonalStatsPageState createState() => _PersonalStatsPageState();
}

class _PersonalStatsPageState extends State<PersonalStatsPage> {
  List<String> _years;
  var _chosenValue = DateTime.now().year.toString();

  @override
  void initState() {
    _years = widget.personalShares.keys.map((item) => item as String)?.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _allShares = 0;
    var _allSaved = 0;

    logger.d("shares=${widget.personalShares} $_chosenValue $_years");

    final shares = _getStats(widget.personalShares[_chosenValue].shares);
    shares.forEach((element) {
      _allShares += element.value;
    });

    final saved = _getStats(widget.personalShares[_chosenValue].saved);
    saved.forEach((element) {
      _allSaved += element.value;
    });

    final List<charts.Series> monthlyPlotList =
        _createMonthlyData(shares, saved);
    final List<charts.Series> yearlyPlotList =
        _createYearlyData(_allSaved, _allShares - _allSaved);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black26
                : Colors.white,
        title: Text(LocaleKeys.personalStatsPage.tr()),
      ),
      body: Center(
        child: Container(
          width: kIsWeb
              ? _screenWidth > MAX_SCREEN_WIDTH
                  ? MAX_SCREEN_WIDTH
                  : _screenWidth
              : _screenWidth,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.date_range_rounded,
                        size: 20,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: false,
                        isDense: true,
                        icon: Icon(Icons.keyboard_arrow_down),
                        value: _chosenValue,
                        items: _years.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          if (_chosenValue != value) {
                            setState(() {
                              _chosenValue = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: AutoSizeText(
                        LocaleKeys.yearlyPlot.tr(),
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      height: 230,
                      padding: const EdgeInsets.all(8.0),
                      child: charts.PieChart(
                        yearlyPlotList,
                        animate: true,
                        defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: 30,
                        ),
                        behaviors: [
                          charts.DatumLegend(
                              position: charts.BehaviorPosition.top,
                              horizontalFirst: false,
                              outsideJustification:
                                  charts.OutsideJustification.end,
                              cellPadding:
                                  EdgeInsets.only(right: 8.0, bottom: 4.0),
                              showMeasures: true,
                              legendDefaultMeasure:
                                  charts.LegendDefaultMeasure.firstValue,
                              measureFormatter: (value) => "($value)"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        LocaleKeys.monthlyPlot.tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Container(
                      height: 290,
                      padding: const EdgeInsets.all(8.0),
                      child: charts.BarChart(
                        monthlyPlotList,
                        animate: false,
                        domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                              fontSize: 10,
                              color: _getTextColor(context),
                            ),
                            lineStyle: charts.LineStyleSpec(
                              color: _getTextColor(context),
                            ),
                          ),
                        ),
                        primaryMeasureAxis: charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                              fontSize: 11,
                              color: _getTextColor(context),
                            ),
                          ),
                        ),
                        behaviors: [
                          charts.SeriesLegend(
                              desiredMaxRows: 2,
                              desiredMaxColumns: 1,
                              cellPadding:
                                  EdgeInsets.only(right: 8.0, bottom: 4.0),
                              position: charts.BehaviorPosition.top,
                              outsideJustification:
                                  charts.OutsideJustification.end)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Share> _getStats(Map<String, int> values) {
    return [
      Share(LocaleKeys.january.tr(), values["1"]),
      Share(LocaleKeys.february.tr(), values["2"]),
      Share(LocaleKeys.march.tr(), values["3"]),
      Share(LocaleKeys.april.tr(), values["4"]),
      Share(LocaleKeys.may.tr(), values["5"]),
      Share(LocaleKeys.june.tr(), values["6"]),
      Share(LocaleKeys.july.tr(), values["7"]),
      Share(LocaleKeys.august.tr(), values["8"]),
      Share(LocaleKeys.september.tr(), values["9"]),
      Share(LocaleKeys.october.tr(), values["10"]),
      Share(LocaleKeys.november.tr(), values["11"]),
      Share(LocaleKeys.december.tr(), values["12"])
    ];
  }

  static List<charts.Series<Share, String>> _createMonthlyData(
      List<Share> shares, List<Share> saved) {
    return [
      charts.Series<Share, String>(
        id: LocaleKeys.gospelHeardStats.tr(),
        domainFn: (Share sales, _) => sales.name,
        measureFn: (Share sales, _) => sales.value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        data: shares,
      ),
      charts.Series<Share, String>(
        id: LocaleKeys.inviteJesusStats.tr(),
        domainFn: (Share share, _) => share.name,
        measureFn: (Share share, _) => share.value,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.darker,
        data: saved,
      )
    ];
  }

  static List<charts.Series<Share, String>> _createYearlyData(
      int saved, int notSaved) {
    final data = [
      Share(LocaleKeys.inviteJesusStats.tr(), saved),
      Share(LocaleKeys.notInviteJesusStats.tr(), notSaved)
    ];

    return [
      charts.Series<Share, String>(
        id: 'saved',
        domainFn: (Share share, _) => share.name,
        measureFn: (Share share, _) => share.value,
        colorFn: (Share share, __) =>
            share.name == LocaleKeys.inviteJesusStats.tr()
                ? charts.MaterialPalette.green.shadeDefault.darker
                : charts.MaterialPalette.blue.shadeDefault.darker,
        data: data,
      )
    ];
  }

  static _getTextColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? charts.MaterialPalette.white
        : charts.MaterialPalette.black;
  }
}

class Share {
  final String name;
  final int value;

  Share(this.name, this.value);
}
