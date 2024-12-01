import 'package:flutter/material.dart';  
import '../service/login_service.dart'; // Pastikan untuk mengimpor LoginService  

class Register extends StatefulWidget {  
  const Register({Key? key}) : super(key: key);  

  @override  
  _RegisterState createState() => _RegisterState();  
}  

class _RegisterState extends State<Register> {  
  final TextEditingController _usernameCtrl = TextEditingController();  
  final TextEditingController _passwordCtrl = TextEditingController();  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: const Text("Register")),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          children: [  
            TextField(  
              controller: _usernameCtrl,  
              decoration: const InputDecoration(labelText: "Username"),  
            ),  
            TextField(  
              controller: _passwordCtrl,  
              decoration: const InputDecoration(labelText: "Password"),  
              obscureText: true,  
            ),  
            ElevatedButton(  
              onPressed: () async {  
                String username = _usernameCtrl.text;  
                String password = _passwordCtrl.text;  
                bool isRegistered = await LoginService().register(username, password);  
                if (isRegistered) {  
                  Navigator.pop(context); // Kembali ke halaman login  
                } else {  
                  // Tampilkan pesan error  
                  showDialog(  
                    context: context,  
                    builder: (context) => AlertDialog(  
                      content: const Text("Registrasi gagal"),  
                      actions: [  
                        TextButton(  
                          onPressed: () => Navigator.of(context).pop(),  
                          child: const Text("OK"),  
                        ),  
                      ],  
                    ),  
                  );  
                }  
              },  
              child: const Text("Register"),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}