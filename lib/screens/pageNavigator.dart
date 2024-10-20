
import 'package:firmpass/screens/home_screen.dart';
import 'package:firmpass/screens/qr_scanner_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'Overview_screen.dart';
import '../api/api.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  final Api api = Api();

  @override
  Widget build(BuildContext context) {

    final List<Widget> filteredPages = [
      const HomeScreen(),
      const OverviewScreen(),
      if(api.hasRole('ROLE_MOD')) const BarcodeScannerSimple()
    ];
    final List<GButton> filteredIcons = [
      const GButton(icon: Icons.home),
      const GButton(icon: Icons.check_circle_outline),
      if(api.hasRole('ROLE_MOD')) const GButton(icon: Icons.qr_code_scanner)
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.green, Colors.orange],
            tileMode: TileMode.mirror,
          ).createShader(bounds),
          child: const Text(
            "F I R M P A S S",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This color will be overridden by the ShaderMask
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 35,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.transparent,
              color: Colors.grey,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
                pageController.jumpToPage(index);
              },
              tabs: filteredIcons,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: filteredPages,
      ),
    );
  }
}
