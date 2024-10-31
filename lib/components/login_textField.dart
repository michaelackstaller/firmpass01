import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool nameHint;
  final bool passordHint;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.nameHint,
    required this.passordHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Text alignment to left
      children: [
        const SizedBox(height: 8.0), // Adds some space between the label and the text field
        SizedBox(
          width: 300, // Makes the text field take the full width
          child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: controller,
            obscureText: obscureText,
            autocorrect: false,
            autofillHints: nameHint ? [AutofillHints.name] : passordHint ? [AutofillHints.password] : [AutofillHints.username],
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white60),
            ),
          ),
        ),
      ],
    );
  }
}
