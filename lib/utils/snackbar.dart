import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(20),
      elevation: 1,
      backgroundColor: Colors.white,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 18,
          color: Color.fromARGB(255, 34, 34, 34),
        ),
      ),
    ),
  );
}
