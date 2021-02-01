import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:sharegospel/src/bloc/add_share_event.dart';
import 'package:sharegospel/src/ui/data/add_share_data.dart';

class AddShareBloc extends Bloc<AddShareEvent, AddShareData> {
  AddShareBloc() : super(null);

  var _logger = Logger();

  @override
  Stream<AddShareData> mapEventToState(AddShareEvent event) async* {
    if (event is AddShareEvent) {
      _logger.d("AddShare ${event.saved}");
      yield AddShareData(event.saved);
    }
  }
}
