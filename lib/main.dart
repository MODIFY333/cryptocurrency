import 'package:cryptocurrency/CCList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CCTracker());
}

class CCTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Tracker',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal[400],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.amber[700],
      ),
      home: CCList(),
    );
  }
}
