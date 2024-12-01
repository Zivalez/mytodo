import 'package:shared_preferences/shared_preferences.dart';  

class UserInfo {  
  // Simpan token login  
  Future<void> setToken(String token) async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.setString('login_token', token);  
  }  

  // Ambil token login  
  Future<String?> getToken() async {  
    final prefs = await SharedPreferences.getInstance();  
    return prefs.getString('login_token');  
  }  

  // Hapus token (logout)  
  Future<void> clearToken() async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.remove('login_token');  
  }  

  // Simpan username  
  Future<void> setUsername(String username) async {  
    final prefs = await SharedPreferences.getInstance();  
    await prefs.setString('username', username);  
  }  

  // Ambil username  
  Future<String?> getUsername() async {  
    final prefs = await SharedPreferences.getInstance();  
    return prefs.getString('username');  
  }  
}