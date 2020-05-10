import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/fragments/count_widget.dart';

import '../CustomDialog.dart';

class HomePageFragment extends StatelessWidget {
  final Function _changeFragment;

  HomePageFragment(this._changeFragment);

  @override
  Widget build(BuildContext context) {
    getUuid();
    return CountWidget(SHARES_DB, getUuid(), getCity(context));
  }

  Future<String> getUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = (prefs.getString(UUID_KEY) ?? null);
    if (uuid == null) {
      log("kuba: set uuid");
      uuid = Uuid().v1();
      await prefs.setString(UUID_KEY, uuid);
    }

    log("kuba: uiid $uuid");

    return uuid;
  }

  Future<String> getCity(var context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = (prefs.getString(CITY_KEY) ?? null);
    if (city == null) {
      log("kuba: get city");
      var customDialog = CustomDialog();

      customDialog.city(context);
    }

    log("kuba: uiid $city");

    return city;
  }
}
