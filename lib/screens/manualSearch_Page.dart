import 'package:firmpass/api/api.dart';
import 'package:flutter/material.dart';

class ManualSearchPage extends StatefulWidget {
  const ManualSearchPage({super.key});

  @override
  State<ManualSearchPage> createState() => _ManualSearchPageState();
}

class _ManualSearchPageState extends State<ManualSearchPage> {
  List<DropdownMenuEntry<String>> entries = [];
  List<Map<String, dynamic>> firmlinge = [];
  bool isLoading = true;
  String? selectedEntry;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _loadFirmlinge();
  }

  Future<void> _loadEntries() async {
    try {
      List<Map<String, dynamic>> firmstunden = await Api().getFirmstundenForFirmling();
      List<Map<String, dynamic>> firmsonntage = await Api().getFirmsonntageForFirmling();

      List<DropdownMenuEntry<String>> loadedEntries = [];

      loadedEntries.add(const DropdownMenuEntry(value: "Gottesdienst", label :'Gottesdienst'));

      for (var item in firmstunden) {
        loadedEntries.add(DropdownMenuEntry(
          value: 'Firmstunde:${item['firmstundeId'].toString()}',
          label: 'Firmstunde: ${item['firmstundeName']}',
        ));
      }

      for (var item in firmsonntage) {
        loadedEntries.add(DropdownMenuEntry(
          value: 'Firmsonntag:${item['firmsonntagId'].toString()}',
          label: 'Firmsonntag: ${item['firmsonntagName']}',
        ));
      }

      loadedEntries.add(const DropdownMenuEntry(value: "SozialeAktion", label :'Soziale Aktion'));

      setState(() {
        entries = loadedEntries;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load entries: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadFirmlinge() async {
    try {
      List<Map<String, dynamic>> loadedFirmlinge = await Api().getAllFirmlingeNames();
      setState(() {
        firmlinge = loadedFirmlinge;
      });
    } catch (e) {
      print('Failed to load firmlinge: $e');
    }
  }

  List<Map<String, dynamic>> _searchFirmlinge(String query) {
    return firmlinge
        .where((firmling) =>
    firmling['firstName'].toLowerCase().contains(query.toLowerCase()) ||
        firmling['lastName'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _confirmMarkAsCompleted(BuildContext context, Map<String, dynamic> firmling, String entryId, bool isFirmstunde) async {
    final scaffoldMessengerContext = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Completion"),
          content: Text("Do you want to mark this entry as completed for ${firmling['firstName']} ${firmling['lastName']}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  print(firmling['id'].toString());
                  if (isFirmstunde) {
                    await Api().markFirmstundeAsCompleted(firmling['id'].toString(), entryId);
                  } else {
                    await Api().markFirmsonntagAsCompleted(firmling['id'].toString(), entryId);
                  }
                  scaffoldMessengerContext.showSnackBar(
                    const SnackBar(content: Text("Marked as completed!")),
                  );
                } catch (e) {
                  scaffoldMessengerContext.showSnackBar(
                    SnackBar(content: Text("Failed to mark as completed: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.green, Colors.orange],
            tileMode: TileMode.mirror,
          ).createShader(bounds),
          child: const Text(
            "F I R M P A S S",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,  // This color will be overridden by the ShaderMask
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(254, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: isLoading
            ? Center(child: SizedBox(
          width: 250,
          height: 250,
          child: Center(
            child: Image.asset("lib/images/fire-flame.gif"),
          ),
        ))
            : Column(
          children: [
            DropdownMenu<String>(
              textStyle: const TextStyle(color: Colors.white),
              expandedInsets: const EdgeInsets.symmetric(horizontal: 0),
              dropdownMenuEntries: entries,
              hintText: "Übersicht",
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintStyle: const TextStyle(color: Colors.white), // Hinweistestfarbe festlegen
              ),
              onSelected: (selectedEntry) {
                setState(() {
                  this.selectedEntry = selectedEntry;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Suche",
                labelStyle: const TextStyle(color: Colors.white),
                focusColor: Colors.amber,
                suffixIcon: const Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchFirmlinge(searchQuery).length,
                itemBuilder: (context, index) {
                  var firmling = _searchFirmlinge(searchQuery)[index];
                  return ListTile(
                    title: Text(
                      '${firmling['firstName']} ${firmling['lastName']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      if (selectedEntry != null) {
                        final parts = selectedEntry!.split(':');
                        bool isFirmstunde = parts[0] == 'Firmstunde';
                        String entryId = parts[1];
                        _confirmMarkAsCompleted(
                          context,
                          firmling,
                          entryId,
                          isFirmstunde,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bitte wähle erst einen Termin aus!")),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
