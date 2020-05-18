import 'package:flutter/material.dart';
import 'package:flutter_project_package/mode_themes/mode_color.dart';

class AmbersThemes {
  static TextStyle buttonText(BuildContext context) => TextStyle(
      fontSize: 22,
      color: ModeColor(
        light: Colors.white,
        dark: Colors.black,
      ).color(context));
  static TextStyle bodyText(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
      color: ModeColor(
        light: Colors.black,
        dark: Colors.purple,
      ).color(context));
  static Color arrowColor(BuildContext context) => ModeColor(
        light: Colors.white,
        dark: Colors.purple,
      ).color(context);
}
