import 'dart:convert';

import 'package:proposal_app/data/ApiService.dart';

class Comment {
  static Future<Map<String, dynamic>> getSpecificComment(String id) async {
    try {
      final response = await ApiService.get('comment/$id', {});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<List<Map<String, dynamic>>> getCommentsForProposal(String proposalId) async {
    try {
      final response = await ApiService.get('comment/proposal/$proposalId', {});

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

  static Future<void> createComment(String proposalId, String evaluatorId, String text) async {
    try {
      final response = await ApiService.post('comment', {
        'proposalId': proposalId,
        'evaluatorId': evaluatorId,
        'text': text,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteComment(String commentId) async {
    try {
      final response = await ApiService.delete('comment/$commentId', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}