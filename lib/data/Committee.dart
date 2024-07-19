import 'dart:convert';

import 'package:proposal_app/data/ApiService.dart';

class Committee {
  static Future<List<Map<String, dynamic>>> getCommitteesForProgram(String programId) async {
    try {
      final response = await ApiService.get('committee/$programId', {});

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

  static Future<List<Map<String, dynamic>>> getPrograms(String Id) async {
    try {
      final response = await ApiService.get('committee/programs/$Id', {});

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

  static Future<void> deleteCommittee(String id) async {
    try {
      final response = await ApiService.delete('committee/$id', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> createCommittee(String academicProgramId, String lecturerId) async {
    try {
      final response = await ApiService.post('committee', {
        'academicProgramId': academicProgramId,
        'lecturerId': lecturerId,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}