import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/complaint.dart';
import 'api_client.dart';

class ComplaintService extends ChangeNotifier {
  List<Complaint> complaints = [];
  Complaint? selectedComplaint;
  bool isLoading = false;

  Future<void> fetchComplaints({
    required String token,
    String status = '',
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final query = status.isEmpty ? '' : '?status=${Uri.encodeComponent(status)}';
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/complaints$query'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 400) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(data['message'] ?? 'Failed to load complaints');
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      complaints = data
          .map((item) => Complaint.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchComplaintById({
    required String token,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/complaints/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 400) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['message'] ?? 'Failed to load complaint');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    selectedComplaint = Complaint.fromJson(data);
    notifyListeners();
  }

  Future<void> createComplaint({
    required String token,
    required String title,
    required String description,
    required String category,
    required double lat,
    required double lng,
    required String address,
    File? imageFile,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiClient.baseUrl}/complaints'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      'title': title,
      'description': description,
      'category': category,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'address': address,
    });

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 400) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['message'] ?? 'Complaint creation failed');
    }
  }
}
