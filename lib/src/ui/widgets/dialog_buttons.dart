import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({this.text, this.width, this.isPositive, this.onPressed});

  final String text;
  final double width;
  final bool isPositive;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: width,
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: isPositive
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : Colors.white
                  : MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black54),
        ),
        color: isPositive
            ? Theme.of(context).accentColor
            : Theme.of(context).dividerColor,
      ),
    );
  }
}
