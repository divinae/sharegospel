import 'package:flutter/foundation.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'consts.dart';

getCitiesDB() {
  return kDebugMode ? CITIES_DEV_DB : CITIES_DB;
}

getPeoplePostfix(int count) {
  if (count == 0) {
    return LocaleKeys.persons.tr();
  } else if (count == 1) {
    return LocaleKeys.person.tr();
  } else if (count <= 4) {
    return LocaleKeys.personsSec.tr();
  } else if (count < 22) {
    return LocaleKeys.persons.tr();
  } else {
    String countString = count.toString();
    int lastChar = countString.codeUnitAt(countString.length - 1) - 48;
    int prevLastChar = countString.codeUnitAt(countString.length - 2) - 48;

    if (prevLastChar >= 2 && lastChar >= 2 && lastChar <= 4) {
      return LocaleKeys.personsSec.tr();
    } else {
      return LocaleKeys.persons.tr();
    }
  }
}
