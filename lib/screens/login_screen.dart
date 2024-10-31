import 'package:flutter/material.dart';
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
        Navigator.pushNamed(context, "/pageNavigator");
      } else {
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
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Visibility(
                      visible: !isKeyboardVisible,
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Image.asset("lib/images/JugendLogo.png"),
                      ),
                    ),
                    const Text(
                      'Willkommen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // subtitle
                    const Text(
                      'Logge dich ein um fortzufahren',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // username textfield

                    AutofillGroup(
                      child: Column(children: [
                        TextField(
                          controller: usernameController,
                          obscureText: false,
                          autocorrect: false,
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'NUTZERNAME',
                            hintStyle: const TextStyle(color: Colors.white60),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // password textfield
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          autocorrect: false,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'PASSWORT',
                            hintStyle: const TextStyle(color: Colors.white60),
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 30),

                    // sign in button
                    LoginButton(
                      myButtonText: "Log In",
                      onTapFunction: () async {
                        signUserIn(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
