

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/Model/Allusers.dart';
import 'package:http/http.dart' as http;
import 'package:zwcapp/Model/Getuser.dart';

class Alluserservices{

  //Get all Users
  Future<AllUsers?> fetchallusers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole';
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
        return AllUsers.fromJson(json.decode(response.body)); // Deserialize JSON
      } else {
        throw Exception('Failed to load ');
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

  //Get user by id
  Future<Getuser?> GetUserbyid(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userDetail/get_user'; // Replace with your actual endpoint

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
          'id': id, // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a User object
        Map<String, dynamic> responseData = json.decode(response.body);
        return Getuser.fromJson(responseData);
      } else {
        print('Failed to fetch user data: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

  //Adding new User
  Future<bool> AddNewuser(String name,String email,String phonenum,String role_id,String password ,String confirm_password , String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userDetail/add_user'; // Replace with your actual endpoint

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
          "name":name,
          "email":email,
          "phone_num":phonenum,
          "role_id":role_id,
          "password":password,
          "confirm_password":confirm_password,
          "address":address // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        print('User Succefully Added');
        return true;
      } else {
        print('Failed to add User: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }

  //Update user
  Future<bool> Updateuser(String id,String name ,String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userDetail/update_user'; // Replace with your actual endpoint

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
          "id":id,
          "name":name,
          "address":address // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        print('User Updated Successfully');
        return true;
      } else {
        print('Failed to Update User: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }


  //Update user password
  Future<bool> Updatepassword(String id,String password ,String confirmpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userDetail/update_password'; // Replace with your actual endpoint

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
          "id":id,
          "password":password,
          "confirm_password":confirmpassword // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        print('Password Updated Successfully');
        return true;
      } else {
        print('Failed to Update Password: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }

  //Change User status
  Future<bool> Changeuserstatus(String id,String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userDetail/change_status'; // Replace with your actual endpoint

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
          "id":id,
          "status":status // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        print('Status Updated Successfully');
        return true;
      } else {
        print('Failed to Update Status: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }



}