import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onTapFunction;
  final String myButtonText;

  const LoginButton(
      {super.key, required this.myButtonText, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      splashColor: Colors.orange,
      highlightColor: Colors.orange,

      onTap: onTapFunction,

      child: Ink(
        padding: const EdgeInsets.all(10),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myButtonText, //TODO add myButtonText
              style: const TextStyle(
                color: Color.fromARGB(255, 252, 246, 226),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_double_arrow_right_rounded,
              color: Color.fromARGB(255, 252, 246, 226),
              
            )
          ],
        ),
      ),
    );
  }
}
