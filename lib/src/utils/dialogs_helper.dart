import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharegospel/src/bloc/add_share_bloc.dart';
import 'package:sharegospel/src/bloc/add_share_event.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/ui/widgets/dialog_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharegospel/generated/locale_keys.g.dart';
import 'logger.dart';

class DialogHelper {
  static _setLanguage(BuildContext context, int index) {
    logger.d("setLanguage $index");
    switch (index) {
      case 0:
        EasyLocalization.of(context).setLocale(Locale('en'));
        break;
      case 1:
        EasyLocalization.of(context).setLocale(Locale('pl'));
        break;
      case 2:
        EasyLocalization.of(context).setLocale(Locale('ru'));
        break;
      default:
        EasyLocalization.of(context).setLocale(Locale('en'));
        break;
    }
  }

  static chooseLanguage(BuildContext parentContext) async {
    logger.d("chooseLanguage");

    ScrollController scrollController = ScrollController();
    List<GroupModel> _group = [];
    int index = 0;

    _group.addAll([
      GroupModel(text: LocaleKeys.english.tr(), index: index++),
      GroupModel(text: LocaleKeys.polish.tr(), index: index++),
      GroupModel(text: LocaleKeys.russian.tr(), index: index++),
    ]);

    await showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        int selectedRadio;
        var _screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  width: kIsWeb
                      ? _screenWidth > MAX_SCREEN_WIDTH
                          ? MAX_DIALOG_WIDTH
                          : _screenWidth
                      : _screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocaleKeys.chooseCity.tr(),
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(0),
                          itemCount: _group == null ? 1 : _group.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile(
                              title: Text("${_group[index].text}"),
                              groupValue: selectedRadio,
                              value: _group[index].index,
                              onChanged: (index) {
                                logger.d("select_radio set state");
                                setState(
                                  () {
                                    selectedRadio = index;
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DialogButton(
                              text: LocaleKeys.cancel.tr(),
                              width: 120.0,
                              isPositive: false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                            ),
                            DialogButton(
                              text: LocaleKeys.ok.tr(),
                              width: 120.0,
                              isPositive: true,
                              onPressed: () {
                                _setLanguage(parentContext, selectedRadio);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static loadCity(BuildContext parentContext) async {
    logger.d("loadCity");

    ScrollController scrollController = ScrollController();
    List<GroupModel> _group = [];
    int index = 0;

    await FirebaseFirestore.instance
        .collection(getCitiesDB())
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      var documents = snapshot.docs;
      documents.sort((a, b) => a
          .data()[CITY_NAME_KEY]
          .toString()
          .toLowerCase()
          .compareTo(b.data()[CITY_NAME_KEY].toString().toLowerCase()));
      documents.forEach((document) => _group.add(GroupModel(
            text: document.data()[CITY_NAME_KEY],
            index: index++,
          )));

      _group.add(GroupModel(
        text: LocaleKeys.addNewCity.tr(),
        index: index++,
      ));
    });

    await showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        var _screenWidth = MediaQuery.of(context).size.width;

        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 400,
                    width: kIsWeb
                        ? _screenWidth > MAX_SCREEN_WIDTH
                            ? MAX_DIALOG_WIDTH
                            : _screenWidth
                        : _screenWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(LocaleKeys.chooseCity.tr(),
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Divider(),
                        Expanded(
                          child: Scrollbar(
                            radius: Radius.circular(20),
                            controller: scrollController,
                            isAlwaysShown: true,
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(0),
                              itemCount: _group == null ? 1 : _group.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return RadioListTile(
                                  title: Text("${_group[index].text}"),
                                  groupValue: selectedRadio,
                                  value: _group[index].index,
                                  onChanged: (index) {
                                    logger.d("select_radio set state");
                                    setState(
                                      () {
                                        selectedRadio = index;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DialogButton(
                            text: LocaleKeys.ok.tr(),
                            width: 300.0,
                            isPositive: true,
                            onPressed: () {
                              if (_group[selectedRadio].text ==
                                  LocaleKeys.addNewCity.tr()) {
                                Navigator.pop(context);
                                addNewCity(parentContext);
                              } else {
                                parentContext.read<UserDataBloc>().add(
                                    SetCityEvent(_group[selectedRadio].text));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static changeCity(BuildContext parentContext) async {
    logger.d("changeCity");

    ScrollController scrollController = ScrollController();
    List<GroupModel> _group = [];
    int index = 0;

    await FirebaseFirestore.instance
        .collection(getCitiesDB())
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      var documents = snapshot.docs;
      documents.sort((a, b) => a
          .data()[CITY_NAME_KEY]
          .toString()
          .toLowerCase()
          .compareTo(b.data()[CITY_NAME_KEY].toString().toLowerCase()));
      documents.forEach((document) => _group.add(GroupModel(
            text: document.data()[CITY_NAME_KEY],
            index: index++,
          )));

      _group.add(GroupModel(
        text: LocaleKeys.addNewCity.tr(),
        index: index++,
      ));
    });

    await showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        int selectedRadio;
        var _screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 400,
                  width: kIsWeb
                      ? _screenWidth > MAX_SCREEN_WIDTH
                          ? MAX_DIALOG_WIDTH
                          : _screenWidth
                      : _screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocaleKeys.chooseCity.tr(),
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      Divider(),
                      Expanded(
                        child: Scrollbar(
                          radius: Radius.circular(20),
                          controller: scrollController,
                          isAlwaysShown: true,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(0),
                            itemCount: _group == null ? 1 : _group.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile(
                                title: Text("${_group[index].text}"),
                                groupValue: selectedRadio,
                                value: _group[index].index,
                                onChanged: (index) {
                                  logger.d("select_radio set state");
                                  setState(() {
                                    selectedRadio = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DialogButton(
                              text: LocaleKeys.cancel.tr(),
                              width: 120.0,
                              isPositive: false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                            ),
                            DialogButton(
                              text: LocaleKeys.ok.tr(),
                              width: 120.0,
                              isPositive: true,
                              onPressed: () {
                                if (_group[selectedRadio].text ==
                                    LocaleKeys.addNewCity.tr()) {
                                  Navigator.pop(context);
                                  addNewCity(parentContext);
                                } else {
                                  parentContext.read<UserDataBloc>().add(
                                      SetCityEvent(_group[selectedRadio].text));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static addNewCity(BuildContext parentContext) async {
    logger.d("addNewCity");

    await showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        var _screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: kIsWeb
                      ? _screenWidth > MAX_SCREEN_WIDTH
                          ? MAX_DIALOG_WIDTH
                          : _screenWidth
                      : _screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(LocaleKeys.addNewCity.tr(),
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DialogButton(
                              text: LocaleKeys.cancel.tr(),
                              width: 120.0,
                              isPositive: false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                            ),
                            DialogButton(
                              text: LocaleKeys.ok.tr(),
                              width: 120.0,
                              isPositive: true,
                              onPressed: () {
                                parentContext.read<UserDataBloc>().add(
                                    CreateCityEvent(
                                        controller.value.text.trim()));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static addNewShare(BuildContext parentContext) {
    logger.d("addNewCity");

    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        var _screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: kIsWeb
                  ? _screenWidth > MAX_SCREEN_WIDTH
                      ? MAX_DIALOG_WIDTH
                      : _screenWidth
                  : _screenWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(LocaleKeys.add.tr(),
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(LocaleKeys.beenSaved.tr(),
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DialogButton(
                          text: LocaleKeys.cancel.tr(),
                          width: 100.0,
                          isPositive: false,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DialogButton(
                              text: LocaleKeys.no.tr(),
                              width: 60.0,
                              isPositive: false,
                              onPressed: () {
                                parentContext
                                    .read<AddShareBloc>()
                                    .add(AddShareEvent(false));
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                            ),
                            DialogButton(
                              text: LocaleKeys.yes.tr(),
                              width: 60.0,
                              isPositive: true,
                              onPressed: () {
                                parentContext
                                    .read<AddShareBloc>()
                                    .add(AddShareEvent(true));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
