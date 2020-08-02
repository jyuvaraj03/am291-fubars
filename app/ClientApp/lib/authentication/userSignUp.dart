import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:ClientApp/helpers/auth.dart';
import 'package:ClientApp/helpers/authHelper.dart';
import 'package:ClientApp/helpers/authorityEnroll.dart';
import 'package:ClientApp/helpers/schoolEnroll.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSignUp extends StatefulWidget {
  final String userType;

  const UserSignUp(this.userType);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
 

  double minPadding = 25.0;
  var _districts = [];
  var _districtData;
  var _districtIdMap = Map<String, int>();
  var _currentItemSelected;
  var _selectedDistrict;

  Future<List<String>> _getDistrict() async {
    const url = 'http://127.0.0.1:8000/api/districts/';
    //var data = new Map<String, dynamic>();
    final response = await http.get(
      url,
    );
    _districtData = jsonDecode(response.body);
    _districts.clear();
    _districtIdMap = new Map<String, int>();
    _districtData.forEach((item) => {_districts.add(item['name'])});
    _districtData
        .forEach((item) => {_districtIdMap[item['name']] = item['id']});
    print(_districts);

    _districts = new List<String>.from(_districts);
    return _districts;
  }

//[{"id":1,"name":"Chennai"},{"id":3,"name":"Trichy"},{"id":4,"name":"Tiruvallur"},{"id":5,"name":"Vellore"}]
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(34, 40, 49, 1),
          resizeToAvoidBottomPadding: false,
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    "One more step!",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
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
                      child: FutureBuilder<List<String>>(
                          future: _getDistrict(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            return DropdownButton<String>(
                              //itemHeight: height
                              hint: Text("Select District"),
                              value: _currentItemSelected,
                              items: snapshot.data
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  _currentItemSelected = newValueSelected;
                                  _selectedDistrict = _currentItemSelected;
                                });
                              },
                            );
                          })),
                ),
                widget.userType == "Authority"
                    ? AuthoritySignUp(_districtIdMap[_selectedDistrict])
                    : ReporterSignUp(_districtIdMap[_selectedDistrict]),
              ],
            )),
          )),
    );
  }
}

// ignore: must_be_immutable
class AuthoritySignUp extends StatelessWidget {
  var minPadding = 25.0;
  int districtId;

  AuthoritySignUp(this.districtId);



  @override
  Widget build(BuildContext context) {
    var authToken =
        Provider.of<AuthHelper>(context, listen: false).returnToken();
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          color: Color.fromRGBO(75, 200, 210, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            // Authority details post in db
            print("Authority Auth token: $authToken");
            Provider.of<AuthorityEnroll>(context, listen: false)
                .enroll(districtId.toString());
            
            Navigator.pushNamedAndRemoveUntil(
                context, '/AuthorityHomePage', (route) => false);
          },
          child: Text(
            "Signup",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class ReporterSignUp extends StatelessWidget {
  var minPadding = 25.0;
  TextEditingController _schoolNameController = new TextEditingController();
  int districtId;

  ReporterSignUp(this.districtId);
  Auth auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _schoolNameController,
                  onSaved: (String value) {},
                  validator: (String value) {
                    return value.trim().isEmpty ? "* required" : null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "School Name",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 16))),
            ),
          ),
        ),
        RaisedButton(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          color: Color.fromRGBO(75, 200, 210, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            // Reporter details post in db
            print("Reporter Auth token: $auth.token");
            Provider.of<SchoolEnroll>(context, listen: false).schoolEnroll(
                districtId.toString(), _schoolNameController.text);
            Navigator.pushNamedAndRemoveUntil(
                context, '/SchoolHomePage', (route) => false);
          },
          child: Text(
            "Signup",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
