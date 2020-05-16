import 'package:flutter/material.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/ui/select_radio.dart';

class CustomDialog {
  city(BuildContext context, List<GroupModel> group) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(CHOOSE_CITY,
                          style: Theme.of(context).textTheme.title),
                    ),
                    Expanded(child: ShowSelectRadio(group)),
                    SizedBox(
                      width: 300.0,
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
