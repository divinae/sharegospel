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
                    image: AssetImage("assets/ewangelia.png")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\t\t Na początku Bóg stworzył człowieka i chciał żyć z nim"
                  " wiecznie. Jednak w swoim życiu decydujemy przeciwstawić się"
                  " Mu, iść własną drogą. Łamiemy Boże prawo,"
                  " stając się buntownikami i właśnie to Biblia nazwa grzechem."
                  "\n\t\t W ten sposób wstępujemy na drogą, która"
                  " prowadzi do wiecznej śmierci. Grzech jest"
                  " przepaścią, która oddziela nas od Boga."
                  " Mamy potrzebę powrotu do Niego i próbujemy"
                  " to zrobić na różne sposoby: robiąc dobre uczynki,"
                  " medytując czy żyjąc według własnej filozofii."
                  " Niestety, sami nie możemy sobie pomóc."
                  "\n\t\t Jednak Bóg, który nas kocha, znalazł rozwiązanie."
                  " Zesłał na świat swojego ukochanego syna Jezusa (J 3:16),"
                  " który żył jak jeden z nas, ale nigdy nie zgrzeszył."
                  " Umarł na krzyżu, biorąc na siebie karę za grzech,"
                  " która nam się należała. Bóg wskrzesił go z martwych"
                  " i ustanowił królem."
                  "\n\t\t Teraz każdy z nas musi zdecydować."
                  " Jeśli uwierzymy, że Jezus zmartwychwstał"
                  " i uznamy go za naszego Pana, wrócimy na"
                  " drogę wiecznego życia z Bogiem (Rzym 10:9).",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
