import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zwcapp/Model/Roles.dart';
import 'package:http/http.dart' as http;

class UserRoleservies {


  //get all user Roles
  Future<Roles?> fetchallroles() async {
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
        return Roles.fromJson(json.decode(response.body)); // Deserialize JSON
      } else {
        throw Exception('Failed to Fetch all roles ');
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }

  // Add new role (POST request)
  Future<bool> addNewRole(String roleName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole/add_role'; // Replace with your actual endpoint

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
          'name': roleName, // Add additional parameters if required
        }),
      );

      if (response.statusCode == 200) {
        print('Role added successfully');
        return true;
      } else {
        print('Failed to add role: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }

  //Update Role
  Future<bool> updateRole(String name, String roleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole/update_role'; // Replace with your actual endpoint

    try {
      final response = await http.post( // Use PUT if your API specifies it, otherwise you can use POST
        Uri.parse(url),
        headers: {
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },
        body: jsonEncode({
          'name': name,      // Role name
          'role_id': roleId, // Role ID
        }),
      );

      if (response.statusCode == 200) {
        print('Role updated successfully');
        return true;
      } else {
        print('Failed to update role: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }

  // Delete role
  Future<bool> deleteRole(String roleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return false; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/userRole/delete_role'; // Replace with your actual endpoint

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
          'Content-Type': 'application/json', // Ensure content type is set to JSON
        },
        body: jsonEncode({
          'role_id': roleId, // The role ID to delete
        }),
      );

      if (response.statusCode == 200) {
        print('Role deleted successfully');
        return true;
      } else {
        print('Failed to delete role: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error occurred: $error');
      return false; // Handle errors gracefully
    }
  }
}