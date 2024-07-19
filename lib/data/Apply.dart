import 'dart:convert';

import 'package:proposal_app/data/ApiService.dart';

class Apply {
  static Future<void> createApply(String staffId) async {

    String? matricId = ApiService.id;
    if(matricId == null) {
      throw Exception("Account Error");
    }

    try {
      final response = await ApiService.post('Apply', {
        'matricId': matricId,
        'staffId': staffId,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  

  static Future<List<Map<String, dynamic>>> getApplications({String matricId = '', int? applyState, String? committeeLecturerId}) async {

    

    try {
      Map<String, String> queryParams = {'matricId': matricId};
      if (applyState != null) {
        queryParams['applyState'] = applyState.toString();
      }
      if( committeeLecturerId != null ) queryParams["committeeLecturerId"] = committeeLecturerId;

      final response = await ApiService.get('Apply', queryParams);

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

  static Future<Map<String, dynamic>> getSpecificApplication(String id) async {
    try {
      final response = await ApiService.get('Apply/$id', {});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateApplyStatus(String id, int status) async {
    try {
      final response = await ApiService.update('Apply/$id', {
        'status': status,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> confirmApplication(String id) async {
    try {
      final response = await ApiService.update('Apply/confirm/$id', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}