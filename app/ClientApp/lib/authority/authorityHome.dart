import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class AuthorityHome extends StatefulWidget {
  @override
  _AuthorityHomeState createState() => _AuthorityHomeState();
}

class _AuthorityHomeState extends State<AuthorityHome> {
  SharedPreferences tokenPref;
  SharedPreferences userTypePref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _clearPrefs() async {
    final tokenPref = await SharedPreferences.getInstance();
    final userTypePref = await SharedPreferences.getInstance();
    setState(() {
      print("logout pref before clear" + tokenPref.getString("key"));
      tokenPref.clear();
      print("logout pref after clear" + tokenPref.getString("key"));
      userTypePref.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 40, 49, 1),
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: Text(
        "Welcome! Analytical dashboard",
      )),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(
            title: Text("SIH"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text("Reports"),
            onTap: () {
              Navigator.pushNamed(context, '/AuthorityReportHistory');
            },
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(title: Text("Help"), onTap: () {}),
          ListTile(
              title: Text("Logout"),
              onTap: () {
                _clearPrefs();
                Phoenix.rebirth(context);

                Navigator.pushNamedAndRemoveUntil(
                    context, "/AuthScreen", (route) => false);
              })
        ],
      )),
    );
  }
}
