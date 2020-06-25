import 'package:flutter/material.dart';

class Nav {
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }

  static void push(context, Widget page) {
    Navigator.push(context, createRoute(page));
  }
  static void replace(context, Widget page) {
    Navigator.pushReplacement(context, createRoute(page));
  }
  static void pop(context) {
    Navigator.pop(context);
  }
}