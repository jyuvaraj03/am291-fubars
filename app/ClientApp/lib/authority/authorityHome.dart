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
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("No data")),
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
