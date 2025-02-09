import 'package:flutter/material.dart';

Widget swipeBackground(Color color, IconData icon, String text) {
  return Container(
    alignment: Alignment.centerLeft, // Align left for start-to-end
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: color,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Icon(icon, color: Colors.white, size: 30),
      ],
    ),
  );
}
