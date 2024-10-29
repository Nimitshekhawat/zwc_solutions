// preaudit_questions_service.dart

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/preaudit_model.dart';
// import 'preaudit_questions_model.dart';

class PreauditQuestionsService {
  final String apiUrl = 'https://wmaapi.zerowastecitizen.in/questions/getCompleteQuestionnaireWithAnswers';

  // Fetch data from the API
  Future<PreauditQuestionsmodel?> fetchData(String locationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';

    // Check if token or uid is available
    if (token == null || uid == null) {
      return null; // Handle cases where token or uid is not available
    }

    try {

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Client-Service': appKey,
            'Auth-Key': authKey,
            'token': token,
            'uid': uid,
          },
          body: jsonEncode({
            'location_id': locationId, // Add additional parameters if required
          }),

        );

      if (response.statusCode == 200) {
        return preauditQuestionsmodelFromJson(response.body);
      } else {
        print('Failed to load data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Submit answer to the API
  Future<bool> submitAnswer(String questionId, String answer) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapiurl.com/submitAnswer'),
        body: {
          "question_id": questionId,
          "answer": answer,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
