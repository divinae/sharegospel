import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        ? ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      YoutubeCard(
                        controller: _controller,
                        title: GOSPEL_YOUTUBE_TITLE,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      )
                    ],
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text:
                      "        Bóg stworzył człowieka, aby mieć z nim wieczną relację."
                      " Jednak w swoim życiu decydujemy przeciwstawić się mu."
                      " Odwracamy się od niego, co przez biblię nazwane jest"
                      " grzechem. W innym miejscu biblia mówi, że zapłatą za"
                      " grzech jest śmierć (Rzym 6:23). W ten sposób wstępujemy"
                      " na drogą której końcem jest wieczne potępienie.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "\n        Robiąc dobre uczynki czy wykonując religijne"
                            " obrzędy próbujemy się usprawiedliwiać, lub pomijając"
                            " Boga szukamy szczęścia w rzeczach materialnych, czy"
                            " sukcesie. Lecz własnymi siłami nie możemy pokonać"
                            " przepaści oddzielającej nas od Boga. "),
                    TextSpan(
                        text:
                            "\n        Na szczęście Bóg znalazł rozwiązanie. Zesłał na"
                            " świat swojego syna Jezusa Chrystusa. On wyzbywając"
                            " się swojej Boskiej natury stał się człowiekiem. Żył"
                            " bezgrzesznym życiem i mimo braku winy został zabity"
                            " na krzyżu. Złożył ofiarę za grzechy wszystkich ludzi."
                            " Bóg dając potwierdzenie przyjęcia tej ofiary"
                            " wskrzesił go i postawił po swojej prawicy, dając mu"
                            " wszelką władzę na ziemi i niebie."),
                    TextSpan(
                        text:
                            "\n        W tym momencie stoimy przed wyborem. Możemy"
                            " wciąż pokładać nadzieję we własnych siłach, lub"
                            " uwierzyć i przyjąć ofiarę Jezusa. Biblia mówi, że"
                            " kto ustami wyzna Jezusa Panem i uwierzy w swoim"
                            " sercu, że Bóg wskrzesił go z martwych, będzie"
                            " zbawiony (Rzym 10:9)."),
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage("assets/ewangelia.png"),
                height: 200,
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
