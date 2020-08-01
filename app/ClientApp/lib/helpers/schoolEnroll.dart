import 'dart:convert';


import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SchoolEnroll with ChangeNotifier{
  //String districtName;
  //String districtId;
  final String authToken;

  SchoolEnroll(this.authToken);
  
  Future<void> schoolEnroll(String districtId, String name) async {
    const url = 'http://127.0.0.1:8000/api/schools/';
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
    if ( response.statusCode == 201){
        print("school enrolled");
      }
      else {
        print(response.statusCode);
        print(response.body);
      }
  }
 
}