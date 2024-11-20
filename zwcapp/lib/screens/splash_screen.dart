import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/screens/Dashboard_screen.dart';
import 'package:zwcapp/screens/new_dashboard_design.dart';
import 'customwidgets.dart'; // Import your custom Text widget
import 'login.dart'; // Import the screen you are navigating to

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var continuetapbtn = false;
  static const String KEYLOGIN = "login";

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          "assets/images/Splash_Screen.png",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN);

    // Reduced the Timer duration from 2 seconds to 1 second
    Timer(Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NewDashboardDesign()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Login()));
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }
}
