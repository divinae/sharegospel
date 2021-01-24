import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/ui/video_player/youtube_card.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../resources/consts.dart';

class GospelFragment extends StatefulWidget {
  const GospelFragment();

  @override
  _GospelFragmentState createState() => _GospelFragmentState();
}

class _GospelFragmentState extends State<GospelFragment> {
  var logger = Logger();
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(GOSPEL_YOUTUBE_LINK);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        YoutubeCard(
          controller: _controller,
          title: GOSPEL_YOUTUBE_TITLE,
        ),
        Divider(height: 4, color: Colors.transparent),
        Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(GOSPEL_IMAGE_PATH)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  GOSPEL_TEXT,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 15,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
