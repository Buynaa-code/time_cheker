import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/web.dart';

class Constants {
  static const androidOptions =
      AndroidOptions(encryptedSharedPreferences: true);
}

var loggerPretty = Logger(
  printer: PrettyPrinter(),
);

var loggerPrettyNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
