import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl; // Server IP address
  static const String apiKey = '54265bb8-3f69-4c1b-a2db-4ed4bbc274a7';

  ApiService(this.baseUrl);

  // Fetch crop details
  Future<List<dynamic>> getCropDetails() async {
    final url = Uri.parse('$baseUrl/public/crop_details');
    final response = await http.get(url, headers: {
      'x-api-key': apiKey,
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
    final request = http.MultipartRequest('GET', url);

    // Add headers
    request.headers['x-api-key'] = apiKey;

    // Add multipart fields
    request.fields['crop_id'] = cropId.toString();
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return responseBody; // Disease name
    } else {
      throw Exception('Failed to get disease prediction');
    }
  }
}
