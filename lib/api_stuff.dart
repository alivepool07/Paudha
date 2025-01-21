

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart'; // Import dotenv package

class ApiService {
  final String baseUrl; // Server IP address

  ApiService(this.baseUrl);

  // Fetch crop details
  Future<List<dynamic>> getCropDetails() async {
    final url = Uri.parse('$baseUrl/public/crop_details');
    final response = await http.get(url, headers: {
      'x-api-key': dotenv.env['API_KEY']!, // Retrieve API key from environment variables
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        return responseBody['message']
            .where((crop) => crop['isPublic'] == true)
            .toList();
      } else {
        throw Exception('Failed to fetch crop details: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load crop details');
    }
  }

  // Fetch diseases for a specific crop
  Future<List<String>> getDiseases(int cropId) async {
    final url = Uri.parse('$baseUrl/public/diseases_for_crop/$cropId');
    final response = await http.get(url, headers: {
      'x-api-key': dotenv.env['API_KEY']!, // Retrieve API key from environment variables
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        return List<String>.from(responseBody['message']);
      } else {
        throw Exception('Failed to fetch diseases: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to load diseases');
    }
  }

  // Send image for disease detection
  Future<String> getDiseasePrediction({
  required int cropId,
  required File imageFile,
}) async {
  final url = Uri.parse('$baseUrl/public/get_disease');

  final request = http.MultipartRequest('GET', url)
    ..fields['crop_id'] = cropId.toString()
    ..files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // Ensure correct MIME type
      filename: 'image.jpeg',
    ))
    ..headers['x-api-key'] = dotenv.env['API_KEY']!;

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final responseData = jsonDecode(responseBody);
    if (responseData['success'] == true) {
      print("hello bhai  " + responseData['message']);
      return responseData['message'];
    } else {
      throw Exception('Failed to predict disease: ${responseData['message']}');
    }
  } else {
    throw Exception('Failed to get disease prediction: ${response.statusCode}');
  }
}
}