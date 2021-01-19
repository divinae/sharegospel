const int MAX_SCREEN_WIDTH = 500;

const String TITLE_TEXT = "Share Gospel";
const String HOME_PAGE_TEXT = "Strona główna";
const String GOSPEL_PAGE_TEXT = "Ewangelia";
const String ABOUT_TEXT = "O nas";

const String OK_TEXT = "OK";

const String NO_INTERNET_TEXT = "Brak połączenia z internetem.";
const String CHOOSE_CITY_TEXT = "Wybierz swoje miasto:";
const String ADD_NEW_CITY_TEXT = "Dodaj nowe miasto";
const String BEEN_SAVED_TEXT = "Czy ta osoba ogłosiła Jezusa swoim Panem?";
const String YES_TEXT = "Tak";
const String NO_TEXT = "Nie";
const String CANCEL_TEXT = "Anuluj";

const String CITY_TEXT = "Twoje miasto:";
const String CITY_COUNT_TEXT = "W twoim mieście";
const String YOUR_COUNT_TEXT = "Dzięki tobie";

const String GOSPEL_HEARD_TEXT = "Ewangelię usłyszało:";
const String INVITE_JESUS_TEXT = "Przyjęło Jezusa:";

const String ADD_TEXT = "Dodaj";

const String UUID_KEY = "uuid";

const String SHARES_DB = "shares";
const String CITIES_DB = "cities";

const String SHARES_COUNT_KEY = "shares_count";
const String SAVED_COUNT_KEY = "saved_count";

const String DEVICE_SHARES_COUNT_KEY = "device_shares_count";
const String DEVICE_SAVED_COUNT_KEY = "device_saved_count";

const String CITY_KEY = "city";
const String CITY_NAME_KEY = "name";

const String CITY_ASSET_PATH = "assets/city.png";
const String PERSON_ASSET_PATH = "assets/person.png";
const String NO_INTERNET_ASSET_PATH = "assets/no_internet.png";

const String GOSPEL_YOUTUBE_TITLE = "Jak dzielić się ewangelią?";
const String GOSPEL_YOUTUBE_LINK =
    "https://www.youtube.com/watch?v=DakbXbI-hY0";

getPeoplePostfix(int count) {
  if (count == 0) {
    return "osób";
  } else if (count == 1) {
    return "osoba";
  } else if (count <= 4) {
    return "osoby";
  } else if (count < 22) {
    return "osób";
  } else {
    String countString = count.toString();
    int lastChar = countString.codeUnitAt(countString.length - 1) - 48;
    int prevLastChar = countString.codeUnitAt(countString.length - 2) - 48;

    if (prevLastChar >= 2 && lastChar >= 2 && lastChar <= 4) {
      return "osoby";
    } else {
      return "osób";
    }
  }
}
