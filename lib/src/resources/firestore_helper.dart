import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/utils/logger.dart';

import 'consts.dart';

class FirestoreHelper {
  static incrementShareCounter(bool saved, String cityUuid) {
    logger.d("incrementShareCounter $saved");
    var data;

    if (saved) {
      data = {
        "${DateTime.now().month}." + SHARES_COUNT_KEY: FieldValue.increment(1),
        "${DateTime.now().month}." + SAVED_COUNT_KEY: FieldValue.increment(1)
      };
    } else {
      data = {
        "${DateTime.now().month}." + SHARES_COUNT_KEY: FieldValue.increment(1),
      };
    }

    FirebaseFirestore.instance
        .collection(getCitiesDB())
        .doc(cityUuid)
        .collection(CITY_STATS_KEY)
        .doc(DateTime.now().year.toString())
        .update(data)
        .then((result) {
      logger.d('added');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }

  static createShareDoc(String cityUuid) {
    String currentYear = DateTime.now().year.toString();
    logger.d("createShareDoc $cityUuid year=$currentYear");

    FirebaseFirestore.instance
        .collection(getCitiesDB())
        .doc(cityUuid)
        .collection(CITY_STATS_KEY)
        .doc(currentYear)
        .set(EMPTY_SHARES_MAP)
        .then((result) {
      logger.d('added');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }
}
