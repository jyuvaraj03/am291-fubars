import 'package:ClientApp/school/schoolHome.dart';
import 'package:ClientApp/school/view_reports/schoolReportHistory.dart';
import 'package:ClientApp/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/authScreen.dart';
import 'helpers/auth.dart';
import 'authentication/chooseUserType.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPreferences tokenPref;
  String tokenValue;

  //Auth auth = new Auth();

  // Future<String> getToken() async {
  //   tokenPref = await SharedPreferences.getInstance();
  //   setState(() {
  //     tokenValue = tokenPref.getString("token");
  //     print(tokenValue);
  //   });
  //   return tokenValue;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getToken();
  }

  @override
  Widget build(BuildContext context) {
    // getToken();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MyShop',
                    home: SchoolHome(), 
                    //auth.isAuth ? ChooseUserType() : AuthScreen(),
                    routes: {
                      '/AuthScreen': (BuildContext context) => AuthScreen(),
                      '/ChooseUserType': (BuildContext context) =>
                          ChooseUserType(),
                          '/SchoolReportHistory': (BuildContext context) =>
                         SchoolReportHistory(),
                    })));
  }
}
