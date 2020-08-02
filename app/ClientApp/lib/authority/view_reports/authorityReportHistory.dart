import 'package:ClientApp/helpers/auth.dart';
import 'package:ClientApp/helpers/authHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './reportItem.dart';

class AuthorityReportHistory extends StatefulWidget {
  @override
  _AuthorityReportHistoryState createState() => _AuthorityReportHistoryState();
}

class _AuthorityReportHistoryState extends State<AuthorityReportHistory> {


  Auth auth = new Auth();
 List<dynamic> responseData = [];
  Future<List<dynamic>> _fetchData() async {
     var authToken = Provider.of<AuthHelper>(context, listen: false).returnToken();
    const url = 'https://floating-badlands-95462.herokuapp.com/api/authorities/me/reports/';
    final response = await http.get(
      url,
      headers: {"Authorization": "Token $authToken",
        "Content-Type": "application/json"},      
    );
    responseData = jsonDecode(response.body);
    print(responseData.length);
    for(int i=0; i<responseData.length; i++){
      print(responseData[i]["actual_items"].map((item)=>item['item']).toList().toString());
    }
    responseData = new List<dynamic>.from(responseData);
    return responseData;

  }



  var _month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  var _currentItemSelected;
  //Auth auth = new Auth();
  //List<dynamic> responseData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var date = DateTime.now();
    setState(() {
      _currentItemSelected = DateFormat.MMMM().format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(34, 40, 49, 1),
        appBar: AppBar(
          title: Text('Reports History'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 5, left: 8, right: 10),
              child: Container(
                height: 38,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(230, 230, 230, 1),
                ),
                child: DropdownButton<String>(
                  //itemHeight: height,
                  value: _currentItemSelected,
                  items: _month.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    _dropDownItemSelected(newValueSelected);
                  },
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder<List<dynamic>>(
                    future: _fetchData(),
                    builder: (context, snapshot) {
                      //print(snapshot.toString());
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return ReportsItem(snapshot.data);
                    })),
          ],
        ));
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}
