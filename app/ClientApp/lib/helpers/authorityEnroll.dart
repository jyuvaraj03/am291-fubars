import 'dart:convert';

//import 'package:admin_app/authentication/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthorityEnroll with ChangeNotifier {
  //String districtName;
  //String districtId;
  final String authToken;
  SharedPreferences userTypePref;
  AuthorityEnroll(this.authToken);

  Future<void> enroll(String districtId) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/authorities/';
    print('authority enroll token : $authToken');

    String id = districtId.toString();
    //print("Authorization": "Token {$authToken}");
    var data = new Map<String, dynamic>();
    data["district"] = id;
    final response = await http.post(
      url,
      body: data,
      headers: {"Authorization": "Token $authToken"},
    );
    if (response.statusCode == 201) {
      print("authority enrolled");
      final userTypePref = await SharedPreferences.getInstance();
      userTypePref.setBool("isauth", true);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
