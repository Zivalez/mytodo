import 'package:flutter/material.dart';  

class ProfileScreen extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        centerTitle: true,
        title: Text('Profile'),  
      ),  
      body: Center(  
        child: Text('Profile Page'),  
      ),  
    );  
  }  
}  