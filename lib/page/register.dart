import 'package:flutter/material.dart';  
import 'package:mytodo/service/register_service.dart';  

class RegisterPage extends StatefulWidget {  
  const RegisterPage({Key? key}) : super(key: key);  

  @override  
  _RegisterPageState createState() => _RegisterPageState();  
}  

class _RegisterPageState extends State<RegisterPage> {  
  // Controller untuk input  
  final TextEditingController _usernameController = TextEditingController();  
  final TextEditingController _passwordController = TextEditingController();  
  
  // Form Key untuk validasi  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  

  // State loading  
  bool _isLoading = false;  

  // Method Registrasi  
  void _registerUser() async {  
    // Validasi form  
    if (!_formKey.currentState!.validate()) return;  

    // Set loading  
    setState(() => _isLoading = true);  

    try {  
      // Panggil service registrasi  
      final result = await RegisterService().register(  
        username: _usernameController.text.trim(),  
        password: _passwordController.text.trim(),  
      );  

      // Tangani hasil registrasi  
      if (result['success']) {  
        // Registrasi Berhasil  
        ScaffoldMessenger.of(context).showSnackBar(  
          SnackBar(  
            content: Text(result['message']),  
            backgroundColor: Colors.green,  
          ),  
        );  

        // Navigasi ke halaman login  
        Navigator.pushReplacementNamed(context, '/login');  
      } else {  
        // Registrasi Gagal  
        ScaffoldMessenger.of(context).showSnackBar(  
          SnackBar(  
            content: Text(result['message']),  
            backgroundColor: Colors.red,  
          ),  
        );  
      }  
    } catch (e) {  
      // Error tidak terduga  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(  
          content: Text('Registrasi Gagal: $e'),  
          backgroundColor: Colors.red,  
        ),  
      );  
    } finally {  
      // Matikan loading  
      setState(() => _isLoading = false);  
    }  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: Text('Registrasi')),  
      body: Padding(  
        padding: EdgeInsets.all(16.0),  
        child: Form(  
          key: _formKey,  
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.center,  
            children: [  
              // Input Username  
              TextFormField(  
                controller: _usernameController,  
                decoration: InputDecoration(  
                  labelText: 'Username',  
                  border: OutlineInputBorder(),  
                ),  
                validator: (value) {  
                  if (value == null || value.isEmpty) {  
                    return 'Username tidak boleh kosong';  
                  }  
                  if (value.length < 3) {  
                    return 'Username minimal 3 karakter';  
                  }  
                  return null;  
                },  
              ),  
              SizedBox(height: 16),  

              // Input Password  
              TextFormField(  
                controller: _passwordController,  
                obscureText: true,  
                decoration: InputDecoration(  
                  labelText: 'Password',  
                  border: OutlineInputBorder(),  
                ),  
                validator: (value) {  
                  if (value == null || value.isEmpty) {  
                    return 'Password tidak boleh kosong';  
                  }  
                  if (value.length < 6) {  
                    return 'Password minimal 6 karakter';  
                  }  
                  return null;  
                },  
              ),  
              SizedBox(height: 24),  

              // Tombol Registrasi  
              _isLoading   
                ? CircularProgressIndicator()  
                : ElevatedButton(  
                    onPressed: _registerUser,  
                    style: ElevatedButton.styleFrom(  
                      minimumSize: Size(double.infinity, 50),  
                    ),  
                    child: Text('Daftar'),  
                  ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}