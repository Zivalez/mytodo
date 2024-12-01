import 'package:dio/dio.dart';  

class RegisterService {  
  final Dio _dio = Dio(BaseOptions(  
    baseUrl: 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/',  
    connectTimeout: Duration(seconds: 10),  
    receiveTimeout: Duration(seconds: 10),  
  ));  

  Future<Map<String, dynamic>> register({  
    required String username,   
    required String password,  
  }) async {  
    try {  
      Response response = await _dio.get('users');  

      List<dynamic> users = response.data;  
      for (var user in users) {  
        if (user['username'] == username) {  
          return {  
            'success': false,   
            'message': 'Username sudah digunakan'  
          };  
        }  
      }  

      Response registrationResponse = await _dio.post('users',   
        data: {  
          'username': username,  
          'password': password,  
          'createdAt': DateTime.now().toIso8601String(),  
        }  
      );  

      if (registrationResponse.statusCode == 201) {  
        return {  
          'success': true,   
          'message': 'Registrasi Berhasil',  
          'user': registrationResponse.data  
        };  
      } else {  
        return {  
          'success': false,   
          'message': 'Registrasi Gagal'  
        };  
      }  
    } on DioError catch (e) {   
      print('Dio Error: ${e.type}');  
      print('Error Message: ${e.message}');  

      if (e.response != null) {  
        print('Error Status: ${e.response!.statusCode}');  
        print('Error Data: ${e.response!.data}');  
      }  

      return {  
        'success': false,   
        'message': 'Terjadi Kesalahan: ${e.message}'  
      };  
    } catch (e) {  
      print('Unexpected Error: $e');  
      return {  
        'success': false,   
        'message': 'Terjadi Kesalahan Tidak Terduga'  
      };  
    }  
  }  
}