import 'package:flutter/material.dart';

import 'package:radiance_flutter/control_page/control_page.dart';
import 'package:radiance_flutter/style.dart';

void main() => runApp(RadianceApp());

class RadianceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ControlPage(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: RadianceAppBarThemeDark,
        canvasColor: Colors.black,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: RadianceAppBarThemeLight,
        primarySwatch: Colors.orange,
      ),
    );
  }
}