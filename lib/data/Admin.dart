import 'dart:convert';
import 'package:proposal_app/data/ApiService.dart';

class Admin{

  static Future<Map<String, dynamic>> getSpecificAdmin(String id) async {
    try {
      final response = await ApiService.get('admin/$id', {});

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