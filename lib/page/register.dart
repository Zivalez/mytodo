import 'package:flutter/material.dart';  
import 'package:mytodo/service/register_service.dart';  

class RegisterPage extends StatefulWidget {  
  const RegisterPage({Key? key}) : super(key: key);  

  @override  
  _RegisterPageState createState() => _RegisterPageState();  
}  

class _RegisterPageState extends State<RegisterPage> {   
  final TextEditingController _usernameController = TextEditingController();  
  final TextEditingController _passwordController = TextEditingController();  
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  

  bool _isLoading = false;  

  void _registerUser() async {  
    if (!_formKey.currentState!.validate()) return;  

    setState(() => _isLoading = true);  

    try {   
      final result = await RegisterService().register(  
        username: _usernameController.text.trim(),  
        password: _passwordController.text.trim(),  
      );  
 
      if (result['success']) {  
        ScaffoldMessenger.of(context).showSnackBar(  
          SnackBar(  
            content: Text(result['message']),  
            backgroundColor: Colors.green,  
          ),  
        );  

        Navigator.pushReplacementNamed(context, '/login');  
      } else {  
        ScaffoldMessenger.of(context).showSnackBar(  
          SnackBar(  
            content: Text(result['message']),  
            backgroundColor: Colors.red,  
          ),  
        );  
      }  
    } catch (e) {  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(  
          content: Text('Registrasi Gagal: $e'),  
          backgroundColor: Colors.red,  
        ),  
      );  
    } finally {  
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