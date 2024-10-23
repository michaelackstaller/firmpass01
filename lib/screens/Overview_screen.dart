import 'package:firmpass/components/OverviewItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

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
      List<Map<String, dynamic>> firmsonntageData = await api.getFirmsonntageForFirmling();

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
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child:
      SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: Image.asset("lib/images/fire-flame.gif"),
        ),
      )
      )
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return _items[index];
        },
      ),
    );
  }
}
