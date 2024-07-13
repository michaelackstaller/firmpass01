import 'package:firmpass/components/OverviewItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<OverviewItem> _items = [];
  bool _isLoading = true;
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    _fetchOverviewItems();
  }

  Future<void> _fetchOverviewItems() async {
    try {
      List<Map<String, dynamic>> firmstundenData = await api.getFirmstundenForFirmling();
      List<Map<String, dynamic>> firmsonntageData = await api.getFirmsonntageFirFirmling();

      firmstundenData.addAll(firmsonntageData);

      List<OverviewItem> loadedItems = [];

      for (var item in firmstundenData) {
        // Datum festlegen
        DateTime datum;
        if (item.containsKey('date')) {
          print(item['date']);
          datum = DateTime.parse(item['date']);
          print(datum);
        } else if (item.containsKey('week')) {
          // Annahme: week ist ein int, der die Kalenderwoche darstellt
          int week = item['week'];
          print(week);
          datum = DateTime(DateTime.now().year, 1, 1).add(Duration(days: (week - 1) * 7));
        } else {
          // Standardwert falls weder date noch week vorhanden sind
          datum = DateTime.now();
        }

        loadedItems.add(
          OverviewItem(
            backgroundItemColor: item['completed'] ? Colors.green : Colors.red,
            datum: datum,
            topic: item.containsKey('firmsonntagName') ? item['firmsonntagName'] : item['firmstundeName'],
            description: item['description'] ?? '',
            done: item['completed'],
          ),
        );
      }

      setState(() {
        _items = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      print('Failed to load overview items: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 200),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return _items[index];
        },
      ),
    );
  }
}

// Anpassung der Api-Klasse

class Api {
  final String baseUrl = "https://firmapi.acksmi.de";

  Api();

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<String> _getFirmlingId() async {
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
      _saveFirmlingId(response.body);
    } else {
      print('Failed to fetch Firmling ID, status code: ${response.statusCode}');
      throw Exception('Failed to fetch Firmling ID');
    }
  }

  Future<bool> isUserLoggedIn() async {
    String token = await _getToken();
    if (token.isEmpty) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/auth/validateToken'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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
    String firmlingId = await _getFirmlingId();
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

  Future<List<Map<String, dynamic>>> getFirmsonntageFirFirmling() async {
    String firmlingId = await _getFirmlingId();
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
}
