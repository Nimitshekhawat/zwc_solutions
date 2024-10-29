import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Model/All_comaniesdata.dart';
import '../Model/Locationmodel.dart';

class CompaniesServices{
  //Get all comapnies
  Future<Getallcompaniesmodel?> Gerallcompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/company'; // Replace with your actual endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Client-Service': appKey,
          'Auth-Key': authKey,
          'token': token,
          'uid': uid,
        },

      );

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a User object
        Map<String, dynamic> responseData = json.decode(response.body);
        return Getallcompaniesmodel.fromJson(responseData);
      } else {
        print('Failed to fetch user data: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error occurred: $error');
      return null; // Handle errors gracefully
    }
  }


  //Get company by id
  Future<LocationModel?> Getallcompaniesbyid(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    final url = 'https://wmaapi.zerowastecitizen.in/company/get_company_locations'; // Replace with your actual endpoint

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
          'company_id': id, // Add additional parameters if required
        }),

      );

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a User object
        Map<String, dynamic> responseData = json.decode(response.body);
        return LocationModel.fromJson(responseData);
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