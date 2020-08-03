import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PostSchoolCount with ChangeNotifier{

  final String authToken;

  PostSchoolCount(this.authToken);

  Future <void> postStudentCount (String studentCount, String todayDate) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/schools/me/reports/';
    print(authToken);
    print(studentCount);
    print(studentCount.runtimeType);
    Map data = {
      'student_count': studentCount,
      'for_date': todayDate
    };
    // responsedata.map((json) => json['item']).toList() 
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Token $authToken",
        "Content-Type": "application/json"
      },
      body: json.encode(data)
    );
    print(response.statusCode);
    print(response.body);
  }

}

//curl -H "Authorization: Token c318437a6199f547a0ba6a49bf30be30ac58f546" -X POST -d {\"student_count\":\"23\",\"items\":\"\[\{\"item\": \"idly\"\}\]\", \"for_date\": \"2020-01-03\"\"} localhost:8000/api/schools/me/reports/