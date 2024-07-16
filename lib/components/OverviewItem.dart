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
                ? Color.fromARGB(255, 195, 255, 170)
                : isUpcoming
                ? Color.fromARGB(255, 255, 255, 255)
                : Color.fromARGB(255, 255, 150, 149),
          ),
          width: 1000,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description ?? '',
                            style: const TextStyle(fontSize: 21),
                          ),
                          Text(
                            "Datum ${datum.day}.${datum.month}.${datum.year}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    done
                        ? const Icon(Icons.check, color: Colors.green, size: 40)
                        : isUpcoming
                        ? const Icon(Icons.timer, color: Colors.amber, size: 40)
                        : const Icon(Icons.error, color: Colors.red, size: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
