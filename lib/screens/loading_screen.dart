import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.yellow.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('lib/images/Firmung.png'), //TODO schöneres Foto
            ),
            const Text(
              "Deine Daten werden abgerufen,\nbitte warte einen Moment.",
              style: TextStyle(
                color: Colors.orange,
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
            const Text("Application by Acksmi and Woolchalk", style: TextStyle(color: Colors.blueGrey),)
          ],
        ),
      ),
    );
  }
  void initState(){
    super.initState();
    Timer(Duration(seconds: 5),(){
      Navigator.pushNamed(context, "/home_screen");
    });//TODO Bedingung Loading done
  }
}
