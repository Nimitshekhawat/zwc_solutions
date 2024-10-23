import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/screens/Dashboard_screen.dart';
import 'customwidgets.dart'; // Import your custom Text widget
import 'login.dart'; // Import the screen you are navigating to

class SplashScreen extends StatefulWidget {
  // const SplashScreen({super.key});



  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var continuetapbtn = false;
  static const String  KEYLOGIN ="login";

  @override
  void initState() {
    super.initState();

    whereToGo();
    // // Navigate to the login screen after a 7-second delay, if the button wasn't tapped
    // if (!continuetapbtn) {
    //   Future.delayed(const Duration(seconds: 2), () {
    //     if (!continuetapbtn) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const Login()),
    //       );
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),

                // App Logo
                Container(
                  height: 100,
                  child: Image.asset("assets/images/ZWC_logo.png"),
                ),
                SizedBox(height: 40),

                // Splash Screen Text
                Center(
                  child: Textpoppins400_16(
                    fontsize: 20,
                    text: "Where Sustainability Meets",
                    fontweight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Textpoppins400_16(
                    fontsize: 20,
                    text: "Innovation",
                    fontweight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 10),

                // Earth Image
                Container(
                  height: 220,
                  child: Image.asset("assets/images/splashscreen_earth.png"),
                ),

                SizedBox(height: 50),

                // Tagline Text
                Center(
                  child: Textpoppins400_16(
                    fontsize: 24,
                    text: "Waste Assessment for a",
                    fontweight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Textpoppins400_16(
                    fontsize: 24,
                    text: "Greener Future",
                    fontweight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                Spacer(),

                // Get Started Button
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       setState(() {
                //         continuetapbtn = true; // Mark the button as tapped
                //       });
                //
                //       Navigator.of(context).pushAndRemoveUntil(
                //         MaterialPageRoute(builder: (context) => const Login()),
                //             (Route<dynamic> route) => false, // Remove all previous routes
                //       );
                //     },
                //     child: Container(
                //       height: 60,
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF37B943),
                //         borderRadius: BorderRadius.circular(20),
                //         boxShadow: [
                //           BoxShadow(
                //             blurRadius: 1,
                //             spreadRadius: 1.6,
                //             color: Colors.black54,
                //           )
                //         ],
                //         border: Border.all(width: 0.5, color: Colors.black),
                //       ),
                //       child: Center(
                //         child: Textpoppins400_16(
                //           fontsize: 19,
                //           text: "Get Started",
                //           fontweight: FontWeight.bold,
                //           color: Colors.white,
                //           textoverflow: TextOverflow.visible,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),


                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void whereToGo() async{

    var sharedPref=await SharedPreferences.getInstance();
    
    var isLoggedIn=sharedPref.getBool(KEYLOGIN);

    Timer(Duration(seconds: 2),(){
      if(isLoggedIn!=null){
        if(isLoggedIn){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>DashboardScreen()));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>Login()));
        }
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=>Login()));
      }

    });
  }


}


