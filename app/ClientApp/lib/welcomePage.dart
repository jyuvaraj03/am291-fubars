import 'dart:io';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  final String userType;

  const WelcomePage(this.userType);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sleep(Duration(seconds: 5));
    print("after sleep");
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage("assets/images/logo.png")),
      ),
    );
  }
}
