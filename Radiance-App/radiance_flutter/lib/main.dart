import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:radiance_flutter/control_page/control_page.dart';
import 'package:radiance_flutter/radiance_helper.dart';
import 'package:radiance_flutter/style.dart';

void main() => runApp(RadianceApp());

class RadianceApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    // Force portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    
    return MaterialApp(
      home: ControlPage(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: RadianceAppBarThemeDark,
        canvasColor: Color.fromARGB(0xff, 20,20,20),
        cardTheme: RadianceCardTheme,
        accentColor: RadianceTextDarkThemeColor,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: RadianceAppBarThemeLight,
        primarySwatch: Colors.orange,
        cardTheme: RadianceCardTheme,
        accentColor: RadianceTextDarkThemeColor,
      ),
    );
  }
}