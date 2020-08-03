import 'package:ClientApp/authority/view_reports/reportDetail.dart';
import 'package:ClientApp/school/schoolHome.dart';
import 'package:ClientApp/school/view_reports/schoolReportHistory.dart';
import 'package:ClientApp/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'authority/authorityHome.dart';
import 'authority/view_reports/authorityReportHistory.dart';
import 'helpers/postSchoolCount.dart';
import 'authentication/authScreen.dart';
import 'helpers/auth.dart';
import 'authentication/chooseUserType.dart';
import 'helpers/authorityEnroll.dart';
import 'helpers/schoolEnroll.dart';
import 'helpers/authHelper.dart';
import 'school/schoolHome.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  SharedPreferences tokenPref;
  String tokenValue;
  bool splash = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings("app_icon");

    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    print("your payload " + payload);
  }

  void _changeSplash() {
    setState(() {
      splash = false;
    });
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    // getToken();
    //_showNotification();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, PostSchoolCount>(
            update: (ctx, auth, _) => PostSchoolCount(
              auth.token,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, AuthorityEnroll>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _) => AuthorityEnroll(
              auth.token,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, SchoolEnroll>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _) => SchoolEnroll(
              auth.token,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, AuthHelper>(
            //create: (ctx)=> UserAuthority(),
            update: (ctx, auth, _) => AuthHelper(
              auth.token,
            ),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MyShop',
                    home: FutureBuilder(
                      future: auth.getTokenPref(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.data != null) {
                          print("snapshot " + snapshot.data);
                          return FutureBuilder(
                              future: auth.getUserTypePref(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.data == true)
                                  return AuthorityHome(_showNotification);
                                else
                                  return SchoolHome();
                              });
                        } else {
                          return AuthScreen();
                        }
                      },
                    ),
                    routes: {
                      '/AuthScreen': (BuildContext context) => AuthScreen(),
                      '/ChooseUserType': (BuildContext context) =>
                          ChooseUserType(),
                      '/SchoolReportHistory': (BuildContext context) =>
                          SchoolReportHistory(),
                      '/SchoolHomePage': (BuildContext context) => SchoolHome(),
                      '/AuthorityHomePage': (BuildContext context) =>
                          AuthorityHome(_showNotification),
                      '/AuthorityReportHistory': (BuildContext context) =>
                          AuthorityReportHistory()
                    })));
  }
}
