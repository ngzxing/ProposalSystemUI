import 'dart:convert';
import 'dart:io';

import 'package:proposal_app/data/ApiService.dart';

class Proposal {
  static Future<void> createProposal(String studentId, File proposalFile, File formFile ,String title, int domain) async {

    try {
      final response = await ApiService.postMultipart(
        'proposal',
        {
          'StudentId': studentId,
          'Title': title,
          'Domain': domain.toString(),
        },

        {
          "ProposalFile" : proposalFile.path,
          "FormFile" : formFile.path
        }
        
      );

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {

      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> deleteProposal(String proposalId) async {
    try {
      final response = await ApiService.delete('proposal/$proposalId', {});

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Uri getProposalFileLink(String proposalId){
    
    return ApiService.getEndpoint('proposal/file/$proposalId');

  }

  static Future<File> getProposalPdf(String proposalId, String filepath) async {
    try {
      final response = await ApiService.get('proposal/file/$proposalId', {});

    
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final file = File(filepath);
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<File> getSignedFormPdf(String proposalId, String filepath) async {
    try {
      final response = await ApiService.get('proposal/form/$proposalId', {});

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final file = File(filepath);
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<File> getFormPdf(String filepath) async {
    try {
      final response = await ApiService.get('proposal/form', {});

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final file = File(filepath);
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<Map<String, dynamic>> getProposalInfo(String id, {String? committeeLecturerId}) async {

    Map<String, String> query = {};
    if( committeeLecturerId != null ) query["committeeLecturerId"] = committeeLecturerId;

    try {
      final response = await ApiService.get('proposal/info/$id', query);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<List<Map<String, dynamic>>> getProposalsList({int? proposalStatus, int? semester, int? session, String? supervisorId, String? evaluatorId, String? studentId, String? committeeLecturerId}) async {
    try {
      Map<String, String> queryParams = {};
      if (proposalStatus != null) queryParams['proposalStatus'] = proposalStatus.toString();
      if (semester != null) queryParams['semester'] = semester.toString();
      if (session != null) queryParams['session'] = session.toString();
      if (supervisorId != null) queryParams['supervisorId'] = supervisorId;
      if (evaluatorId != null) queryParams['evaluatorId'] = evaluatorId;
      if (studentId != null) queryParams['studentId'] = studentId;
      if (committeeLecturerId != null) queryParams['committeeLecturerId'] = committeeLecturerId;

      final response = await ApiService.get('proposal/info', queryParams);

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

  static Future<void> updateProposalStatus(String id, int proposalStatus, String evaluatorId) async {
    try {
      final response = await ApiService.update('proposal/status/$id', {
        'proposalStatus': proposalStatus.toString(),
        'evaluatorId': evaluatorId,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateProposal(String id, int proposalStatus, String evaluatorId, double? mark) async {

    try {
      
      await updateProposalStatus(id, proposalStatus, evaluatorId);
      await updateProposalMark(id, mark, evaluatorId);

    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }

  static Future<void> updateProposalMark(String id, double? mark, String evaluatorId) async {
    try {
      final response = await ApiService.update('proposal/mark/$id', {
        'mark': mark?.toString(),
        'evaluatorId': evaluatorId,
      });

      if (response.statusCode != 200) {
        throw Exception(ApiService.formatErrorMessage(response));
      }
    } catch (e) {
      throw Exception(ApiService.truncateErrorMessage(e.toString()));
    }
  }
}