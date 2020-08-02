import 'package:flutter/material.dart';

class AuthorityHome extends StatefulWidget {
  @override
  _AuthorityHomeState createState() => _AuthorityHomeState();
}

class _AuthorityHomeState extends State<AuthorityHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 40, 49, 1),
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Welcome! Analytical dashboard", )),
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
          ListTile(title: Text("Help"), onTap: () {})
        ],
      )),
    );
  }
}
