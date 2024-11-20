import 'dart:convert';  // Import for JSON encoding
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;  // Import http package
import 'package:shared_preferences/shared_preferences.dart'; // Import for saving token
// import 'package:zwcapp/screens/dashboard_screen.dart'; // Assuming you have a dashboard screen
import 'package:zwcapp/screens/splash_screen.dart';
import 'customwidgets.dart';
import 'new_dashboard_design.dart';





class otp_page extends StatefulWidget {
  const otp_page({super.key});

  @override
  State<otp_page> createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  static final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
  static final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
  final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';

  // Loading state
  bool _isLoading = false;

  // Method to send OTP to user's phone
  Future<void> sendOtp() async {
    final String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    // Replace with your API endpoint for sending OTP
    final url = baseurl+'user/getlogin_otp';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'phone_num': phone}),
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if OTP was successfully sent
        if (responseData['status'] == true) {
          // OTP sent successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'OTP sent successfully')),
          );
        } else {
          // Handle any specific error message
          String errorMessage = responseData['message'] ?? 'Failed to send OTP. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } else {
        // Handle response status code other than 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP. Server error.')),
        );
      }
    } catch (error) {
      // Handle exception during API call
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
  // Method to verify OTP
  Future<void> verifyOtp() async {
    final String phone = _phoneController.text.trim();
    final String otp = _otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    final url = 'https://wmaapi.zerowastecitizen.in/user/loginOTP';

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
            {'username': phone,
              'otp': otp
            }
            ),
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
        },
      );

      // Debugging: print response status and body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Check if OTP was successfully sent



        // Check the response status
        if (responseData['status'] == true) {
          final String token = responseData['token'];
          final String uid=responseData['uid'];

          // Store the token and uid securely in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('uid', uid);

          var sharedPref= await SharedPreferences.getInstance();
          sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
          NewDashboardDesignState.isloggedin=true;

          // Navigate to the dashboard or home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewDashboardDesign()),
          );
        } else {
          // Handle unsuccessful login response
          final String errorMessage = responseData['message'] ?? 'OTP verification failed.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      } else {
        // Handle HTTP error responses (not 200)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP. Status Code: ${response.statusCode}')),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      // Set loading state to false after the operation
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/background_image.png', fit: BoxFit.fitWidth,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  Container(
                    height: 100,
                    child: Image.asset("assets/images/ZWC_logo.png"),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 220,
                    child: Image.asset("assets/images/loginpage_image.png"),
                  ),
                  Container(
                    height: 40,
                    child: TextpoppinsExtraBold_18(
                        text: "Login with OTP", fontsize: 19, color: Colors.black
                    ),
                  ),
                  SizedBox(height: 30),
                  text_field(
                    context: context,
                    controller: _phoneController,
                    hintText: "Enter Registered Phone Number",
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 18),
                  text_field(
                    context: context,
                    controller: _otpController,
                    hintText: "Enter OTP",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 40),

                  // Send OTP Button
                  Center(
                    child: InkWell(
                      onTap: sendOtp, // Send OTP
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFF1cad48),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: Colors.black54,
                            )
                          ],
                          // border: Border.all(width: 0.5, color: Colors.black),
                        ),
                        child: Center(
                          child: Textpoppins400_16(
                            fontsize: 19,
                            text: "Send OTP",
                            fontweight: FontWeight.bold,
                            color: Colors.white,
                            textoverflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Verify OTP Button or Loading Indicator
                  _isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : Center(
                    child: InkWell(
                      onTap: verifyOtp, // Verify OTP
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          color:Color(0xFF1cad48),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        child: Center(
                          child: Textpoppins400_16(
                            fontsize: 19,
                            text: "Verify OTP",
                            fontweight: FontWeight.bold,
                            color: Colors.white,

                            textoverflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
