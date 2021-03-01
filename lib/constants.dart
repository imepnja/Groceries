import 'dart:math';

import 'package:flutter/material.dart';

class MyColors {
  static Color green = Color.fromARGB(255, 129, 192, 188);

  static Color yellow = Color(4294826037);
  static Color blue = Color.fromARGB(255, 981, 281, 55);
  // static Color purple = Color(4287985101);
  static Color purple = Color.fromARGB(255, 125, 122, 159);
  static Color pink = Color.fromARGB(255, 230, 132, 128);
  static Color salmon = Color.fromARGB(255, 246, 195, 171);
  static Color beige = Color.fromARGB(255, 251, 230, 200);

  static Color get primary => green;

  static List<Color> allColors = [
    green,
    yellow,
    blue,
    purple,
    pink,
    salmon,
    beige
  ];

  static Color get randomColor {
    var rng = Random();
    return allColors[rng.nextInt(allColors.length)];
  }
}
