import 'package:flutter/foundation.dart';
import 'consts.dart';

getCitiesDB() {
  return kDebugMode ? CITIES_DEV_DB : CITIES_DB;
}

getPeoplePostfix(int count) {
  if (count == 0) {
    return "osób";
  } else if (count == 1) {
    return "osoba";
  } else if (count <= 4) {
    return "osoby";
  } else if (count < 22) {
    return "osób";
  } else {
    String countString = count.toString();
    int lastChar = countString.codeUnitAt(countString.length - 1) - 48;
    int prevLastChar = countString.codeUnitAt(countString.length - 2) - 48;

    if (prevLastChar >= 2 && lastChar >= 2 && lastChar <= 4) {
      return "osoby";
    } else {
      return "osób";
    }
  }
}
