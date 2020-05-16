import 'package:flutter/material.dart';
import 'dart:developer';

class ShowSelectRadio extends StatefulWidget {
  final List<GroupModel> data;

  const ShowSelectRadio(this.data);

  @override
  _ShowSelectRadioState createState() => _ShowSelectRadioState();
}

class _ShowSelectRadioState extends State<ShowSelectRadio> {
  int _currVal = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: widget.data == null ? 1 : widget.data.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile(
            title: Text("${widget.data[index].text}"),
            groupValue: _currVal,
            value: widget.data[index].index,
            onChanged: (index) {
              log("kuba: select_radio set state");
              setState(() {
                _currVal = index;
              });
            },
          );
        });
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
