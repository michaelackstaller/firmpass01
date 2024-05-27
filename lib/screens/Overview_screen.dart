import 'package:firmpass/components/OverviewItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OverviewScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {



    
    List<OverviewItem> _Items = [
       OverviewItem(
        backgroundItemColor: Colors.white,
        datum: DateTime.utc(2024, 09, 08),
        topic: "1. Firmstunde",
        description: "Was wir über Gott wissen können",
        done: false,
      ),
       OverviewItem(
        backgroundItemColor: Color.fromARGB(255, 247, 212, 100),
        datum: DateTime.utc(2023, 04,05),
        topic: "hallo",
        description: "12345678",
        done: false,
      ),
    ];









    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 200),
      body: ListView.builder(
        itemCount: _Items.length,
        itemBuilder: (BuildContext context, int index) {
          return _Items[index];
        },
      ),
    );
  }
}