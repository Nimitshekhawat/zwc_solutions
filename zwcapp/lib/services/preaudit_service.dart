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
//   Future<bool> submitAnswerWithImages({
//     required String areaId,
//     required String questionId,
//     required String textAnswer,
//     required List<File> files, // Changed from File? to List<File>
//   }) async {
//     final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
//     final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
//     final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultAppKey';
//     final String apiUrl = baseurl + 'checklist/addAnswer';
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//       String? uid = prefs.getString('uid');
//
//       // Check if token or uid is available
//       if (token == null || uid == null) {
//         return false; // Handle cases where token or uid is not available
//       }
//
//       // Create a MultipartRequest
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//       // Add fields to the request
//       request.fields['area_id'] = areaId;
//       request.fields['question_id'] = questionId;
//       request.fields['answer'] = textAnswer;
//
//       // Log the request details
//       print('API URL: $apiUrl');
//       print('Headers: ${request.headers}');
//       print('Fields: ${request.fields}');
//
//       // Iterate over each file and add to the request
//       for (var file in files) {
//         // Check if image is not null and exists
//         if (file.existsSync()) {
//           // Read and compress the image asynchronously
//           final originalBytes = await file.readAsBytes();
//           img.Image? originalImage = img.decodeImage(originalBytes);
//
//           if (originalImage == null) {
//             print('Failed to decode image.');
//             continue; // Skip this file if it can't be decoded
//           }
//
//           // Resize the image
//           img.Image resizedImage = img.copyResize(originalImage, width: 800);
//           List<int> compressedImage = img.encodeJpg(resizedImage, quality: 85);
//
//           // Create a temporary file for the compressed image
//           final compressedFile = File(file.path);
//           await compressedFile.writeAsBytes(compressedImage);
//
//           // Add the compressed file to the request
//           request.files.add(await http.MultipartFile.fromPath(
//             'file[]', // Use a plural name for multiple files
//             compressedFile.path,
//             contentType: MediaType('image', 'jpeg'), // Adjust based on the image format
//           ));
//         } else {
//           print('File does not exist: ${file.path}');
//         }
//       }
//
//       // Add headers to the request
//       request.headers.addAll({
//         'Client-Service': appKey,
//         'Auth-Key': authKey,
//         'uid': uid,
//         'token': token,
//       });
//
//       // Send the request
//       var response = await request.send();
//
//       // Log the response
//       print('Response status: ${response.statusCode}');
//       print('Response reason: ${response.reasonPhrase}');
//
//       if (response.statusCode == 200) {
//         print("Answer and images submitted successfully");
//         return true;
//       } else {
//         print("Failed to submit answer and images: ${response.reasonPhrase}");
//         return false;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return false;
//     }
//   }
//
//
//
// }

//   Future<bool> submitAnswerWithImages({
//     required String areaId,
//     required String questionId,
//     required String textAnswer,
//     required List<File> files,
//   }) async {
//     final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
//     final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
//     final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultBaseUrl';
//     final String apiUrl = '$baseurl/checklist/addAnswer';
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//       String? uid = prefs.getString('uid');
//
//       // Ensure token and uid exist
//       if (token == null || uid == null) {
//         print("Token or UID not available");
//         return false;
//       }
//
//       // Create a MultipartRequest
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//       // Add fields to the request
//       request.fields['area_id'] = areaId;
//       request.fields['question_id'] = questionId;
//       request.fields['answer'] = textAnswer;
//
//       // Add each file to the request
//       for (var file in files) {
//         if (file.existsSync()) {
//           final filePath = file.path.toLowerCase();
//           if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
//             print('Adding image: ${file.path}');
//             request.files.add(await http.MultipartFile.fromPath(
//               'file[]', // Use a plural name for multiple files
//               file.path,
//               contentType: MediaType('image', 'jpeg'), // Adjust based on format
//             ));
//           } else if (filePath.endsWith('.mp4') || filePath.endsWith('.mov')) {
//             print('Adding video: ${file.path}');
//             request.files.add(await http.MultipartFile.fromPath(
//               'file[]', // Use a plural name for multiple files
//               file.path,
//               contentType: MediaType('video', 'mp4'), // Adjust based on format
//             ));
//           } else {
//             print('Unsupported file type: ${file.path}');
//           }
//         } else {
//           print('File does not exist: ${file.path}');
//         }
//       }
//
//       // Add headers to the request
//       request.headers.addAll({
//         'Client-Service': appKey,
//         'Auth-Key': authKey,
//         'uid': uid,
//         'token': token,
//       });
//
//       // Send the request
//       var response = await request.send();
//
//       // Handle the response
//       print('Response status: ${response.statusCode}');
//       print('Response reason: ${response.reasonPhrase}');
//
//       if (response.statusCode == 200) {
//         print("Answer and media submitted successfully");
//         return true;
//       } else {
//         print("Failed to submit answer and media: ${response.reasonPhrase}");
//         return false;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return false;
//     }
//   }
// }

  Future<bool> submitAnswerWithImages({
    required String areaId,
    required String questionId,
    required String textAnswer,
    required List<File> files, // List of files (images and videos)
  }) async {
    final String authKey = dotenv.env['AUTH_KEY'] ?? 'defaultAuthKey';
    final String appKey = dotenv.env['APP_KEY'] ?? 'defaultAppKey';
    final String baseurl = dotenv.env['BASE_URL'] ?? 'defaultBaseUrl';
    final String apiUrl = '$baseurl/checklist/addAnswer';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? uid = prefs.getString('uid');

      // Ensure token and uid exist
      if (token == null || uid == null) {
        print("Token or UID not available");
        return false;
      }

      // Create a MultipartRequest for the request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add text fields to the request
      request.fields['area_id'] = areaId;
      request.fields['question_id'] = questionId;
      request.fields['answer'] = textAnswer;

      // Log fields for debugging
      print("Fields being sent: ${request.fields}");

      // Loop through the list of files and add each one to the request
      for (var singleFile in files) {
        if (await singleFile.exists()) {
          final filePath = singleFile.path.toLowerCase();
          print('Adding file: ${singleFile.path}'); // Debugging file path

          // Check file type and add accordingly
          if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
            request.files.add(await http.MultipartFile.fromPath(
              'files[]', // Ensure 'file[]' is used for the array of files
              singleFile.path,
              contentType: MediaType(
                  'image', filePath.endsWith('.png') ? 'png' : 'jpeg'),
            ));
          } else if (filePath.endsWith('.mp4') || filePath.endsWith('.mov')) {
            request.files.add(await http.MultipartFile.fromPath(
              'files[]', // Same field name for all files
              singleFile.path,
              contentType: MediaType(
                  'video', filePath.endsWith('.mp4') ? 'mp4' : 'mov'),
            ));
          } else {
            print('Unsupported file type: ${singleFile.path}');
          }
        } else {
          print('File does not exist: ${singleFile.path}');
        }
      }

      // Add headers to the request
      request.headers.addAll({
        'Client-Service': appKey,
        'Auth-Key': authKey,
        'uid': uid,
        'token': token,
      });

      // Log headers for debugging
      print("Headers being sent: ${request.headers}");

      // Send the request
      var response = await request.send();

      // Log the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        print("Answer and media submitted successfully");
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Failed to submit answer and media. Status code: ${response.statusCode}");
        print("Response body: $responseBody");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


}