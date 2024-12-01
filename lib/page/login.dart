import 'package:flutter/material.dart';  
import '../service/login_service.dart'; 
import 'package:mytodo/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);  

  @override  
  _LoginState createState() => _LoginState();  
}

class _LoginState extends State<Login> {  
  final _formKey = GlobalKey<FormState>();  
  final _usernameCtrl = TextEditingController();  
  final _passwordCtrl = TextEditingController();  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: Center(  
        child: Form(  
          key: _formKey,  
          child: Padding(  
            padding: const EdgeInsets.all(20.0),  
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [  
                _usernameField(),  
                const SizedBox(height: 20),  
                _passwordField(),  
                const SizedBox(height: 20),  
                _tombolLogin(),  
                const SizedBox(height: 10),  
                _tombolRegister(),   
              ],  
            ),  
          ),  
        ),  
      ),  
    );  
  }  

  // Tambahkan method _usernameField  
  Widget _usernameField() {  
    return TextFormField(  
      decoration: const InputDecoration(  
        labelText: 'Username',  
        border: OutlineInputBorder(),  
      ),  
      controller: _usernameCtrl,  
      validator: (value) {  
        if (value == null || value.isEmpty) {  
          return 'Username tidak boleh kosong';  
        }  
        return null;  
      },  
    );  
  }  

  // Tambahkan method _passwordField  
  Widget _passwordField() {  
    return TextFormField(  
      obscureText: true,  
      decoration: const InputDecoration(  
        labelText: 'Password',  
        border: OutlineInputBorder(),  
      ),  
      controller: _passwordCtrl,  
      validator: (value) {  
        if (value == null || value.isEmpty) {  
          return 'Password tidak boleh kosong';  
        }  
        return null;  
      },  
    );  
  }  

  // Tambahkan method _tombolLogin  
  Widget _tombolLogin() {  
    return ElevatedButton(  
      child: const Text('Login'),  
      onPressed: () async {  
        if (_formKey.currentState!.validate()) {  
          String username = _usernameCtrl.text;  
          String password = _passwordCtrl.text;  

          await LoginService().login(username, password).then((value) {  
            if (value) {  
              // Ganti ke MainApp() bukan HomeScreen  
              Navigator.pushReplacement(  
                context,  
                MaterialPageRoute(builder: (context) => MainApp()),  
              );  
            } else {  
              ScaffoldMessenger.of(context).showSnackBar(  
                const SnackBar(  
                  content: Text('Username atau Password Salah'),  
                  backgroundColor: Colors.red,  
                ),  
              );  
            }  
          });  
        }  
      },  
    );  
  }

  // Tambahkan method _tombolRegister  
  Widget _tombolRegister() {  
    return TextButton(  
      child: const Text('Belum punya akun? Daftar'),  
      onPressed: () {  
        // Navigasi ke halaman register  
        Navigator.pushNamed(context, '/register');  
      },  
    );  
  }  
}