// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  void Function() onPressed;
  String text;
  Color color;

  Button({super.key, required this.onPressed, required this.text, this.color = Colors.red});
  

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        padding: const EdgeInsets.all(16),
        textColor: Colors.white,
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
