import 'package:flutter/material.dart';  

class ThemeProvider extends ChangeNotifier {  
  ThemeMode _themeMode = ThemeMode.light;  

  ThemeMode get themeMode => _themeMode;  

  bool get isDarkMode => _themeMode == ThemeMode.dark;  

  void toggleTheme() {  
    _themeMode = _themeMode == ThemeMode.light   
        ? ThemeMode.dark   
        : ThemeMode.light;  
    notifyListeners();  
  }  

  // Light theme  
  ThemeData lightTheme = ThemeData(  
    fontFamily: 'SFProRounded',  
    brightness: Brightness.light,  
    primarySwatch: Colors.deepOrange,  
    primaryColor: Colors.deepOrange,  
    colorScheme: ColorScheme.fromSeed(  
      seedColor: Colors.deepOrange,  
      primary: Colors.deepOrange,  
      secondary: Colors.deepOrange,  
    ),  
    appBarTheme: AppBarTheme(  
      backgroundColor: Colors.deepOrange,  
      foregroundColor: Color.fromARGB(255, 247, 243, 231), 
      titleTextStyle: TextStyle(  
        fontFamily: 'SFProRounded',   
        fontSize: 20,   
        fontWeight: FontWeight.bold,  
        color: Color.fromARGB(255, 247, 243, 231), 
      ),  
    ),  
    elevatedButtonTheme: ElevatedButtonThemeData(  
      style: ElevatedButton.styleFrom(  
        backgroundColor: Colors.deepOrange,  
        foregroundColor: Color.fromARGB(255, 247, 243, 231),  
      ),  
    ),  
    textSelectionTheme: TextSelectionThemeData(  
      cursorColor: Colors.deepOrange,  
      selectionColor: Colors.deepOrange.withOpacity(0.3),  
      selectionHandleColor: Colors.deepOrange,  
    ),  
    scaffoldBackgroundColor: Color.fromARGB(255, 247, 243, 231),
  );  

  // Dark theme 
  ThemeData darkTheme = ThemeData(  
    fontFamily: 'SFProRounded',  
    brightness: Brightness.dark,  
    primarySwatch: Colors.deepOrange,  
    primaryColor: Colors.deepOrange,  
    colorScheme: ColorScheme.fromSeed(  
      brightness: Brightness.dark,  
      seedColor: Colors.deepOrange,  
      primary: Colors.deepOrange,  
      secondary: Colors.deepOrange,  
    ),  
    appBarTheme: AppBarTheme(  
      backgroundColor: Colors.deepOrange,  
      foregroundColor: Color.fromARGB(255, 247, 243, 231),   
      titleTextStyle: TextStyle(  
        fontFamily: 'SFProRounded',   
        fontSize: 20,   
        fontWeight: FontWeight.bold,  
        color: Color.fromARGB(255, 247, 243, 231), 
      ),  
    ),  
    elevatedButtonTheme: ElevatedButtonThemeData(  
      style: ElevatedButton.styleFrom(  
        backgroundColor: Colors.deepOrange,  
        foregroundColor: Color.fromARGB(255, 247, 243, 231),   
      ),  
    ),  
    textSelectionTheme: TextSelectionThemeData(  
      cursorColor: Colors.deepOrange,  
      selectionColor: Colors.deepOrange.withOpacity(0.3),  
      selectionHandleColor: Colors.deepOrange,  
    ),  
    scaffoldBackgroundColor: Colors.grey[900],  
  );  
}