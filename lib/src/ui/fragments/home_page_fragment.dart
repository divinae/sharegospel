import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/user_data.dart';
import 'package:sharegospel/src/ui/dialogs/dialogs_helper.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/ui/widgets/count_widget.dart';

class HomePageFragment extends StatefulWidget {
  HomePageFragment();

  @override
  _HomePageFragmentState createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends State<HomePageFragment> {
  var _logger = Logger();
  var _stream;
  var _city;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserData>(builder: (context, userData) {
      if (userData == null) {
        _logger.d("user data is loading");
        return Center(child: CircularProgressIndicator());
      }

      _logger.d("HomePageFragment uuid=${userData.uuid} city=${userData.city}");

      if (userData.city == null) {
        DialogHelper.loadCity(context);
      }

      if (userData.uuid != null && userData.city != null) {
        if (userData.city != _city) {
          _logger.d("build UI for new city");
          _city = userData.city;
          _stream = FirebaseFirestore.instance
              .collection(getCitiesDB())
              .where(CITY_NAME_KEY, isEqualTo: userData.city)
              .snapshots();
        }

        return CountWidget(userData.city, _stream);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
