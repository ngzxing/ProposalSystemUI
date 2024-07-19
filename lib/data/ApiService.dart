import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class ApiService {
  static const String _apiEndpoint = 'http://localhost:5247/api/';
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static String? id;
  static String? role;
  static String? _jwtToken;

  static Uri getEndpoint(String endpoint){

    return Uri.parse('$_apiEndpoint$endpoint');
  }

  static Future<void> saveId(String id) async {
    await storage.write(key: 'id', value: id);
  }


  static Future<String?> getId() async {
    
    return await storage.read(key: 'id');
  }

  static Future<void> saveRole(String role) async {
    await storage.write(key: 'role', value: role);
  }

  static Future<String?> getRole() async {
    
    return await storage.read(key: 'role');
  }

  
  static Future<void> saveJwtToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  
  static Future<String?> getJwtToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<void> _loadSecret() async {

    _jwtToken = await getJwtToken();
    id = await getId();
    role = await getRole();
  }


  static Future<bool> checkConnection() async{
    
    try{
      final response = await get('Connection/check', {});
      if (response.statusCode == 200) {

        return true;

      }
      else if(response.statusCode == 401){

        return false;
      } 
      else {
        throw Exception('Network Issue, Please Check Your Connection');
      }
    }catch(e){

      throw Exception('Network Issue, Please Check Your Connection');
    }
  }

  static Future<void> login(String userId, String password) async {

    final response = await http.post(
      Uri.parse('${_apiEndpoint}Account/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': userId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      _jwtToken = data['token'];
      id = data['id'];
      role = data['role'];
     
      await saveJwtToken( _jwtToken! );
      await saveId(id!);
      await saveRole(role!);

    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<void> logout() async {

    try{

      var response = await get("Account/logout", {});

      if( response.statusCode  != 200 ){
        
        throw Exception(formatErrorMessage(response));
      }
      
    }
    catch(e){

      throw Exception( "Logout Failed: ${e.toString()}" );
    }
    
  }

  static Future<http.Response> get(String endpoint, Map<String, String> query) async {
    await _loadSecret();
    final queryString = query.entries.map((e) => '${e.key}=${e.value}').join('&');
    final url = Uri.parse('$_apiEndpoint$endpoint?$queryString');

    try{

      final response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $_jwtToken',
        },
      
      );

      return response;

    }catch(e){

      throw Exception( "Request Failed Check Network Connection" );
    }

  }

  static Future<http.Response> postMultipart(String endpoint, Map<String, String> fields, Map<String, String> files) async {
    await _loadSecret();

    var uri = Uri.parse('$_apiEndpoint$endpoint');
    var request = http.MultipartRequest('POST', uri);

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    request.headers['Authorization'] = 'Bearer $_jwtToken';

    files.forEach((key, value) async{

      var file = await http.MultipartFile.fromPath(key, value);

      request.files.add(file);
    });

    
    
    try {
      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      throw Exception(truncateErrorMessage(e.toString()));
    }
  }



  static Future register(String userName, String phoneNumber, String matricId, String email, String password, String year, String session, String semester, String programId  ) async {

    var data = {

      "userName" : userName.replaceAll(" ", ""),
      "phoneNumber" : phoneNumber,
      "matricId" : matricId,
      "email" : email,
      "password" : password,
      "year" : year,
      "session" : session,
      "semester" : semester,
      "academicProgramId" : programId,
    };

    try{
      final url = Uri.parse('${_apiEndpoint}Account/register');

      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "accept": "*/*"
      },
      );

      if(response.statusCode == 200){

        return;
      }

      throw(response.body.isEmpty ? response.statusCode : response.body);

    }catch(e){

      throw(e.toString());
    }

  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    await _loadSecret();
    final url = Uri.parse('$_apiEndpoint$endpoint');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_jwtToken',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> update(String endpoint, Map<String, dynamic> data) async {
    await _loadSecret();
    final url = Uri.parse('$_apiEndpoint$endpoint');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_jwtToken',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> delete(String endpoint, Map<String, dynamic> data) async {
    await _loadSecret();

    final url = Uri.parse('$_apiEndpoint$endpoint');

    final request = http.Request('DELETE', url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_jwtToken',
    });
    request.body = jsonEncode(data);

    final response = await request.send();
    return await http.Response.fromStream(response);
  }
  
  static Future<List<Map<String, dynamic>>> getAllPrograms() async {
    try {
      final response = await ApiService.get('Account/programs',{});

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


  static String formatErrorMessage(http.Response response) {
    return response.body.isNotEmpty ? truncateErrorMessage(response.body) : response.statusCode.toString();
  }

  static String truncateErrorMessage(String message) {
    return message.length > 64 ? message.substring(0, 64) : message;
  }
}
