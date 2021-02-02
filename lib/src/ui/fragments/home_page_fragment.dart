import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/user_data.dart';
import 'package:sharegospel/src/utils/dialogs_helper.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/widgets/count_widget.dart';
import 'package:sharegospel/src/utils/logger.dart';

class HomePageFragment extends StatefulWidget {
  HomePageFragment();

  @override
  _HomePageFragmentState createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends State<HomePageFragment> {
  var _stream;
  var _city;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserData>(builder: (context, userData) {
      if (userData == null) {
        logger.d("user data is loading");
        return Center(child: CircularProgressIndicator());
      }

      logger.d("uuid=${userData.uuid} city=${userData.city}");

      if (userData.city == null) {
        DialogHelper.loadCity(context);
      }

      if (userData.uuid != null && userData.city != null) {
        if (userData.city != _city) {
          logger.d("build UI for new city");
          _city = userData.city;
          _stream = FirebaseFirestore.instance
              .collection(getCitiesDB())
              .where(DOCUMENT_ID_KEY, isEqualTo: userData.city.toLowerCase())
              .snapshots();
        }

        return CountWidget(userData.city, _stream);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
