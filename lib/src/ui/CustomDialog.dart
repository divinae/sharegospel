import 'package:flutter/material.dart';
import 'package:sharegospel/src/ui/select_radio.dart';

class CustomDialog {
  city(BuildContext context) {
    List<GroupModel> _group = [
      GroupModel(
        text: "Flutter.dev",
        index: 1,
      ),
      GroupModel(
        text: "Inducesmile.com",
        index: 2,
      ),
      GroupModel(
        text: "Google.com",
        index: 3,
      ),
      GroupModel(
        text: "Yahoo.com",
        index: 4,
      ),
    ];

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowSelectRadio(_group),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
