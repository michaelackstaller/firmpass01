import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firmpass/api/api.dart'; // Ensure the import is correct

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  List<String> checkedCodes = [];
  String wert = "";
  int checkCounter = 0;
  List<Map<String, dynamic>> firmlinge = [];
  List<DropdownMenuEntry<String>> entries = [];
  List<String> names = [];
  bool isLoading = true;
  String? selectedEntry;
  bool isCheckingIn = false;

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
      loadedEntries.add(const DropdownMenuEntry(value: "Gottesdienst", label: 'Gottesdienst'));
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
      loadedEntries.add(const DropdownMenuEntry(value: "SozialeAktion", label: 'Soziale Aktion'));
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

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Bisher niemand',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    String? displayValueString = value.displayValue;
    if (displayValueString == null) {
      return Text(names.join("/n"));
    }
    wert = displayValueString;
    if (!checkedCodes.contains(wert)) {
      if (_isFirmlingeIDValid(wert)) {
        checkCounter = checkCounter + 1;
        checkedCodes.add(wert);
        names.add(_getNameById(firmlinge, int.parse(displayValueString)));
      }
    }
    print(firmlinge);
    return Text(
      names.join("\n"),
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  bool _isFirmlingeIDValid(String id) {
    return firmlinge.any((firmling) => firmling['id'].toString() == id);
  }

  String _getNameById(List<Map<String, dynamic>> list, int id) {
    for (var item in list) {
      if (item['id'] == id) {
        return '${item['firstName']} ${item['lastName']}';
      }
    }
    return 'ID not found';
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (selectedEntry != null && mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    } else {
      // Display message to select an entry
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte wähle einen Termin aus!")),
      );
    }
  }

  Future<void> _confirmMarkAsCompleted(BuildContext context, String entryId, bool isFirmstunde) async {
    final scaffoldMessengerContext = ScaffoldMessenger.of(context);
    setState(() {
      isCheckingIn = true;
    });

    try {
      for (var code in checkedCodes) {
        if (isFirmstunde) {
          await Api().markFirmstundeAsCompleted(code, entryId);
        } else {
          await Api().markFirmsonntagAsCompleted(code, entryId);
        }
      }
      scaffoldMessengerContext.showSnackBar(
        const SnackBar(content: Text("Marked as completed!")),
      );
      confirm();
    } catch (e) {
      scaffoldMessengerContext.showSnackBar(
        SnackBar(content: Text("Failed to mark as completed: $e")),
      );
    } finally {
      setState(() {
        isCheckingIn = false;
      });
    }
  }

  void resetScanner() {
    checkedCodes.clear();
    checkCounter = 0;
    _barcode = null;
    selectedEntry = null;
    names = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ID Scanner', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetScanner,
            color: Colors.red,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: _handleBarcode,
                ),
                if (selectedEntry == null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.5),
                      child: const Text(
                        "Bitte wähle einen Termin aus!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Durations.short1,
            alignment: Alignment.bottomCenter,
            color: Colors.orange.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.grey,
                  value: selectedEntry,
                  hint: const Text(
                    "Wähle einen Termin",
                    style: TextStyle(color: Colors.white),
                  ),
                  items: entries
                      .map((entry) => DropdownMenuItem(
                    value: entry.value,
                    child: Text(
                      entry.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEntry = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Erkannt: $checkCounter",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Center(child: _buildBarcode(_barcode)),
                const SizedBox(height: 20),
                if (isCheckingIn)
                  const Center(child: CircularProgressIndicator()),
                if (!isCheckingIn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'resetButton',
                        backgroundColor: Colors.red,
                        onPressed: resetScanner,
                        child: const Icon(Icons.refresh),
                      ),
                      FloatingActionButton(
                        heroTag: 'searchButton',
                        backgroundColor: Colors.amber,
                        onPressed: () => Navigator.pushNamed(context, '/manualSearch_screen'),
                        child: const Icon(Icons.search_outlined),
                      ),
                      FloatingActionButton.extended(
                        heroTag: 'checkButton',
                        extendedPadding: EdgeInsets.all(checkCounter > 0 ? 15 : 5),
                        label: Text(
                          checkCounter > 0 ? "check-in" : "erst scannen",
                          style: TextStyle(
                            fontSize: checkCounter > 0 ? 20 : 15,
                            color: checkCounter > 0
                                ? Colors.black
                                : const Color.fromARGB(255, 83, 83, 83),
                          ),
                        ),
                        icon: Icon(
                          checkCounter > 0 ? Icons.check : Icons.qr_code_2,
                          color: checkCounter > 0
                              ? Colors.green
                              : const Color.fromARGB(255, 83, 83, 83),
                        ),
                        backgroundColor: checkCounter > 0 ? Colors.amber : Colors.grey,
                        onPressed: checkCounter > 0
                            ? () {
                          if (selectedEntry != null) {
                            final parts = selectedEntry!.split(':');
                            bool isFirmstunde = parts[0] == 'Firmstunde';
                            String entryId = parts[1];
                            _confirmMarkAsCompleted(context, entryId, isFirmstunde);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Bitte wähle erst einen Termin aus!")),
                            );
                          }
                        }
                            : null,
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void confirm() {
    save();
    resetScanner();
  }

  void save() {}
}
