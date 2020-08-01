import 'package:ClientApp/school/schoolHome.dart';
import 'package:ClientApp/school/view_reports/schoolReportHistory.dart';
import 'package:ClientApp/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/postSchoolCount.dart';
import 'authentication/authScreen.dart';
import 'helpers/auth.dart';
import 'authentication/chooseUserType.dart';
import 'helpers/authorityEnroll.dart';
import 'helpers/schoolEnroll.dart';
import 'helpers/authHelper.dart';
import 'school/schoolHome.dart';

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
          ChangeNotifierProxyProvider<Auth, PostSchoolCount>(
            update: (ctx, auth, _ ) => PostSchoolCount(
              auth.token,
              ),
          ),
          ChangeNotifierProxyProvider<Auth, AuthorityEnroll>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _ ) => AuthorityEnroll(
              auth.token,
              ),
          ),
          ChangeNotifierProxyProvider<Auth, SchoolEnroll>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _ ) => SchoolEnroll(
              auth.token,
              ),
          ),
          ChangeNotifierProxyProvider<Auth, AuthHelper>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _ ) => AuthHelper(
              auth.token,
              ),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MyShop',
                    home: auth.isAuth ? ChooseUserType() : AuthScreen(),
                    routes: {
                      '/AuthScreen': (BuildContext context) => AuthScreen(),
                      '/ChooseUserType': (BuildContext context) =>
                          ChooseUserType(),
                          '/SchoolReportHistory': (BuildContext context) =>
                         SchoolReportHistory(),
                         '/SchoolHomePage': (BuildContext context) => SchoolHome(),
                    }
                  )
                )
              );
  }
}
