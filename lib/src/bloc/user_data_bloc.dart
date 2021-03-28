import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/user_data.dart';
import 'package:sharegospel/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserData> {
  UserDataBloc() : super(null);

  String _uuid;
  String _city;

  @override
  Stream<UserData> mapEventToState(UserDataEvent event) async* {
    if (event is InitUserDataEvent) {
      logger.d("InitUserDataEvent");
      Box box = Hive.box(USER_DATA_BOX_KEY);
      String city = (box.get(CITY_NAME_KEY) ?? null);
      String uuid = (box.get(UUID_KEY) ?? null);

      if (uuid == null) {
        logger.d("create new uuid");
        uuid = Uuid().v1();
        box.put(UUID_KEY, uuid);
      }

      logger.d("uuid=$uuid, city=$city");
      _uuid = uuid;
      _city = city;

      yield UserData(city: _city, uuid: _uuid);
    } else if (event is SetCityEvent) {
      logger.d("SetCity oldCity=$_city newCity=${event.data}");
      if (event.data == _city) {
        return;
      }

      Box box = Hive.box(USER_DATA_BOX_KEY);
      box.put(CITY_NAME_KEY, event.data);
      _city = event.data;

      yield UserData(city: _city, uuid: _uuid);
    } else if (event is CreateCityEvent) {
      var city = event.data;
      logger.d("CreateCityEvent $city");

      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance
          .collection(getCitiesDB())
          .doc(city.toLowerCase())
          .get();

      if (document.data() != null) {
        logger.d('city already created');
        _city = document.data()[CITY_NAME_KEY];
        yield UserData(city: _city, uuid: _uuid);
      } else {
        _createCityDoc(city);
      }
    }
  }

  _createCityDoc(String city) {
    logger.d('_createCityDoc $city');

    Map<String, dynamic> data = Map<String, dynamic>();
    data[CITY_NAME_KEY] = city;

    FirebaseFirestore.instance
        .collection(getCitiesDB())
        .doc(city.toLowerCase())
        .set(data)
        .then((result) {
      add(SetCityEvent(city));
      logger.d('city doc created');
    }).catchError((onError) {
      logger.e('error ${onError.toString()}');
    });
  }
}
