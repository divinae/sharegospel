const int MAX_SCREEN_WIDTH = 500;
const int MAX_DIALOG_WIDTH = 400;

const String APP_TITLE = "ShareGospel";

const String UUID_KEY = "uuid";

const String ADD_SHARE_ANALYTICS_EVENT = "add_share";
const String SAVED_ANALYTICS_KEY = "saved";

const String CITIES_DEV_DB = "cities_dev";
const String CITIES_DB = "cities_prod";

const String USER_DATA_BOX_KEY = "user_data_box";
const String SHARES_BOX_KEY = "shares_box";
const String DOCUMENT_ID_KEY = '__name__';
const String CITY_NAME_KEY = "city_name";
const String CITY_STATS_KEY = "stats";
const String LOCALE_KEY = "locale";
const String SHARES_COUNT_KEY = "shares_count";
const String SAVED_COUNT_KEY = "saved_count";

const String DEVICE_SHARES_COUNT_KEY = "device_shares_count";
const String DEVICE_SAVED_COUNT_KEY = "device_saved_count";

const String CHANGE_LANGUAGE_KEY = "language";

const String CITY_ASSET_PATH = "assets/city.png";
const String PERSON_ASSET_PATH = "assets/person.png";
const String NO_INTERNET_ASSET_PATH = "assets/no_internet.png";

const List<String> HOME_SLIDER_IMAGES_PATHS = [
  'assets/slider_1.jpg',
  'assets/slider_2.jpg',
  'assets/slider_3.jpg'
];

const Map<String, dynamic> EMPTY_SHARES_MAP = {
  "1": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "2": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "3": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "4": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "5": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "6": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "7": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "8": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "9": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "10": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "11": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0},
  "12": {SHARES_COUNT_KEY: 0, SAVED_COUNT_KEY: 0}
};

const Map<String, int> EMPTY_PERSONAL_SHARES_MAP = {
  "1": 0,
  "2": 0,
  "3": 0,
  "4": 0,
  "5": 0,
  "6": 0,
  "7": 0,
  "8": 0,
  "9": 0,
  "10": 0,
  "11": 0,
  "12": 0
};
