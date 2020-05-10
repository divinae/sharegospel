import 'package:flutter/material.dart';

class ShowSelectRadio extends StatefulWidget {
  final List<GroupModel> group;

  const ShowSelectRadio(this.group);

  @override
  _ShowSelectRadioState createState() => _ShowSelectRadioState();
}

class _ShowSelectRadioState extends State<ShowSelectRadio> {
  int _currVal = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.group
          .map((t) => RadioListTile(
                title: Text("${t.text}"),
                groupValue: _currVal,
                value: t.index,
                onChanged: (val) {
                  setState(() {
                    _currVal = val.index;
                  });
                },
              ))
          .toList(),
    );
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
