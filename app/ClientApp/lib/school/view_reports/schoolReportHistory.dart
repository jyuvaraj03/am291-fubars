import 'package:ClientApp/helpers/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'reportItem.dart';

class SchoolReportHistory extends StatefulWidget {
  @override
  _SchoolReportHistoryState createState() => _SchoolReportHistoryState();
}

class _SchoolReportHistoryState extends State<SchoolReportHistory> {
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

  Future<String> _fetchData() async{
    return "hi";
  }

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
            ReportsItem()
            // Expanded(
            //     child: FutureBuilder<List<dynamic>>(
            //         future: _fetchData(),
            //         builder: (context, snapshot) {
            //           //print(snapshot.toString());
            //           if (!snapshot.hasData) return CircularProgressIndicator();
            //           return ReportsItem();
            //         })),
          ],
        ));
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}
