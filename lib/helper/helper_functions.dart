import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPrefUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";

  //saving data to Sharedpref

  static Future<bool> saveUserLoggedInSharedPref(bool isUserLoggedIn) async {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPrefUserLoggedInKey, isUserLoggedIn);
  }

   static Future<bool> saveUserNameSharedPref(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserNameKey, userName);
  }

  static Future saveUserEmailSharedPref(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserEmailKey, userEmail);
  }
  
  /// fetching data from sharedpreference
  static Future<bool?> getUserLoggedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPrefUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPrefUserEmailKey);
  }
}
