import 'package:flutter/material.dart';

class Submit_Button extends StatelessWidget {
  final void Function()? onTapFunction;
  final String myButtonText;

  const Submit_Button(
      {super.key, required this.myButtonText, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: Colors.orange,
      highlightColor: Colors.orange,

      onTap: onTapFunction,

      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        width: 150,
        decoration: BoxDecoration(
          color: Colors.lime,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myButtonText, //TODO add myButtonText
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_double_arrow_right_rounded,
              color: Colors.green
              
            )
          ],
        ),
      ),
    );
  }
}
