import 'package:flutter/material.dart';  

class SearchScreen extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        centerTitle: true,
        title: Text('Search'),  
      ),  
      body: Center(  
        child: Text('Search Page'),  
      ),  
    );  
  }  
}  