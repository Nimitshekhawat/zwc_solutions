

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/Model/GetallModule.dart';
import 'package:http/http.dart'as http;
import 'package:zwcapp/Model/Getallmoduleofrole.dart';

class Modules{

  //Get all module
  Future<Getallmodule?> fetchallusers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole/get_all_modules';
    // Replace with your API endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          // 'Content-Type': 'application/json',
          'Client-Service':appKey,
          'Auth-Key':  authKey, // Replace with your auth key
          'token': token,
          'uid': uid,
        },
      );

      if (response.statusCode == 200) {
        return Getallmodule.fromJson(json.decode(response.body)); // Deserialize JSON
      } else {
        throw Exception('Failed to load ');
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

  //Get Module of role
  Future<Getmoduleofrole?> Getmodulerole(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole/get_modules'; // Replace with your actual endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },
        body: jsonEncode({
          'role_id': id, // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a User object
        Map<String, dynamic> responseData = json.decode(response.body);
        return Getmoduleofrole.fromJson(responseData);
      } else {
        print('Failed to fetch user data: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

}