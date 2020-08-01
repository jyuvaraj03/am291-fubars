import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  final bool isAuth;

  const WelcomePage(this.isAuth);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  SharedPreferences tokenPref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isAuth == false) {

    }
    else{
      
    }
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
