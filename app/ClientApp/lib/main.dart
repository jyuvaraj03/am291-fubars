import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/authScreen.dart';
import 'helpers/auth.dart';
import 'authentication/chooseUserType.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            home: auth.isAuth ? ChooseUserType() : AuthScreen(),
            routes: {
              '/AuthScreen': (BuildContext context) => AuthScreen(),
              '/ChooseUserType': (BuildContext context) => ChooseUserType(),
            }
          )
      )
    );
  }
}