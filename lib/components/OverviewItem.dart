import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: done
                ? Colors.orange.shade300
                : isUpcoming
                ? Colors.grey.shade100
                : const Color.fromARGB(255, 255, 150, 149),
          ),
          width: 1000,
          height: 80,
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description ?? '',
                            style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "${datum.day}.${datum.month}.${datum.year}",
                            style: const TextStyle(fontSize: 12),
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
                        ?const Text(
                        "🔥",
                        style: TextStyle(fontSize: 40),
                      )
                        : isUpcoming
                        ? const ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Color.fromRGBO(100, 100, 100, 50),
                        BlendMode.modulate,
                      ),
                      child: Text(
                        "🔥",
                        style: TextStyle(fontSize: 40),
                      ),
                    )
                        :const ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Color.fromRGBO(255, 50, 50, 50),
                        BlendMode.modulate,
                      ),
                      child: Text(
                        "🔥",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }
}
