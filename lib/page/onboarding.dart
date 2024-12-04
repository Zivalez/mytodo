import 'package:flutter/material.dart';
import 'package:mytodo/page/home.dart';
import 'package:mytodo/page/todo.dart';
import 'package:mytodo/page/notes.dart';
import 'package:mytodo/page/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytodo/page/login.dart';

class Onboarding extends StatelessWidget {
  final _controller = PageController();

  Future<void> _onboardingCompleted(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 243, 231),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500,
            child: PageView(
              controller: _controller,
              children: [
                HomeScreen(),
                TodoScreen(),
                NotesScreen(),
                ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}