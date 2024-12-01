import 'dart:io';  
import 'package:flutter/material.dart';  
import 'package:mytodo/page/home.dart';  
import 'package:mytodo/page/profile.dart';  
import 'package:mytodo/page/search.dart';  
import 'package:mytodo/page/todo.dart';  
import 'package:mytodo/page/notes.dart';  
import 'package:provider/provider.dart';  
import 'package:mytodo/page/themeprovider.dart';  
import 'package:mytodo/helpers/user_info.dart'; // Import UserInfo untuk memeriksa token  
import 'package:mytodo/page/login.dart'; // Import halaman login  

class MyHttpOverrides extends HttpOverrides {  
  @override  
  HttpClient createHttpClient(SecurityContext? context) {  
    return super.createHttpClient(context)  
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;  
  }  
}  

class MainApp extends StatefulWidget {  
  @override  
  _MainAppState createState() => _MainAppState();  
}  

class _MainAppState extends State<MainApp> {  
  int _selectedIndex = 0;  

  static List<Widget> _pages = <Widget>[  
    HomeScreen(),  
    TodoPage(),  
    NotesScreen(),  
    SearchScreen(),  
    ProfileScreen(),  
  ];  

  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: IndexedStack(  
        index: _selectedIndex,  
        children: _pages,  
      ),  
      bottomNavigationBar: NavigationBar(  
        height: 70,  
        selectedIndex: _selectedIndex,  
        onDestinationSelected: _onItemTapped,  
        indicatorColor: Colors.deepOrange.withOpacity(0.2),  
        destinations: const <NavigationDestination>[  
          NavigationDestination(  
            icon: Icon(Icons.home_outlined),  
            selectedIcon: Icon(Icons.home_rounded),  
            label: 'Home',  
          ),  
          NavigationDestination(  
            icon: Icon(Icons.task_outlined),  
            selectedIcon: Icon(Icons.task_rounded),  
            label: 'To-Do',  
          ),  
          NavigationDestination(  
            icon: Icon(Icons.book_outlined),  
            selectedIcon: Icon(Icons.book_rounded),  
            label: 'Notes',   
          ),  
          NavigationDestination(  
            icon: Icon(Icons.search_outlined),  
            selectedIcon: Icon(Icons.search_rounded),  
            label: 'Search',  
          ),  
          NavigationDestination(  
            icon: Icon(Icons.person_outlined),  
            selectedIcon: Icon(Icons.person_rounded),  
            label: 'Profile',   
          ),  
        ],  
      ),  
    );  
  }  
}  

Future<void> main() async {  
  // Inisialisasi HttpOverrides  
  HttpOverrides.global = MyHttpOverrides();  
  
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding diinisialisasi  
  var token = await UserInfo().getToken(); // Ambil token dari UserInfo  

  runApp(  
    ChangeNotifierProvider(  
      create: (context) => ThemeProvider(), // Gunakan ThemeProvider  
      child: MyApp(token: token), // Pass token ke MyApp  
    ),  
  );  
}  

class MyApp extends StatelessWidget {  
  final String? token; // Tambahkan parameter token  

  const MyApp({Key? key, this.token}) : super(key: key); // Constructor  

  @override  
  Widget build(BuildContext context) {  
    return Consumer<ThemeProvider>(  
      builder: (context, themeProvider, child) {  
        return MaterialApp(  
          title: 'My To-Do App',  
          theme: themeProvider.lightTheme, // Gunakan light theme dari provider  
          darkTheme: themeProvider.darkTheme, // Gunakan dark theme dari provider  
          themeMode: themeProvider.themeMode, // Gunakan themeMode dari provider  
          home: token == null ? Login() : MainApp(), // Arahkan ke Login atau MainApp  
        );  
      },  
    );  
  }  
}