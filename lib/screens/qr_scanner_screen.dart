//TODO Scanner ist noch nicht funktional!!!
//TODO Scanner Einrichtung ios

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Bisher niemand',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    wert = value.displayValue ?? "No";
    if (!checkedCodes.contains(wert)) {
      checkCounter++;
      checkedCodes.add(wert);
    }
    return Text(
      checkedCodes.join("\n").replaceAll("https://", ""),
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Durations.short1,
              alignment: Alignment.bottomCenter,
              height: checkCounter * 20 + 70,
              color: Colors.orange.withOpacity(0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Erkannt: $checkCounter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () => Navigator.pushNamed(
                  context, '/login_screen'), //TODO manual search_page
              child: const Icon(Icons.search_outlined),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton.extended(
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
                  icon: Icon(checkCounter > 0 ? Icons.check : Icons.qr_code_2, color: checkCounter > 0
                      ? Colors.green
                      : const Color.fromARGB(255, 83, 83, 83),),
                  backgroundColor: checkCounter > 0 ? Colors.amber : Colors.grey,
                  onPressed: checkCounter > 0 ? () => {} : null,
                ),
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
