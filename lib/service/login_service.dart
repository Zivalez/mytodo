import 'package:dio/dio.dart';  
import 'package:mytodo/helpers/user_info.dart';  

class LoginService {  
  final Dio _dio = Dio();  
  final String _apiUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/users';  

  Future<bool> login(String username, String password) async {  
    try {  
      // Cari user dengan username yang sesuai  
      Response response = await _dio.get(_apiUrl,   
        queryParameters: {  
          'username': username,  
          'password': password  
        }  
      );  

      // Cek apakah ada user yang cocok  
      if (response.data != null && response.data.isNotEmpty) {  
        // Generate token sederhana (bisa diganti dengan metode yang lebih aman)  
        String token = DateTime.now().millisecondsSinceEpoch.toString();  
        
        // Simpan token dan username  
        await UserInfo().setToken(token);  
        await UserInfo().setUsername(username);  
        
        return true;  
      } else {  
        // Login gagal  
        return false;  
      }  
    } catch (e) {  
      print('Login error: $e');  
      return false;  
    }  
  }  
}