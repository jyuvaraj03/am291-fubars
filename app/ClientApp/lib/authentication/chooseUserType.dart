import 'package:flutter/material.dart';

import './userSignUp.dart';

class ChooseUserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 40, 49, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "Continue As",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    color: Color.fromRGBO(75, 200, 210, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      // SignUp user with authority details
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => UserSignUp("Authority")));
                    },
                    child: Text(
                      "Authority",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    )),
                SizedBox(width: 20),
                RaisedButton(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    color: Color.fromRGBO(75, 200, 210, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      //sign up user with school details
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserSignUp("Reporter")));
                    },
                    child: Text(
                      "Reporter",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
