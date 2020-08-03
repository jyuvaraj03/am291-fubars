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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: Text(
        "Welcome! Analytical dashboard",
      )),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Authority"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            trailing: Icon(
              Icons.view_day,
              color: Color.fromRGBO(50, 134, 103, 1),
            ),
            title: Text(
              "Reports",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/AuthorityReportHistory');
            },
          ),
          ListTile(
            trailing: Icon(
              Icons.help,
              color: Color.fromRGBO(50, 134, 103, 1),
            ),
            title: Text("Help",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            onTap: () {},
          ),
          ListTile(
              trailing: Icon(
                Icons.logout,
                color: Color.fromRGBO(50, 134, 103, 1),
              ),
              title: Text("Logout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
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
