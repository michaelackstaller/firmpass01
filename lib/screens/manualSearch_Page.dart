import 'package:flutter/material.dart';

class ManualSearchPage extends StatefulWidget {
  const ManualSearchPage({super.key});

  @override
  State<ManualSearchPage> createState() => _ManualSearchPageState();
}

class _ManualSearchPageState extends State<ManualSearchPage> {
  List<DropdownMenuEntry<dynamic>> entries = [
    DropdownMenuEntry(value: Colors.amber, label: "Test"),
    DropdownMenuEntry(value: "tet", label: "amber")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 212, 100),
        centerTitle: true,
        title: const Text(
          "F I R M P A S S",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black45),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 250, 200),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            DropdownMenu(
              expandedInsets: EdgeInsets.symmetric(horizontal: 0),
              dropdownMenuEntries: entries,
              hintText: "Termin",
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.lime)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Suche",
                  focusColor: Colors.amber,
                  suffixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.lime, width: 2),
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }
}
