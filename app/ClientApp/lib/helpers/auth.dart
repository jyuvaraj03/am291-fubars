import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  bool _isAuthority;
  //String _userId;
  SharedPreferences tokenPref;
  SharedPreferences userTypePref;
  String tokenValue;

  bool get isAuthority {
    return is_auth == 'true';
  }

  String get is_auth {
    if (_isAuthority == true) {
      return 'true';
    }
    return 'false';
  }

  bool get isToken {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String username, String email, String password) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/users/';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    final response = await http.post(url, body: data);
    if (response.statusCode == 201) {
      login(username, password);

      print("Signed up");
    } else {
      print('signup failed');
      print(response.statusCode);
      print(response.body);
    }
  }

  // 'Authorization: Token _tokenId'

  Future<void> login(String username, String password) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/token/login';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    final response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print("log in " + jsonDecode(response.body).toString());
      _token = jsonDecode(response.body)['auth_token'];
      tokenPref = await SharedPreferences.getInstance();
      tokenPref.setString("key", _token);
      print('logged in');
      print("Logged in token" + _token);
      notifyListeners();
      //return _token;
    } else {
      print('login failed');
    }
    //print(token);
  }

  Future<String> getTokenPref() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenValue = prefs.getString("key");
    print("pref in auth" + tokenValue.toString());
    print("get Pref" + prefs.getString("key"));
    return tokenValue;
  }

  Future<bool> getUserTypePref() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getBool("isauth");
    print("user type " + userType.toString());
    return userType;
  }

  Future<void> actualLogin(String username, String password) async {
    const url = 'https://floating-badlands-95462.herokuapp.com/api/token/login';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    final response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      _token = jsonDecode(response.body)['auth_token'];
      print('actual logged in');
      const url1 = 'https://floating-badlands-95462.herokuapp.com/api/users/me';
      final res = await http.get(
        url1,
        headers: {
          "Authorization": "Token $_token",
          "Content-Type": "application/json"
        },
      );
      // print("actual log in" + jsonDecode(res.body));
      _isAuthority = jsonDecode(res.body)['is_authority'];
      final tokenPref = await SharedPreferences.getInstance();
      tokenPref.setString("key", _token.toString());
      final userTypePref = await SharedPreferences.getInstance();
      userTypePref.setBool("isauth", _isAuthority);
      print("user pref"+ userTypePref.getBool("isauth").toString());
      print(_isAuthority);
      notifyListeners();
      //return _token;
    } else {
      print('login failed');
    }
    //print(token);
  }
}
