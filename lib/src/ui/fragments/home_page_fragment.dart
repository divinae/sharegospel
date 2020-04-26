import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/fragments/count_widget.dart';

class HomePageFragment extends StatelessWidget {
  final Function _changeFragment;

  HomePageFragment(this._changeFragment);

  @override
  Widget build(BuildContext context) {
    return CountWidget(SHARES_DB);
  }
}