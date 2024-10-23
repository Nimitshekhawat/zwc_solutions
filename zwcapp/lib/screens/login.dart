import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // For storing user data
import 'package:zwcapp/screens/otp_screen.dart';
import 'package:zwcapp/screens/splash_screen.dart';
import 'customwidgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define your keys (keep them secure in production)
  static final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
  static final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';

  Future<void> login() async {
    final String userId = _userIdController.text.trim();
    final String password = _passwordController.text.trim();

    // Input validation
    if (userId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both User ID and Password.')),
      );
      return;
    }

    // API endpoint for login
    final url = 'https://wmaapi.zerowastecitizen.in/user/login';

    try {
      // Create request body
      final requestBody = json.encode({'username': "rohit@30days.in", 'password': "Rohit_1@3\$"});
      print('Request Body: $requestBody'); // Log the request body

      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Handle successful login
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token']; // Ensure your API returns this
        final String userId = responseData['user_id']; // Adjust based on your API's response

        // Store token and user ID securely
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var sharedPref= await SharedPreferences.getInstance();
        sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
        await prefs.setString('token', token);
        await prefs.setString('user_id', userId);

        // Navigate to OTP page or the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => otp_page()),
        );
      } else {
        // Handle error
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage = responseData['message'] ?? 'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
        ));
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again.'),
      ));
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
              'assets/images/background_image.png',
              fit: BoxFit.fitWidth,
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
                  SizedBox(height: 20),
                  Container(
                    height: 220,
                    child: Image.asset("assets/images/loginpage_image.png"),
                  ),
                  SizedBox(height: 20),
                  text_field(
                    context: context,
                    controller: _userIdController,
                    hintText: "Enter User ID",
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 18),
                  text_field(
                    context: context,
                    controller: _passwordController,
                    hintText: "Password",
                    keyboardType: TextInputType.text,
                    // obscureText: true, // Hide password input for security
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: InkWell(
                      onTap: () {
                        login();

                      },  // Call login on tap
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFF37B943),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1.6,
                              color: Colors.black54,
                            )
                          ],
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                        ),
                        child: Center(
                          child: Textpoppins400_16(
                            fontsize: 19,
                            text: "Get Started",
                            fontweight: FontWeight.bold,
                            color: Colors.white,
                            textoverflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 47),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => otp_page()));
                      },
                      child: TextpoppinsMedium_16(
                        text: "Instead Login with Otp",
                        color: Colors.green[900],
                        fontweight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}