import 'package:flutter/cupertino.dart';  
import 'package:flutter/material.dart';  
import '../service/register_service.dart';  
import '../widgets/color_loader5.dart';

class RegisterScreen extends StatefulWidget {  
  final Color? primaryColor;  
  final Color? backgroundColor;  
  final AssetImage backgroundImage;  

  RegisterScreen({  
    Key? key,  
    this.primaryColor = Colors.deepOrange,  
    this.backgroundColor = Colors.white,  
    this.backgroundImage = const AssetImage("assets/images/registerdb.webp"),  
  }) : super(key: key);  

  @override  
  _RegisterScreenState createState() => _RegisterScreenState();  
}  

class _RegisterScreenState extends State<RegisterScreen> {  
  final TextEditingController _usernameController = TextEditingController();  
  final TextEditingController _passwordController = TextEditingController();  
  bool _obscureText = true;  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  
  bool _isLoading = false;  

  void _registerUser() async {  
    if (_formKey.currentState == null)

    setState(() => _isLoading = true);  

    try {   
      await Future.delayed(Duration(seconds: 2));
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
              SizedBox(height: 20),  
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
                        controller: _usernameController,  
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
                        controller: _passwordController,  
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
              SizedBox(height: 20),  
              _isLoading  
                  ? ColorLoader5()  
                  : Container(  
                      margin: const EdgeInsets.only(top: 20.0),  
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),  
                      child: Row(  
                        children: <Widget>[  
                          Expanded(  
                            child: ElevatedButton(  
                              style: ElevatedButton.styleFrom(  
                                minimumSize: Size(double.infinity, 50),  
                                backgroundColor: widget.primaryColor,  
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),  
                              ),  
                              onPressed: _registerUser,  
                              child: Text('REGISTER'),  
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
                            "Already have an account? Login",  
                            style: TextStyle(color: widget.primaryColor),  
                          ),  
                        ),  
                        onPressed: () {  
                          Navigator.pushNamed(context, '/login');  
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
