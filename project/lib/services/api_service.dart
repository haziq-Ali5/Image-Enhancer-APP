// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project/services/storage_service.dart';

class ApiService {
  final StorageService _storageService;
  static const String _baseUrl = 'http://10.0.2.2:5000/api';final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/jobs'));  // Local backend

  ApiService(this._storageService);

  Future<String> uploadImage(File image) async {
  final token = await _storageService.getToken();
  final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/jobs')); // Correct endpoint
  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(await http.MultipartFile.fromPath('image', image.path));

  final response = await request.send();
  if (response.statusCode == 201) {
    final jsonResponse = jsonDecode(await response.stream.bytesToString());
    return jsonResponse['job_id'] as String; // Ensure key matches Flask's 'job_id'
  } else {
    final errorBody = await response.stream.bytesToString();
    throw Exception('Upload failed: ${response.statusCode} - $errorBody');
  }
}
}