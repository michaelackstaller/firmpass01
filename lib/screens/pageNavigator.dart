import 'package:firmpass/screens/Overview_screen.dart';
import 'package:firmpass/screens/home_screen.dart';
import 'package:firmpass/screens/qr_scanner_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 212, 100),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "F I R M P A S S",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black45),
        ),
      ),
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        iconSize: 30,
        selectedIndex: currentIndex,

        backgroundColor: const Color.fromARGB(255, 247, 212, 100),
        //selectedItemColor: Colors.orange,
        activeColor: Colors.red,
        color: Colors.black45,
        tabBackgroundColor: Colors.amber,
        tabMargin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(19),

        tabs: const <GButton>[
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.check_circle_outline,
            text: "Checks",
          ),
          GButton(
            icon: Icons.qr_code_scanner,
            text: "Scanner",
          ),
        ],

        onTabChange: (newIndex) {
          pageController.jumpToPage(newIndex);
        },
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        children: [
          HomeScreen(),
          OverviewScreen(),
          BarcodeScannerSimple()
        ],
      ),
    );
  }
}
