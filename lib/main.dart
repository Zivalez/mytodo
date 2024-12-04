import 'dart:io';  
import 'package:flutter/material.dart';  
import 'package:mytodo/page/home.dart';  
import 'package:mytodo/page/profile.dart';  
import 'package:mytodo/page/search.dart';  
import 'package:mytodo/page/todo.dart';  
import 'package:mytodo/page/notes.dart';  
import 'package:provider/provider.dart';  
import 'package:mytodo/page/themeprovider.dart';  
import 'package:mytodo/page/login.dart';  
import 'package:mytodo/page/register.dart';
import 'package:mytodo/helpers/user_info.dart';  

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
    TodoScreen(),  
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

void main() async {  
  HttpOverrides.global = MyHttpOverrides();  
  
  WidgetsFlutterBinding.ensureInitialized();  
  String? token = await UserInfo().getToken();  
  
  runApp(  
    ChangeNotifierProvider(  
      create: (context) => ThemeProvider(),   
      child: MyApp(isLoggedIn: token != null),
    ),
  );  
}  

class MyApp extends StatelessWidget {  
  final bool isLoggedIn;  
  
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);  

  @override  
  Widget build(BuildContext context) {  
    return Consumer<ThemeProvider>(  
      builder: (context, themeProvider, child) {  
        return MaterialApp(  
          title: 'My To-Do App',  
          theme: themeProvider.lightTheme,  
          darkTheme: themeProvider.darkTheme,  
          themeMode: themeProvider.themeMode,  
          home: isLoggedIn ? MainApp() : Login(),  
          routes: {  
            '/login': (context) => Login(),  
            '/register': (context) => RegisterScreen(),  
          },  
        );
      },  
    );
  }  
}  