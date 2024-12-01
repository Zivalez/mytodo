import 'package:dio/dio.dart';  

class UserService {  
  final Dio _dio = Dio(BaseOptions(  
    baseUrl: 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/',  
  ));  

  Future<List<String>> getAllUsers() async {  
    try {  
      Response response = await _dio.get('users');  
      List<dynamic> users = response.data;  
      return users.map((user) => user['username'] as String).toList();  
    } catch (e) {  
      print('Error fetching users: $e');  
      return [];  
    }  
  }  
}