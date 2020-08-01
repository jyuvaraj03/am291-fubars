import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  bool _isAuthority;
  //String _userId;

  bool get isAuthority {
    return is_auth=='true';
  }

  String get is_auth {
    if( _isAuthority == true ){
      return 'true';
    }
    return 'false';
  }

  bool get isAuth {
    return token!=null;
  }

  String get token {
    if( _token != null ){
      return _token;
    }
    return null;
  }

  Future <void> signup (String username, String email, String password) async {
    const url = 'http://127.0.0.1:8000/api/users/';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    final response = await http.post(
      url,
      body: data
    );
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

  Future <void> login (String username, String password) async {
    const url = 'http://127.0.0.1:8000/api/token/login';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    final response = await http.post(
      url,
      body: data
    );
    if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['auth_token'];
        print('logged in');
        print("Logged in token"+_token);
        notifyListeners();
        //return _token;
    } else {
      print('login failed');
    }
    //print(token);
  }

  Future <void> actualLogin (String username, String password) async {
    const url = 'http://127.0.0.1:8000/api/token/login';
    var data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    final response = await http.post(
      url,
      body: data
    );
    if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['auth_token'];
        print('logged in');
        const url1 = 'http://127.0.0.1:8000/api/users/me';
        final res = await http.get(
          url1,
          headers: {
          "Authorization": "Token $_token",
          "Content-Type": "application/json"
          }, 
        );
        _isAuthority = jsonDecode(res.body)['is_authority'];
        print(_isAuthority);
        notifyListeners();
        //return _token;
    } else {
      print('login failed');
    }
    //print(token);
  }
}

