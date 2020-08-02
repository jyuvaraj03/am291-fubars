import 'dart:io';

import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  final Function changeSplash;

  const WelcomePage(this.changeSplash);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  SharedPreferences tokenPref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sleep(Duration(seconds: 5));
    setState(() {
      widget.changeSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
