import 'dart:convert';

import 'package:ClientApp/authority/pointsLineChart.dart';
import 'package:ClientApp/helpers/auth.dart';
import 'package:ClientApp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AuthorityHome extends StatefulWidget {
  //final Function showNotification;

  //const AuthorityHome(this.showNotification);
  @override
  _AuthorityHomeState createState() => _AuthorityHomeState();
}

List<charts.Series<LinearData, int>> _createSampleData(
    List<dynamic> responseData) {
  List<int> actualCount = List<int>();
  List<int> estimateCount = List<int>();

  for (int i = 0; i < responseData.length; i++) {
    actualCount.add(responseData[i]["actual"]["student_count"]);
    estimateCount.add(responseData[i]["actual"]["student_count"]);
  }

  print(actualCount);
  print(estimateCount);

  final List<LinearData> data = [];
  for (int i = 0; i < actualCount.length; i++) {
    data.add(new LinearData(i, actualCount[i]));
  }

  final List<LinearData> data2 = [];
  for (int i = 0; i < estimateCount.length; i++) {
    data.add(new LinearData(i, estimateCount[i]));
  }

  return [
    new charts.Series<LinearData, int>(
      id: 'yaxis',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (LinearData yaxis, _) => yaxis.xaxis,
      measureFn: (LinearData yaxis, _) => yaxis.yaxis,
      data: data,
    ),
    new charts.Series<LinearData, int>(
      id: 'yaxis2',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (LinearData yaxis, _) => yaxis.xaxis,
      measureFn: (LinearData yaxis, _) => yaxis.yaxis,
      data: data2,
    )
  ];
}

class LinearData {
  final int xaxis;
  final int yaxis;

  LinearData(this.xaxis, this.yaxis);
}

class _AuthorityHomeState extends State<AuthorityHome> {
  SharedPreferences tokenPref;
  SharedPreferences userTypePref;

  Auth auth = new Auth();
  List<dynamic> responseData = [];

  Future<List<dynamic>> _fetchData() async {
    final tokenPref = await SharedPreferences.getInstance();
    var authTokenn = tokenPref.getString("key");

    print(authTokenn);

    const url =
        'https://floating-badlands-95462.herokuapp.com/api/authorities/me/reports/';
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Token $authTokenn",
        "Content-Type": "application/json"
      },
    );
    var index;
    print(response.statusCode);
    responseData = jsonDecode(response.body);
    print("Authority home" + responseData.toString());
    for (int i = 0; i < responseData.length; i++) {
      if (responseData[i]['is_discrepant']) {
        index = i;
        displayNotifications(responseData[index]["school"]["name"],
            responseData[index]["for_date"]);
      }
      print(responseData[i]['is_discrepant']);
    }
    // print(responseData[0]['is_discrepant'].runtimeType);// should change everywhere

    responseData = new List<dynamic>.from(responseData);
    return responseData;
  }

  Future displayNotifications(String schoolName, String date) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Discrepancy Alert',
      '$schoolName' + ' - ' + '$date'.replaceAll("-", "/"),
      platformChannelSpecifics,
      payload: 'Reports',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("app_icon");

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    _fetchData();
  }

  Future selectNotification(String payload) async {
    print(payload);
    if (payload == "Reports")
      Navigator.pushNamed(context, "/AuthorityReportHistory");
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
      appBar: AppBar(title: Text("Authority Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15),
              child: Text(
                "Dashboard",
                style: TextStyle(
                    color: Color.fromRGBO(50, 134, 103, 1),
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1.5, color: Colors.black),
                  ),
                  child: Card(
                      color: Color.fromRGBO(222, 222, 222, 1),
                      elevation: 10,
                      child: FutureBuilder<List<dynamic>>(
                          future: _fetchData(),
                          builder: (context, snapshot) {
                            //print(snapshot.toString());
                            if (!snapshot.hasData)
                              return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 10.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 6.0,
                                ),
                              );
                            return PointsLineChart(
                                _createSampleData(snapshot.data));
                          })
                      //(child: PointsLineChart(_createSampleData(actualCount)))),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Home"),
            automaticallyImplyLeading: false,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image(image: AssetImage("assets/images/logo.png")),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "AUTHORITY",
                      style: TextStyle(
                          color: Color.fromRGBO(50, 134, 103, 1),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
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
              title: Text(
                "Help",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              onTap: () {}),
          ListTile(
              trailing: Icon(
                Icons.exit_to_app,
                color: Color.fromRGBO(50, 134, 103, 1),
              ),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                _clearPrefs();
                Phoenix.rebirth(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, "/AuthScreen", (route) => false);
              }),
        ],
      )),
    );
  }
}

//50, 134, 103, 1
