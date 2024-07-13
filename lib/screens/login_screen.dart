import 'package:flutter/material.dart';
import 'package:firmpass/components/login_textField.dart';
import 'package:firmpass/components/login_button.dart';
import 'package:firmpass/api/api.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final Api api = Api();

  // sign user in method
  void signUserIn(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      await api.login(username, password);
      bool isLoggedIn = await api.isUserLoggedIn();

      if (isLoggedIn) {
        // Navigate to the home screen or dashboard after successful login
        Navigator.pushNamed(context, "/home_screen");
      } else {
        // Show an error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      // Handle exceptions and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 200),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Ensure the column takes minimal space
              children: [
                const SizedBox(height: 20),
                /*SizedBox(
                  width: 100,
                  height: 100,
                  child:
                      Image.asset("lib/images/JugendLogo.png"), //TODO Schönes Foto!
                ),*/

                // welcome back, you've been missed!
                Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 25),

                // username textfield
                LoginTextField(
                  controller: usernameController,
                  hintText: 'NUTZERNAME',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  controller: passwordController,
                  hintText: 'PASSWORT',
                  obscureText: true,
                ),

                const SizedBox(height: 35),

                // sign in button
                LoginButton(
                  myButtonText: "Login",
                  onTapFunction: () async {
                    signUserIn(context);
                    Navigator.pushNamed(context, "/loading_screen");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
