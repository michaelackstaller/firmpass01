import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class OverviewItem extends StatelessWidget {
  final Color backgroundItemColor;
  final String topic;
  final String? description;
  final DateTime datum;
  bool done;

  OverviewItem({
    super.key,
    required this.backgroundItemColor,
    required this.topic,
    required this.datum,
    this.description,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isUpcoming = datum.isAfter(now);

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: done
                ? Color.fromARGB(255, 167, 255, 167)
                : isUpcoming
                ? Color.fromARGB(255, 255, 251, 204) // Gelb
                : Color.fromARGB(255, 247, 181, 181),
          ),
          width: 1000,
          height: 160,
          child: Column(
            children: [
              Text(
                topic,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: Column(
                  children: [
                    Text(
                      "$description",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Am ${datum.day}.${datum.month}.${datum.year}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              done
                  ? const Icon(Icons.check, color: Colors.green, size: 40)
                  : isUpcoming
                  ? const Icon(Icons.timer, color: Colors.amber, size: 40)
                  : const Icon(Icons.error, color: Colors.red, size: 40),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
