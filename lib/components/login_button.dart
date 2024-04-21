import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTapFunction;
  final String myButtonText;

  const LoginButton(
      {super.key, required this.myButtonText, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login", //TODO add myButtonText
              style: TextStyle(
                color: Color.fromARGB(255, 252, 246, 226),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.keyboard_double_arrow_right_rounded,
              color: Color.fromARGB(255, 252, 246, 226),
              
            )
          ],
        ),
      ),
    );
  }
}
