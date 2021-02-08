import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/utils/logger.dart';

import 'consts.dart';

class FirestoreHelper {
  static incrementShareCounter(bool saved, String documentUuid) {
    logger.d("incrementShareCounter $saved");
    if (saved) {
      FirebaseFirestore.instance
          .collection(getCitiesDB())
          .doc(documentUuid)
          .update({
        SHARES_COUNT_KEY: FieldValue.increment(1),
        SAVED_COUNT_KEY: FieldValue.increment(1)
      }).then((result) {
        logger.d('added');
      }).catchError((onError) {
        logger.e('error ${onError.toString()}');
      });
    } else {
      FirebaseFirestore.instance
          .collection(getCitiesDB())
          .doc(documentUuid)
          .update({
        SHARES_COUNT_KEY: FieldValue.increment(1),
      }).then((result) {
        logger.d('added');
      }).catchError((onError) {
        logger.e('error ${onError.toString()}');
      });
    }
  }
}
