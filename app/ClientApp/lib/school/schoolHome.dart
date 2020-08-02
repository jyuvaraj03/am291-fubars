import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ClientApp/helpers/postSchoolCount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SchoolHome extends StatefulWidget {
  @override
  _SchoolHomeState createState() => _SchoolHomeState();
}

class _SchoolHomeState extends State<SchoolHome> {
  TextEditingController _attendanceController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isAttendance = false;
  SharedPreferences attendancePostPref;
  String todayDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      todayDate = _getDate();
      print(todayDate + "todayDate");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getDate() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(DateTime.now());
  }

  void _setPostStatus() async {
    final attendancePostPref = await SharedPreferences.getInstance();
    attendancePostPref.setString("date", todayDate);
    print(attendancePostPref.getString("date"));
  }

  bool _checkPostStatus() {
    if (attendancePostPref.getString("date") != _getDate()) {
      return true;
    } else {
      attendancePostPref.clear();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getDate();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(34, 40, 49, 1),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Today's Attendance",
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(220, 220, 220, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _attendanceController,
                              onSaved: (String value) {},
                              validator: (String value) {
                                return value.trim().isEmpty
                                    ? "* required"
                                    : null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Attendance",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 18))),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.green[400],
                          padding: EdgeInsets.all(8),
                          onPressed: () {
                            if (!isAttendance) {
                              Provider.of<PostSchoolCount>(context,
                                      listen: false)
                                  .postStudentCount(
                                      _attendanceController.text.toString(),
                                      _getDate());
                              setState(() {
                                isAttendance = true;
                                _attendanceController.clear();
                                //_setPostStatus();
                              });
                               Fluttertoast.showToast(
                                  msg: "Successfully submitted",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 14.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Attendance has been submitted already",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 14.0);
                            }
                          },
                          child: Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RaisedButton(
                          disabledTextColor: Colors.red,
                          splashColor: Color.fromRGBO(97, 227, 236, 1),
                          color: Color.fromRGBO(220, 220, 220, 1),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/SchoolReportHistory');
                          },
                          child: Text(
                            "Reports History",
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
