import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/screens/Forget_password.dart';
import 'package:zwcapp/screens/change%20password.dart';
import '../Model/profile_page.dart';


class ProfileService {

  Future<ProfileModel?> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';

    // print("token : " + token! + "authkey : "+ authKey +"appkey :"+ appKey + "uid :"+uid!);
    if (token == null || uid == null) {
      print("Error: Token or UID is null. Cannot proceed with profile fetch.");
      return null; // Handle cases where token or uid is not available
    }

    final url = baseurl+"user/profile";
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
        return ProfileModel.fromJson(json.decode(response.body)); // Deserialize JSON
      } else {
        throw Exception('Failed to load profile dataa');
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

// edit profile (e.g., name and address)
  Future<bool> editProfile(String name, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = baseurl+"user/update_profile"; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },
        body: json.encode({
          'name': name,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true; // Success
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        return false; // Failure
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }


  Future<bool> changepassword(String oldpassword, String newpass,String confirmpass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = baseurl+"user/change_password"; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },
        body: json.encode({
          'old_password': oldpassword,
          'password': newpass,
          'confirm_password':confirmpass
        }),
      );

      if (response.statusCode == 200) {
        print('Password Changed Successfully!');
        return true; // Success
      } else {
        print('Failed to change the password: ${response.statusCode}');
        return false; // Failure
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }
  Future<bool> forgetpasswordservice(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = baseurl+"user/forgotpassword"; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },
        body: json.encode({
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        print('New password succesfully send on your email id!');
        return true; // Success
      } else {
        print('Failed to send: ${response.statusCode}');
        return false; // Failure
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }


}
