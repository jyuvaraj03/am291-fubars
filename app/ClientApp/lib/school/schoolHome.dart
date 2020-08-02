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
  String todayDate;

  static const _year = 365;
  String selectedDate;
  bool dateSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedDate = _getDate();
      dateSelected = true;
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _selectDateWidget(),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 15),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Enter Today's Attendance",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 23),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(220, 220, 220, 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, right: 18),
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
                                          color: Colors.black,
                                          fontSize: 18))),
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
                                          _attendanceController.text
                                              .toString(),
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
                                      msg:
                                          "Attendance has been submitted already",
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
                      ],
                    ),
                  ),

                  // Padding(
                  //     padding: const EdgeInsets.all(15.0),
                  //     child: RaisedButton(
                  //       disabledTextColor: Colors.red,
                  //       splashColor: Color.fromRGBO(97, 227, 236, 1),
                  //       color: Color.fromRGBO(220, 220, 220, 1),
                  //       onPressed: () {
                  //         Navigator.pushNamed(
                  //             context, '/SchoolReportHistory');
                  //       },
                  //       child: Text(
                  //         "Reports History",
                  //         style: TextStyle(color: Colors.black),
                  //       ),
                  //     )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectDateWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            color: Color.fromRGBO(220, 220, 220, 1),
            onPressed: _selectDate,
            child: Row(
              children: [
                Text("Select Date"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.date_range)
              ],
            ),
          ),
          Text(
            dateSelected ? selectedDate : " ",
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(milliseconds: 100));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: _year * 10)),
        lastDate: DateTime.now().add(Duration(days: _year * 10)));
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    if (picked != null) {
      setState(() {
        selectedDate = dateFormat.format(picked);
        dateSelected = true;
      });
    }
  }
}
