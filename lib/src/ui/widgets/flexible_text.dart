import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlexibleText extends StatelessWidget {
  const FlexibleText({
    Key key,
    @required this.text,
    @required this.style,
  }) : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Text(
        text,
        overflow: kIsWeb ? TextOverflow.clip : TextOverflow.fade,
        softWrap: false,
        style: style,
      ),
    );
  }
}
