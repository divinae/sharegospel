import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/data/user_data.dart';

class AnalyticsHelper {
  static var _logger = Logger();

  static Future<void> sendAddShareEvent(
      FirebaseAnalytics analytics, UserData userData, bool saved) async {
    _logger.d("sendAddShareEvent uuid=${userData.uuid},"
        " city=${userData.city}, saved=$saved");
    await analytics.logEvent(
      name: ADD_SHARE_ANALYTICS_EVENT,
      parameters: <String, dynamic>{
        UUID_KEY: userData.uuid,
        CITY_NAME_KEY: userData.city,
        SAVED_KEY: saved,
      },
    );
  }
}
