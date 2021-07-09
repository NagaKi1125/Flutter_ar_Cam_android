import 'package:shared_preferences/shared_preferences.dart';
class UserPreferences {
  static SharedPreferences _preferences;
  static const  _keyLogin = '_isLogin';
  static const _keyToken ='_token';
  static const _BASE_URL = '_BASE_URL';
  static const _userId = '_userId';
  static const _userName = '_userName';
  static const _likeList = '_likeList';


  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setLoginStatus(bool _isLogin) async =>
      await _preferences.setBool(_keyLogin, _isLogin);
  static bool getLoginStatus() =>_preferences.getBool(_keyLogin);

  static Future setToken(String _token) async =>
      await _preferences.setString(_keyToken, _token);
  static String getToken() => _preferences.getString(_keyToken);

  static Future setBaseURL(String _URL) async =>
      await _preferences.setString(_BASE_URL, _URL);
  static String getBaseURL() => _preferences.getString(_BASE_URL);

  static Future setUserId(String id) async =>
    await _preferences.setString('_userId', id);
  static String getUserId() => _preferences.getString(_userId);

  static Future setUserName(String name) async =>
      await _preferences.setString(_userName, name);
  static String getUserName() => _preferences.getString(_userName);

  static Future setLikedList(String list) async =>
      await _preferences.setString(_likeList, list);
  static String getLikedList() => _preferences.getString(_likeList);
}