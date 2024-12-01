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
      // Cari user dengan username yang sesuai  
      Response searchResponse = await _dio.get(_apiUrl,   
        queryParameters: {'username': currentUsername}  
      );  

      // Pastikan user ditemukan  
      if (searchResponse.data == null || searchResponse.data.isEmpty) {  
        return false;  
      }  

      // Ambil ID user  
      String userId = searchResponse.data[0]['id'];  

      // Siapkan data update  
      Map<String, dynamic> updateData = {  
        'username': newUsername,  
      };  

      // Tambahkan password jika diisi  
      if (newPassword != null && newPassword.isNotEmpty) {  
        updateData['password'] = newPassword;  
      }  

      // Lakukan update  
      Response updateResponse = await _dio.put(  
        '$_apiUrl/$userId',   
        data: updateData  
      );  

      // Cek apakah update berhasil  
      return updateResponse.data != null;  
    } catch (e) {  
      print('Update profile error: $e');  
      return false;  
    }  
  }  
}