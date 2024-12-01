import 'package:dio/dio.dart';  

class ProfileService {  
  final Dio _dio = Dio();  
  final String _apiUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/users';  

  Future<bool> updateProfile({  
    required String currentUsername,   
    required String newUsername,   
    String? newPassword  
  }) async {  
    try {  
      Response searchResponse = await _dio.get(_apiUrl,   
        queryParameters: {'username': currentUsername}  
      );  

      if (searchResponse.data == null || searchResponse.data.isEmpty) {  
        return false;  
      }  

      String userId = searchResponse.data[0]['id'];  

      Map<String, dynamic> updateData = {  
        'username': newUsername,  
      };  
 
      if (newPassword != null && newPassword.isNotEmpty) {  
        updateData['password'] = newPassword;  
      }  

      Response updateResponse = await _dio.put(  
        '$_apiUrl/$userId',   
        data: updateData  
      );  

      return updateResponse.data != null;  
    } catch (e) {  
      print('Update profile error: $e');  
      return false;  
    }  
  }  
}