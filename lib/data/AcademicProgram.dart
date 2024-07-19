import 'dart:convert';
import 'package:proposal_app/data/ApiService.dart';

class AcademicProgram {
  static Future<void> createProgram(String name, String description) async {
    try {
      final response = await ApiService.post('program', {
        'name': name,
        'description': description,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<List<Map<String, dynamic>>> getAllPrograms() async {
    try {
      final response = await ApiService.get('program',{});

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<Map<String, dynamic>> getSpecificProgram(String id) async {
    try {
      final response = await ApiService.get('program/$id', {});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<List<Map<String, dynamic>>> getNotInvolvedCommittee(String id) async {
    try {
      final response = await ApiService.get('program/NotCommittee/$id', {});

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  
}