import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String baseUrl = "https://firmapi.acksmi.de";

  Api();

  static List<Map<String, dynamic>>? _cachedRoles;

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<String> getFirmlingId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('firmling_id') ?? '';
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> _saveFirmlingId(String firmlingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firmling_id', firmlingId);
  }

  Future<Map<String, String>> _headers() async {
    String token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> login(String username, String password) async {
    print("Debug Login^1");
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      String token = response.body;
      await _saveToken(token);
      await fetchAndSaveFirmlingId();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> fetchAndSaveFirmlingId() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/firmlingIdFromToken'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      await _saveFirmlingId(response.body);
    } else {
      print('Failed to fetch Firmling ID, status code: ${response.statusCode}');
      throw Exception('Failed to fetch Firmling ID');
    }
  }

  Future<bool> isUserLoggedIn() async {
    String token = await _getToken();
    if (token.isEmpty) {
      return false;
    }
    final response = await http.get(Uri.parse('$baseUrl/auth/user'),
        headers: await _headers());
    return response.statusCode == 200;
  }

  Future<void> deleteFirmUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/auth/users/$id'),
      headers: await _headers(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete FirmUser');
    }
  }

  Future<List<Map<String, dynamic>>> getFirmstundenForFirmling() async {
    String firmlingId = await getFirmlingId();
    final response = await http.get(
      Uri.parse('$baseUrl/api/firmstunde/list/$firmlingId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Firmstunden for Firmling');
    }
  }

  Future<List<Map<String, dynamic>>> getFirmsonntageForFirmling() async {
    String firmlingId = await getFirmlingId();
    final response = await http.get(
      Uri.parse('$baseUrl/api/firmsonntag/list/$firmlingId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Firmsonntage for Firmling');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFirmlingeNames() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/firmlinge/names'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Firmlinge names');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFirmlings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/firmlinge'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Firmlinge');
    }
  }

  Future<void> markFirmstundeAsCompleted(
      String firmlingId, String firmstundeId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/firmstunde/complete/$firmlingId/$firmstundeId'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark Firmstunde as completed');
    }
  }

  Future<void> markFirmsonntagAsCompleted(
      String firmlingId, String firmsonntagId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/firmsonntag/complete/$firmlingId/$firmsonntagId'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark Firmsonntag as completed');
    }
  }

  Future<bool> loadRoles() async {
    if (_cachedRoles != null) {
      // If roles are already cached, no need to load again
      return true;
    }

    // Check if the user is logged in before loading roles
    bool isLoggedIn = await isUserLoggedIn();
    if (!isLoggedIn) {
      return false;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/roles'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      print("200");
      _cachedRoles = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return true;
    } else {
      throw Exception('Failed to load Roles');
    }
  }

  bool hasRole(String roleName) {
    print("hasRoleCheck");
    final roles = _cachedRoles;
    if (roles == null) {
      print("null :D");
      return false;
    }
    return roles.any((role) => role['roleName'] == roleName);
  }
}

