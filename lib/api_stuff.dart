import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package

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
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load crop details');
    }
  }

  // Send image for disease detection
  Future<String> getDiseasePrediction({
    required int cropId,
    required File imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/public/get_disease');
    final request = http.MultipartRequest('POST', url)
      ..fields['crop_id'] = cropId.toString()
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path))
      ..headers['x-api-key'] = dotenv.env['API_KEY']!; // Retrieve API key from environment variables

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      throw Exception('Failed to get disease prediction');
    }
  }
}
