import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

getCitiesDB() {
  return kDebugMode ? CITIES_DEV_DB : CITIES_DB;
}

getPeoplePostfix(BuildContext context, int count) {
  if (count == 0) {
    return AppLocalizations.of(context).persons;
  } else if (count == 1) {
    return AppLocalizations.of(context).person;
  } else if (count <= 4) {
    return AppLocalizations.of(context).personsSec;
  } else if (count < 22) {
    return AppLocalizations.of(context).persons;
  } else {
    String countString = count.toString();
    int lastChar = countString.codeUnitAt(countString.length - 1) - 48;
    int prevLastChar = countString.codeUnitAt(countString.length - 2) - 48;

    if (prevLastChar >= 2 && lastChar >= 2 && lastChar <= 4) {
      return AppLocalizations.of(context).personsSec;
    } else {
      return AppLocalizations.of(context).persons;
    }
  }
}
