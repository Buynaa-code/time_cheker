import 'package:shared_preferences/shared_preferences.dart';

const String userToken = "USER_TOKEN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setToken(String token) async {
    _sharedPreferences.setString('token', token);
  }

  Future<String?> getToken() async {
    return _sharedPreferences.getString('token');
  }

  Future<void> logout() async {
    _sharedPreferences.remove(userToken);
  }
}
