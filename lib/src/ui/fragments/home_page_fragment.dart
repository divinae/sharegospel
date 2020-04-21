import 'package:flutter/material.dart';

class HomePageFragment extends StatelessWidget {
  final Function _changeFragment;

  HomePageFragment(this._changeFragment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
    );
  }
}