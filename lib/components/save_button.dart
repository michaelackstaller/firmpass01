

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class SaveButton extends StatelessWidget {
  final void Function()? onTapFunction;
  final String myButtonText;
  IconData buttonIcon;
  Color backgroundColor;
  Color fontColor;
  Color iconColor;

  SaveButton(
      {super.key, required this.myButtonText, required this.onTapFunction, required this.backgroundColor, required this.fontColor, required this.iconColor, required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: Colors.orange,
      highlightColor: Colors.orange,

      onTap: onTapFunction,

      child: Ink(
        padding: const EdgeInsets.all(10),
        width: 150,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myButtonText,
              style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              buttonIcon,
              color: iconColor,
              
            )
          ],
        ),
      ),
    );
  }
}
