import 'package:firmpass/screens/manualSearch_Page.dart';
import 'package:firmpass/screens/pageNavigator.dart';
import 'package:firmpass/screens/home_screen.dart';
import 'package:firmpass/screens/loading_screen.dart';
import 'package:firmpass/screens/login_screen.dart';
import 'package:firmpass/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return MaterialApp(
      
      title: 'Firmpass',
      home: const LoadingScreen(),
      theme: ThemeData(colorScheme: const ColorScheme(brightness: Brightness.dark, primary: Colors.black, onPrimary: Colors.white, secondary: Color.fromARGB(255, 40, 75, 0), onSecondary: Colors.white, error: Colors.red, onError: Colors.black, surface: Colors.black , onSurface: Colors.white)),

      routes: {
        '/login_screen': (context) => LoginPage(),
        '/home_screen': (context) => const HomeScreen(),
        '/loading_screen': (context) => const LoadingScreen(),
        '/qr_scanner_screen':(context) => const BarcodeScannerSimple(),
        '/pageNavigator':(context) => const PageNavigator(),
        '/manualSearch_screen':(context) => const ManualSearchPage(),
      },
    );
  }
}
