import 'package:flutter/material.dart';  
import '../service/login_service.dart';  
import 'package:mytodo/page/register.dart';  
import 'package:mytodo/page/home.dart';  

class Login extends StatefulWidget {  
  const Login({Key? key}) : super(key: key);  

  @override  
  _LoginState createState() => _LoginState();  
}  

class _LoginState extends State<Login> {  
  final TextEditingController _usernameCtrl = TextEditingController();  
  final TextEditingController _passwordCtrl = TextEditingController();  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: const Text("Login")),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [  
            TextField(  
              controller: _usernameCtrl,  
              decoration: const InputDecoration(  
                labelText: "Username",  
                border: OutlineInputBorder(),  
              ),  
            ),  
            const SizedBox(height: 16),  
            TextField(  
              controller: _passwordCtrl,  
              decoration: const InputDecoration(  
                labelText: "Password",  
                border: OutlineInputBorder(),  
              ),  
              obscureText: true,  
            ),  
            const SizedBox(height: 24),  
            ElevatedButton(  
              onPressed: () async {  
                String username = _usernameCtrl.text;  
                String password = _passwordCtrl.text;  
                bool isLogin = await LoginService().login(username, password);  
                if (isLogin) {  
                  Navigator.pushReplacement(  
                    context,  
                    MaterialPageRoute(builder: (context) => HomeScreen()),  
                  );  
                } else {  
                  showDialog(  
                    context: context,  
                    builder: (context) => AlertDialog(  
                      content: const Text("Username atau Password Tidak Valid"),  
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
              style: ElevatedButton.styleFrom(  
                minimumSize: const Size(double.infinity, 50),  
              ),  
              child: const Text("Login"),  
            ),  
            const SizedBox(height: 16),  
            Row(  
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [  
                const Text("Belum punya akun?"),  
                TextButton(  
                  onPressed: () {  
                    Navigator.push(  
                      context,  
                      MaterialPageRoute(builder: (context) => Register()),  
                    );  
                  },  
                  child: const Text("Daftar di sini"),  
                ),  
              ],  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}