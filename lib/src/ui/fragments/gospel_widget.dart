import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/ui/fragments/video_player/youtube_card.dart';
import '../../resources/consts.dart';

class GospelWidget extends StatefulWidget {
  const GospelWidget();

  @override
  _GospelWidgetState createState() => _GospelWidgetState();
}

class _GospelWidgetState extends State<GospelWidget> {
  var logger = Logger();
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(GOSPEL_YOUTUBE_LINK)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    YoutubeCard(
                      controller: _controller,
                      title: GOSPEL_YOUTUBE_TITLE,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                    )
                  ],
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
