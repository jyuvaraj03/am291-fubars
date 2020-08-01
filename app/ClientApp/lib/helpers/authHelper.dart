import 'package:flutter/cupertino.dart';

class AuthHelper with ChangeNotifier{
  final String authToken;

  AuthHelper(this.authToken);

  String returnToken(){
    print('AuthHelper : $authToken');
    return authToken;
  }
}