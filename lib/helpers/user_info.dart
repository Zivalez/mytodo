import 'package:shared_preferences/shared_preferences.dart';  

const String TOKEN = "token";  
const String USER_ID = "userID";  
const String USERNAME = "username";  

class UserInfo {  
  Future<void> setToken(String token) async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.setString(TOKEN, token);  
  }  

  Future<void> setUserID(String userID) async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.setString(USER_ID, userID);  
  }  

  Future<void> setUsername(String username) async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.setString(USERNAME, username);  
  }  

  Future<String?> getToken() async {  
    final prefs = await SharedPreferences.getInstance();  
    return prefs.getString(TOKEN);  
  }  
}