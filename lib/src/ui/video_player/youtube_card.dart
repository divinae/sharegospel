import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeCard extends StatelessWidget {
  const YoutubeCard({
    Key key,
    @required this.controller,
    @required this.title,
  }) : super(key: key);

  final YoutubePlayerController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    const _player = YoutubePlayerIFrame();

    return YoutubePlayerControllerProvider(
      controller: controller,
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    child: _player,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
