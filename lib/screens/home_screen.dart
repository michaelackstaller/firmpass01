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
  int firmsonntageaamount = 0;
  bool aktionen = false;
  bool isLoading = true;
  late String id;

  @override
  void initState() {
    super.initState();
    _api = Api();
    _loadId();
    _loadData();
  }

  Future<void> _loadId() async {
    try {
      id = await _api.getFirmlingId();
      isLoading = false;
      setState(() {
      });
    } catch (e) {
      print("failed to load ID");
    }
}

  Future<void> _loadData() async {
    try {
      final firmstunden = await _api.getFirmstundenForFirmling();
      var firmsonntage = await _api.getFirmsonntageForFirmling();
      setState(() {
        gruppenstunden = firmstunden.where((fs) => fs['completed'] == true).length;
        firmsonntageaamount= firmsonntage.where((fs) => fs['completed'] == true).length;
      });
    } catch (e) {
      print('Failed to load data: $e');
      setState(() {
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
        backgroundColor:  Colors.black,
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
                        style: TextStyle(fontSize: 30, color: Colors.white),
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
                  Stack(alignment: const Alignment(0, 0), children: [
                    isLoading
                        ? SizedBox(
                      width: 250,
                      height: 250,
                      child: Center(
                        child: Image.asset("lib/images/fire-flame.gif"),
                      ),
                    )
                        : QrImageView(
                      backgroundColor: Colors.white,
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
                                color: const Color.fromARGB(255, 210, 253, 20),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 210, 253, 20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                padding: const EdgeInsets.all(10),
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Übersicht",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gruppenstunden: ",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text("$gruppenstunden/12 🔥",
                          style: const TextStyle(fontSize: 25, color: Colors.white),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gottesdienste: ",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text("$gottesdienste/8 🔥",
                          style: const TextStyle(fontSize: 25, color: Colors.white),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Firmsonntage:",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(" $firmsonntageaamount/4 🔥",
                          style: const TextStyle(fontSize: 25, color: Colors.white),)
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ausflug: ",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text("0/1 🔥",
                          style: TextStyle(fontSize: 25, color: Colors.white),)
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Soziale Aktion: ",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text("0/1 🔥",
                          style: TextStyle(fontSize: 25, color: Colors.white),)
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
