import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Text alignment to left
      children: [
        SizedBox(height: 8.0), // Adds some space between the label and the text field
        Container(
          width: 300, // Makes the text field take the full width
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white60),
            ),
          ),
        ),
      ],
    );
  }
}
