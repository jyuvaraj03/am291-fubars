import 'dart:convert';

import 'package:ClientApp/authority/pointsLineChart.dart';
import 'package:ClientApp/helpers/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class AuthorityHome extends StatefulWidget {
  
  @override
  _AuthorityHomeState createState() => _AuthorityHomeState();
}

List<charts.Series<LinearData, int>> _createSampleData(List<dynamic> responseData) {

  List<int> actualCount = List<int>();
  List<int> estimateCount = List<int>();

  
  for (int i = 0; i < responseData.length; i++) {
    actualCount.add(responseData[i]["actual"]["student_count"]);
    estimateCount.add(responseData[i]["actual"]["student_count"]);
  }

  print(actualCount);
  print(estimateCount);

    final List<LinearData>data = [];
    for( int i=0 ; i < actualCount.length; i++)
    {
      data.add(new LinearData(i, actualCount[i]));
    }
    
    final List<LinearData>data2 = [];
    for( int i=0 ; i < estimateCount.length; i++)
    {
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
    print(response.statusCode);
    responseData = jsonDecode(response.body);
    print(responseData);
        
   // print(responseData[0]['is_discrepant'].runtimeType);// should change everywhere

    responseData = new List<dynamic>.from(responseData);
    return responseData;
  }


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_fetchData();

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
      backgroundColor: Color.fromRGBO(50, 134, 103, 1),
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: Container(
            height: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Card(
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
                      return PointsLineChart(_createSampleData(snapshot.data));
                    })
              //(child: PointsLineChart(_createSampleData(actualCount)))),
            ),
          ),
         ),
      ),
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
      )
      ),
    );
    
  }
}
 
//50, 134, 103, 1