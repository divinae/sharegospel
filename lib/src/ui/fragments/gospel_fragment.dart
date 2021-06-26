import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sharegospel/src/ui/video_player/youtube_card.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GospelFragment extends StatefulWidget {
  const GospelFragment();

  @override
  _GospelFragmentState createState() => _GospelFragmentState();
}

class _GospelFragmentState extends State<GospelFragment> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: LocaleKeys.howToShareLink.tr(),
      params: const YoutubePlayerParams(
        autoPlay: false,
        enableCaption: false,
        showControls: true,
        showFullscreenButton: kIsWeb ? false : true,
        privacyEnhanced: true,
        useHybridComposition: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.cue(LocaleKeys.howToShareLink.tr());

    return ListView(
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        YoutubeCard(
          controller: _controller,
          title: LocaleKeys.howToShare.tr(),
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
                    image: AssetImage(LocaleKeys.gospelImagePath.tr())),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  LocaleKeys.gospelText.tr(),
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
