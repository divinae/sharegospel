import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      printTime: false),
);
