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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: CCList(),
    );
  }
}
