import 'dart:convert';

import 'package:proposal_app/data/ApiService.dart';

class Student {
  static Future<Map<String, dynamic>> getSpecificStudent(String id) async {
    try {
      final response = await ApiService.get('student/$id', {});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateStudent(String id, String userName, String phoneNumber, String email) async {
    try {
      final response = await ApiService.update('student/$id', {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'email': email,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteStudent(String id) async {
    try {
      final response = await ApiService.delete('student/$id', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<List<Map<String, dynamic>>> getAllStudents({String? supervisorId, int? semester, int? session, String? committeeLecturerId}) async {
    
    
  
    try {
      Map<String, String> queryParams = {};
      if (supervisorId != null) queryParams['supervisorId'] = supervisorId;
      if (semester != null) queryParams['semester'] = semester.toString();
      if (session != null) queryParams['session'] = session.toString();
      if( committeeLecturerId != null ) queryParams["committeeLecturerId"] = committeeLecturerId;

      final response = await ApiService.get('student', queryParams);

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

  static Future<void> createStudent(String userName, String phoneNumber, String matricId, String email, String password, int year, int session, int semester) async {
    try {
      final response = await ApiService.post('student', {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'matricId': matricId,
        'email': email,
        'password': password,
        'year': year.toString(),
        'session': session.toString(),
        'semester': semester.toString(),
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateStudentEvaluator(String id, String evaluatorId, int who, int domain) async {
    try {
      final response = await ApiService.update('student/$id/evaluator', {
        'evaluatorId': evaluatorId,
        'who': who.toString(),
        'domain': domain.toString(),
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteStudentEvaluator(String matricId, String staffId) async {
    try {
      final response = await ApiService.delete('student/$matricId/evaluator/$staffId', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteStudentSupervisor(String matricId, String staffId) async {
    try {
      final response = await ApiService.delete('student/$matricId/supervisor/$staffId', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}