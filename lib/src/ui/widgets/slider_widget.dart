import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget(this.imagePath);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.0),
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: FadeInImage(
            width: 1000,
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}
