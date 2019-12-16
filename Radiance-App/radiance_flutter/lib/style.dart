import 'package:flutter/material.dart';

const LargeTextSize = 28.0;
const MediumTextSize = 20.0;
const RegularTextSize = 16.0;

const String FontName = "Lineto-Circular";

const AppBarTextStyleLight = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: LargeTextSize,
  color: Colors.black,
  wordSpacing: 20.0
);

const AppBarTextStyleDark = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: LargeTextSize,
  color: Colors.white,
);

const RadianceAppBarThemeDark =
    AppBarTheme(textTheme: TextTheme(title: AppBarTextStyleDark));

const RadianceAppBarThemeLight =
    AppBarTheme(textTheme: TextTheme(title: AppBarTextStyleLight));
