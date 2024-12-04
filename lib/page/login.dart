import 'package:flutter/cupertino.dart';  
import 'package:flutter/material.dart';
import 'package:mytodo/page/register.dart';  
import '../service/login_service.dart';   
import 'package:mytodo/main.dart';  

class Login extends StatefulWidget {  
  final Color? primaryColor;  
  final Color? backgroundColor;  
  final AssetImage backgroundImage;  

  Login({  
    Key? key,  
    this.primaryColor = Colors.deepOrange,  
    this.backgroundColor = Colors.white,  
    this.backgroundImage = const AssetImage("assets/images/todo2.jpeg"),  
  }) : super(key: key);  

  @override  
  _LoginState createState() => _LoginState();  
}  

class _LoginState extends State<Login> {  
  final _usernameCtrl = TextEditingController();  
  final _passwordCtrl = TextEditingController();  
  bool _obscureText = true;

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: SingleChildScrollView(  
        child: Container(  
          height: MediaQuery.of(context).size.height,  
          decoration: BoxDecoration(  
            color: widget.backgroundColor,  
          ),  
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.start,  
            mainAxisSize: MainAxisSize.max,  
            children: <Widget>[  
              Expanded(  
                child: ClipPath(  
                  clipper: MyClipper(),  
                  child: Container(  
                    decoration: BoxDecoration(  
                      image: DecorationImage(  
                        image: widget.backgroundImage,  
                        fit: BoxFit.cover,  
                      ),  
                    ),  
                    alignment: Alignment.center,  
                    padding: EdgeInsets.only(top: 100.0, bottom: 100.0),  
                  ),  
                ),  
              ),  
              SizedBox(height: 20), // Menambahkan ruang di atas form  
              Padding(  
                padding: const EdgeInsets.only(left: 40.0),  
                child: Text(  
                  "Username",  
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),  
                ),  
              ),  
              Container(  
                decoration: BoxDecoration(  
                  border: Border.all(  
                    color: Colors.grey.withOpacity(0.5),  
                    width: 1.0,  
                  ),  
                  borderRadius: BorderRadius.circular(20.0),  
                ),  
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  
                child: Row(  
                  children: <Widget>[  
                    Padding(  
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),  
                      child: Icon(  
                        Icons.person_outline,  
                        color: Colors.grey,  
                      ),  
                    ),  
                    Container(  
                      height: 30.0,  
                      width: 1.0,  
                      color: Colors.grey.withOpacity(0.5),  
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),  
                    ),  
                    Expanded(  
                      child: TextField(  
                        controller: _usernameCtrl,  
                        decoration: InputDecoration(  
                          border: InputBorder.none,  
                          hintText: 'Enter your username', 
                          hintStyle: TextStyle(color: Colors.grey),  
                        ),  
                      ),  
                    )  
                  ],  
                ),  
              ),  
              Padding(  
                padding: const EdgeInsets.only(left: 40.0),  
                child: Text(  
                  "Password",  
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),  
                ),  
              ),  
              Container(  
                decoration: BoxDecoration(  
                  border: Border.all(  
                    color: Colors.grey.withOpacity(0.5),  
                    width: 1.0,  
                  ),  
                  borderRadius: BorderRadius.circular(20.0),  
                ),  
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  
                child: Row(  
                  children: <Widget>[  
                    Padding(  
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),  
                      child: Icon(  
                        Icons.lock_open,  
                        color: Colors.grey,  
                      ),  
                    ),  
                    Container(  
                      height: 30.0,  
                      width: 1.0,  
                      color: Colors.grey.withOpacity(0.5),  
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),  
                    ),  
                    Expanded(
                      child: TextField(
                        controller: _passwordCtrl,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],  
                ),  
              ),  
              SizedBox(height: 20), // Menambahkan ruang di bawah form  
              Container(  
                margin: const EdgeInsets.only(top: 20.0),  
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),  
                child: Row(  
                  children: <Widget>[  
                    Expanded(  
                      child: ElevatedButton(  
                        style: ElevatedButton.styleFrom(  
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          backgroundColor: widget.primaryColor,  
                        ),  
                        child: Row(  
                          children: <Widget>[  
                            Padding(  
                              padding: const EdgeInsets.only(left: 20.0),  
                              child: Text(  
                                "LOGIN",  
                                style: TextStyle(color: Colors.white),  
                              ),  
                            ),  
                            Expanded(child: Container()),  
                            Transform.translate(  
                              offset: Offset(15.0, 0.0),  
                              child: Icon(  
                                Icons.arrow_forward,  
                                color: Colors.white,  
                              ),  
                            )  
                          ],  
                        ),  
                        onPressed: () async {  
                          if (_usernameCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty) {  
                            String username = _usernameCtrl.text;  
                            String password = _passwordCtrl.text;  

                            await LoginService().login(username, password).then((value) {  
                              if (value) {  
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
                      ),  
                    ),  
                  ],  
                ),  
              ),  
              Container(  
                margin: const EdgeInsets.only(top: 10.0),  
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),  
                child: Row(  
                  children: <Widget>[  
                    Expanded(  
                      child: TextButton(  
                        style: TextButton.styleFrom(  
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),  
                          backgroundColor: Colors.transparent,  
                        ),  
                        child: Container(  
                          padding: const EdgeInsets.only(left: 20.0),  
                          alignment: Alignment.center,  
                          child: Text(  
                            "Don't have an account? Register",  
                            style: TextStyle(color: widget.primaryColor),  
                          ),  
                        ),  
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var begin = Offset(1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        }, 
                      ),  
                    ),  
                  ],  
                ),  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}  

class MyClipper extends CustomClipper<Path> {  
  @override  
  Path getClip(Size size) {  
    Path p = Path();  
    p.lineTo(size.width, 0.0);  
    p.lineTo(size.width, size.height * 0.85);  
    p.arcToPoint(  
      Offset(0.0, size.height * 0.85),  
      radius: const Radius.elliptical(50.0, 10.0),  
      rotation: 0.0,  
    );  
    p.lineTo(0.0, 0.0);  
    p.close();  
    return p;  
  }  

  @override  
  bool shouldReclip(CustomClipper oldClipper) {  
    return true;  
  }  
}