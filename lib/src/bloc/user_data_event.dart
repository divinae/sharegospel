abstract class UserDataEvent {}

class SetCityEvent extends UserDataEvent {
  final String data;

  SetCityEvent(this.data);
}

class CreateCityEvent extends UserDataEvent {
  final String data;

  CreateCityEvent(this.data);
}

class InitUserDataEvent extends UserDataEvent {}
