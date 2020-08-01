import 'package:flutter/material.dart';

import 'authentication/authScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MDM app",
      home: AuthScreen(),
    );
  }
}