import 'dart:convert';

import 'package:proposal_app/data/ApiService.dart';

class Lecturer {
  static Future<List<Map<String, dynamic>>> getAllLecturers({ String? committeeLecturerId }) async {

    Map<String, String> query = {};
    if( committeeLecturerId != null ) query["committeeLecturerId"] = committeeLecturerId;

    try {
      final response = await ApiService.get('lecturer', query);

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

  static Future<void> createLecturer(String userName, String staffId, String phoneNumber, String email, String password, String programId) async {
    try {
      final response = await ApiService.post('lecturer', {
        'userName': userName.replaceAll(" ", ""),
        'staffId': staffId,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'academicProgramId' : programId
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateLecturer(String id, String userName, String phoneNumber, String email, int domain) async {

    try {
      final response = await ApiService.update('lecturer/$id', {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'email': email,
        'domain': domain,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteLecturer(String id) async {
    try {
      final response = await ApiService.delete('lecturer/$id', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<Map<String, dynamic>> getSpecificLecturer(String id) async {
    try {
      final response = await ApiService.get('lecturer/$id', {});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}