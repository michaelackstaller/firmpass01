import 'dart:io';
import 'package:firmpass/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool help = false;
  late Api _api;
  int gottesdienste = 0;
  int gruppenstunden = 0;
  int aktionen = 0;
  bool isLoading = true;
  String id = "";

  @override
  void initState() {
    super.initState();
    _api = Api();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Beispiel: Daten vom Backend laden
      // Hier kannst du die entsprechenden API-Methoden aufrufen
      // und die Anzahl der Gottesdienste, Gruppenstunden und Aktionen setzen
      final firmstunden = await _api.getFirmstundenForFirmling();
      final firmsonntage = await _api.getFirmSonntageForFirmling();
      id = await _api.getFirmlingId();

      setState(() {
        gottesdienste = firmsonntage.where((fs) => fs['completed'] == true).length;
        gruppenstunden = firmstunden.where((fs) => fs['completed'] == true).length;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0); //TODO: Evtl. Probleme bei Apple: https://developer.apple.com/library/archive/qa/qa1561/_index.html
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
                      const SizedBox(width: 40),
                      const Icon(Icons.arrow_downward_rounded),
                      const Text(
                        "Deine ID",
                        style: TextStyle(fontSize: 30),
                      ),
                      const Icon(Icons.arrow_downward_rounded),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            help = !help;
                          });
                        },
                        icon: !help
                            ? const Icon(Icons.help_outline_rounded, color: Colors.grey)
                            : const Icon(Icons.check_circle_outline_rounded, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(alignment: Alignment(0, 0), children: [
                    QrImageView(
                      data: id,
                      size: 250,
                    ),
                    help
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                const Text(
                                  "Das ist deine persönliche ID mit der wir dich identifizieren können. Komm am Ende unserer gemeinsammen Aktionen zu einem der Begleiter und zeig im diese, damit wird deine Teilnahme bestätigt:)",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Submit_Button(
                                  myButtonText: "Verstanden",
                                  onTapFunction: () {
                                    setState(() {
                                      help = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                  ]),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 247, 212, 100),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Übersicht",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gottesdienste: $gottesdienste/8",
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
                          "Gruppenstunden: $gruppenstunden/12",
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
                          "Aktionen: $aktionen/4",
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
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
