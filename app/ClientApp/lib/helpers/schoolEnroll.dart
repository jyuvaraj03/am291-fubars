import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SchoolEnroll with ChangeNotifier {
  //String districtName;
  //String districtId;
  final String authToken;
  SharedPreferences userTypePref;
  SchoolEnroll(this.authToken);

  Future<void> schoolEnroll(String districtId, String name) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/schools/';
    print('school enroll token : $authToken');
    String id = districtId.toString();
    //print("Authorization": "Token {$authToken}");
    var data = new Map<String, dynamic>();
    data["district"] = id;
    data["name"] = name;
    final response = await http.post(
      url,
      body: data,
      headers: {"Authorization": "Token $authToken"},
    );
    if (response.statusCode == 201) {
      print("school enrolled");
      final userTypePref = await SharedPreferences.getInstance();
      userTypePref.setBool("isauth", false);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
