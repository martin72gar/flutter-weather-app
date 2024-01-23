import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  final SharedPreferences _pref;

  AppSession(this._pref);

  static const _cityNameKey = 'cityName';

  String? get cityName => _pref.getString(_cityNameKey);

  Future<bool> saveCityName(String n) async {
    return _pref.setString(_cityNameKey, n);
  }
}
