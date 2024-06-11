import 'dart:convert';
import 'package:firmpass/data/models/firm_element.dart';
import 'package:firmpass/data/models/firm_user.dart';
import 'package:http/http.dart' as http;

class Api {
  final String baseUrl;

  Api({required this.baseUrl});

  Future<List<FirmElement>> getFirmElements() async {
    final response = await http.get(Uri.parse('$baseUrl/firmElements'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<FirmElement> firmElements =
          body.map((dynamic item) => FirmElement.fromJson(item)).toList();
      return firmElements;
    } else {
      throw Exception('Failed to load FirmElements');
    }
  }

  Future<FirmElement> getFirmElementById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/firmElements/$id'));

    if (response.statusCode == 200) {
      return FirmElement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load FirmElement');
    }
  }

  Future<void> createFirmElement(FirmElement firmElement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/firmElements'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(firmElement.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create FirmElement');
    }
  }

  Future<void> updateFirmElement(FirmElement firmElement) async {
    final response = await http.put(
      Uri.parse('$baseUrl/firmElements/${firmElement.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(firmElement.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update FirmElement');
    }
  }

  Future<void> deleteFirmElement(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/firmElements/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete FirmElement');
    }
  }

  Future<List<FirmUser>> getFirmUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/firmUsers'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<FirmUser> firmUsers =
          body.map((dynamic item) => FirmUser.fromJson(item)).toList();
      return firmUsers;
    } else {
      throw Exception('Failed to load FirmUsers');
    }
  }

  Future<FirmUser> getFirmUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/firmUsers/$id'));

    if (response.statusCode == 200) {
      return FirmUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load FirmUser');
    }
  }

  Future<void> createFirmUser(FirmUser firmUser) async {
    final response = await http.post(
      Uri.parse('$baseUrl/firmUsers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(firmUser.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create FirmUser');
    }
  }

  Future<void> updateFirmUser(FirmUser firmUser) async {
    final response = await http.put(
      Uri.parse('$baseUrl/firmUsers/${firmUser.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(firmUser.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update FirmUser');
    }
  }

  Future<void> deleteFirmUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/firmUsers/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete FirmUser');
    }
  }
}
