import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import MediaType
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;  // Import the image package
import '../Model/preaudit_model.dart';

class PreauditQuestionsService {
  // Fetch data from the API
  Future<PreauditQuestionsmodel?> fetchData(String locationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? uid = prefs.getString('uid');

    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
    final String apiUrl = baseurl + 'checklist/getCompleteChecklistWithAnswers';

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
          'area_id': locationId, // Add additional parameters if required
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

  // Submit answer with images to the API
  // Submit answer with images to the API
  Future<bool> submitAnswerWithImages({
    required String areaId,
    required String questionId,
    required String textAnswer,
    required File? file,
  }) async {
    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
    final String apiUrl = baseurl + 'checklist/addAnswer';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? uid = prefs.getString('uid');

      // Check if token or uid is available
      if (token == null || uid == null) {
        return false; // Handle cases where token or uid is not available
      }

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request
      request.fields['area_id'] = areaId;
      request.fields['question_id'] = questionId;
      request.fields['answer'] = textAnswer;

      // Log the request details
      print('API URL: $apiUrl');
      print('Headers: ${request.headers}');
      print('Fields: ${request.fields}');

      // Check if image is not null and exists
      if (file != null && await file.exists()) {
        // Read and compress the image asynchronously
        final originalBytes = await file.readAsBytes();
        img.Image? originalImage = img.decodeImage(originalBytes);

        if (originalImage == null) {
          print('Failed to decode image.');
          return false;
        }

        // Resize the image
        img.Image resizedImage = img.copyResize(originalImage, width: 800);
        List<int> compressedImage = img.encodeJpg(resizedImage, quality: 85);

        // Create a temporary file for the compressed image
        // Use 'writeAsBytes' for non-blocking file write
        final compressedFile = File(file!.path);
        await compressedFile.writeAsBytes(compressedImage);

        // Add the compressed file to the request
        request.files.add(await http.MultipartFile.fromPath(
          'file', // Use a single image key
          compressedFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on the image format
        ));
      } else {
        print('Image is null or does not exist.');
      }

      // Add headers to the request
      request.headers.addAll({
        'Client-Service': appKey,
        'Auth-Key': authKey,
        'uid': uid,
        'token': token,
      });

      // Send the request
      var response = await request.send();

      // Log the response
      print('Response status: ${response.statusCode}');
      print('Response reason: ${response.reasonPhrase}');

      if (response.statusCode == 200) {
        print("Answer and image submitted successfully");
        return true;
      } else {
        print("Failed to submit answer and image: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


}
