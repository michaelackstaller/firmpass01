import 'dart:io';
import 'package:firmpass/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool help = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        exit(
            0); //TODO: Evtl. Probleme bei Apple: https://developer.apple.com/library/archive/qa/qa1561/_index.html
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 250, 200),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        "Deine ID",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!help) {
                              help = true;
                              setState(() {});
                            } else {
                              help = false;
                              setState(() {});
                            }
                          },
                          icon: !help
                              ? const Icon(Icons.help_outline_rounded)
                              : const Icon(Icons.check_circle_outline_rounded))
                    ],
                  ),
                  Stack(alignment: Alignment(0, 0), children: [
                    QrImageView(
                      data: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                      size: 250,
                    ),
                    help
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Transform.rotate(
                                    angle: 0.8,
                                    child: Container(
                                      width: 100,
                                      height: 130,
                                      color: Color.fromARGB(255, 210, 253, 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(255, 210, 253, 20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Das ist deine persönliche ID mit der wir dich identifizieren können. Komm am Ende unserer gemeinsammen Aktionen zu einem der Begleiter und zeig im diese, damit wird deine Teilnahme bestätigt:)",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Submit_Button(
                                        myButtonText: "Verstanden",
                                        onTapFunction: () {
                                          help = false;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Text(""),
                          ),
                  ]),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 247, 212, 100)),
                child: const Column(
                  children: [
                    Text(
                      "Übersicht",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gottesdienste: x/8  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gruppenstunde: x/12  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aktionen: x/4  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
