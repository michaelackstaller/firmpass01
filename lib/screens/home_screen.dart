import 'package:firmpass/components/login_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final List<Widget> _pages = <Widget>[
    Center(
      child: Text("Test"),
    )
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushNamed(context, "/login_screen");
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 247, 212, 100),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "F I R M P A S S",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          
          backgroundColor: const Color.fromARGB(255, 247, 212, 100),
          //selectedItemColor: Colors.orange,
          fixedColor: Colors.deepOrange,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
              ),
              label: "Checks"
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: "Einstellungen"
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 255, 250, 200),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 0,
              ),
              QrImageView(
                data: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                size: 250,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 247, 212, 100)),
                child: const Column(
                  children: [
                    Text(
                      "Übersicht",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gottesdienste: x/8  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gruppenstunde: x/12  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aktionen: x/4  ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              LoginButton(
                  myButtonText: "scanner",
                  onTapFunction: () async {
                    await Future.delayed(const Duration(milliseconds: 80));
                    Navigator.pushNamed(context, '/qr_scanner_screen');
                  }),
              const SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
  }
}
