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
  DateTime pickedDate;

  static const _year = 365;
  String selectedDate;
  bool dateSelected = false;

  var weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (weekDays.contains(DateFormat('E').format(DateTime.now()))) {
        selectedDate = _getDate();
        dateSelected = true;
        pickedDate = DateTime.now();
      } else {
        Fluttertoast.showToast(
            msg: "Today is not a Week Day",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 14.0);
      }
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
        drawer: _buildDrawer(),
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
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _selectDateWidget(),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter Attendance",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 18, right: 18, bottom: 10, top: 10),
                        padding: EdgeInsets.all(2),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _attendanceController,
                            validator: (String value) {
                              return value.trim().isEmpty ? "* required" : null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
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
                          _submitData();
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
          ),
        ),
      ),
    );
  }

  void _submitData() {
    if (!dateSelected || !_formKey.currentState.validate()) {
      Fluttertoast.showToast(
          msg: "Please Enter Valid Data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);

      return;
    }
    if (dateSelected) {
      Provider.of<PostSchoolCount>(context, listen: false).postStudentCount(
          _attendanceController.text.toString(), selectedDate);
      setState(() {
        _attendanceController.clear();
      });
      return;
    }
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
            dateSelected ? DateFormat("yMMMMd").format(pickedDate) : " ",
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
        if (weekDays.contains(DateFormat('E').format(picked))) {
          selectedDate = dateFormat.format(picked);
          pickedDate = picked;
          dateSelected = true;
        } else {
          Fluttertoast.showToast(
              msg: "Selected Day is not a Week Day",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 14.0);
        }
      });
    }
  }

  Widget _buildDrawer() {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text("SIH"),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          title: Text("Reports"),
          onTap: () {
            Navigator.pushNamed(context, '/SchoolReportHistory');
          },
        ),
        ListTile(
          title: Text("Settings"),
          onTap: () {},
        ),
        ListTile(title: Text("Help"), onTap: () {})
      ],
    ));
  }
}
