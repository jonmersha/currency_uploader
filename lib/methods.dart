import 'package:flutter/material.dart';

void Navigation(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
      widget,
    ),
  );
}
BoxDecoration containerDecoration() {
  return BoxDecoration(
    color: Colors.blueGrey[900], // Surface color
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
    border: Border.all(
      color: Colors.white.withOpacity(0.5), // Border color
    ),
  );
}
class ColorConverter {
  // Method to convert a color string to a Color object
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
