import '../helpers/user_info.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  

class LoginService {
  Future<bool> register(String username, String password) async {  
    final response = await http.post(  
      Uri.parse('https://yourapi.com/register'), // Ganti dengan URL API Anda  
      headers: {"Content-Type": "application/json"},  
      body: json.encode({"username": username, "password": password}),  
    );  

    return response.statusCode == 201; // Cek jika registrasi berhasil  
  } 
  
  Future<bool> login(String username, String password) async {  
    bool isLogin = false;  

    // Cek username dan password  
    if (username == 'admin' && password == 'admin') {  
      await UserInfo().setToken("admin");  
      await UserInfo().setUserID("1");  
      await UserInfo().setUsername("admin");  
      isLogin = true;  
    }  
    return isLogin;  
  }  
}