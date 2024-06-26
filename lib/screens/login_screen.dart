import 'package:flutter/material.dart';
import 'package:firmpass/components/login_textField.dart';
import 'package:firmpass/components/login_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 200),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
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
                  await Future.delayed(const Duration(milliseconds: 80));
                  Navigator.pushNamed(context, "/loading_screen");
                  //Loginfunction mit Datenabgleich
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
