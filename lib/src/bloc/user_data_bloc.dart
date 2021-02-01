import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/user_data.dart';
import 'package:uuid/uuid.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserData> {
  UserDataBloc() : super(null);

  var _logger = Logger();
  String _uuid;
  String _city;

  @override
  Stream<UserData> mapEventToState(UserDataEvent event) async* {
    if (event is InitUserDataEvent) {
      _logger.d("InitUserDataEvent");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String city = (prefs.getString(CITY_NAME_KEY) ?? null);
      String uuid = (prefs.getString(UUID_KEY) ?? null);

      if (uuid == null) {
        _logger.d("create new uuid");
        uuid = Uuid().v1();
        await prefs.setString(UUID_KEY, uuid);
      }

      _logger.d("uuid=$uuid, city=$city");
      _uuid = uuid;
      _city = city;

      yield UserData(city: _city, uuid: _uuid);
    } else if (event is SetCityEvent) {
      _logger.d("SetCity oldCity=$_city newCity=${event.data}");
      if (event.data == _city) {
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(CITY_NAME_KEY, event.data);
      _city = event.data;

      yield UserData(city: _city, uuid: _uuid);
    } else if (event is CreateCityEvent) {
      var city = event.data;
      _logger.d("CreateCityEvent $city");

      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection(getCitiesDB())
          .doc(city.toLowerCase())
          .get();

      if (document.data() != null) {
        _logger.d('city already created');
        _city = document.data()[CITY_NAME_KEY];
        yield UserData(city: _city, uuid: _uuid);
      } else {
        _createCityDoc(city);
      }
    }
  }

  _createCityDoc(String city) {
    _logger.d('_createCityDoc $city');

    Map<String, dynamic> data = new Map<String, dynamic>();
    data[CITY_NAME_KEY] = city;
    data[SHARES_COUNT_KEY] = 0;
    data[SAVED_COUNT_KEY] = 0;

    FirebaseFirestore.instance
        .collection(getCitiesDB())
        .doc(city.toLowerCase())
        .set(data)
        .then((result) {
      add(SetCityEvent(city));
      _logger.d('city doc created');
    }).catchError((onError) {
      _logger.e('error ${onError.toString()}');
    });
  }
}
