import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../api/Api.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Api _api;

  @override
  void initState() {
    super.initState();
    _api = Api();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      bool isLoggedIn = await _api.isUserLoggedIn();
      if (isLoggedIn) {
        bool rolesLoaded = await _api.loadRoles();
        print(rolesLoaded);
        if (rolesLoaded) {
          _checkLoginStatus();
        }
      } else {
        // Navigate to login screen if the user is not logged in
        Navigator.pushNamed(context, "/login_screen");
      }
    } catch (e) {
      // Handle exception if roles loading fails
      print('Failed to load roles: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    try {
      bool isLoggedIn = await _api.isUserLoggedIn();
      if (isLoggedIn) {
        Navigator.pushNamed(context, "/pageNavigator"); // Aktualisiere den Pfad
      } else {
        // Handle the case when the user is not logged in
        Navigator.pushNamed(context, "/login_screen"); // Füge eine alternative Navigation hinzu
      }
    } catch (e) {
      print("failed to load ID");
      // Handle the error, maybe show an error message or retry
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Changed PopScope to WillPopScope and set canPop to false
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                  'lib/images/JugendLogo.png'), //TODO schöneres Foto
            ),
            const Text(
              "Deine Daten werden abgerufen,\nbitte warte einen Moment.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: LinearProgressIndicator(
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 200),
            const Text(
              "Application by Acksmi and Woolchalk",
              style: TextStyle(color: Colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }
}
