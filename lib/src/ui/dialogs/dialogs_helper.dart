import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/bloc/user_data_bloc.dart';
import 'package:sharegospel/src/bloc/user_data_event.dart';
import 'package:sharegospel/src/resources/consts.dart';
import 'package:sharegospel/src/resources/utils.dart';
import 'package:sharegospel/src/ui/data/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharegospel/src/ui/widgets/dialog_buttons.dart';

class DialogHelper {
  static var logger = Logger();

  static loadCity(BuildContext parentContext) async {
    logger.d("loadCity");

    ScrollController scrollController = ScrollController();
    List<GroupModel> _group = [];
    int index = 0;

    await FirebaseFirestore.instance
        .collection(getCitiesDB())
        .get()
        .then((QuerySnapshot snapshot) {
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
        text: ADD_NEW_CITY_TEXT,
        index: index++,
      ));
    });

    await showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        var screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 400,
                  width: screenWidth > MAX_SCREEN_WIDTH
                      ? MAX_DIALOG_WIDTH
                      : screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CHOOSE_CITY_TEXT,
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
                          text: OK_TEXT,
                          width: 300.0,
                          isPositive: true,
                          onPressed: () {
                            if (_group[selectedRadio].text ==
                                ADD_NEW_CITY_TEXT) {
                              addNewCity(parentContext);
                            } else {
                              parentContext.read<UserDataBloc>().add(
                                  SetCityEvent(_group[selectedRadio].text));
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
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

  static changeCity(BuildContext parentContext) async {
    logger.d("changeCity");

    ScrollController scrollController = ScrollController();
    List<GroupModel> _group = [];
    int index = 0;

    await FirebaseFirestore.instance
        .collection(getCitiesDB())
        .get()
        .then((QuerySnapshot snapshot) {
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
    });

    _group.add(GroupModel(
      text: ADD_NEW_CITY_TEXT,
      index: index++,
    ));

    await showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio;
        var screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 400,
                  width: screenWidth > MAX_SCREEN_WIDTH
                      ? MAX_DIALOG_WIDTH
                      : screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(CHOOSE_CITY_TEXT,
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
                              text: CANCEL_TEXT,
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
                              text: OK_TEXT,
                              width: 120.0,
                              isPositive: true,
                              onPressed: () {
                                if (_group[selectedRadio].text ==
                                    ADD_NEW_CITY_TEXT) {
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
        var screenWidth = MediaQuery.of(context).size.width;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth > MAX_SCREEN_WIDTH
                      ? MAX_DIALOG_WIDTH
                      : screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ADD_NEW_CITY_TEXT,
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
                              text: CANCEL_TEXT,
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
                              text: OK_TEXT,
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
}
