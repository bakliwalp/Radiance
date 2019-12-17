import 'package:flutter/material.dart';
import 'package:radiance_flutter/constants.dart';

const LargeTextSize = 32.0;
const BigTextSize = 26.0;
const MediumTextSize = 20.0;
const RegularTextSize = 16.0;

const RadianceTextLightThemeColor = Colors.black;
const RadianceTextDarkThemeColor = Colors.orange;

const String FontName = "Lineto-Circular";

const AppBarTextStyleLight = TextStyle(
    fontFamily: FontName,
    fontWeight: FontWeight.w300,
    fontSize: LargeTextSize,
    color: RadianceTextLightThemeColor,
    wordSpacing: 20.0);

const AppBarTextStyleDark = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: LargeTextSize,
  color: RadianceTextDarkThemeColor,
);

const BodyTextStyleDark = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: RegularTextSize,
  color: RadianceTextDarkThemeColor,
);

const BodyTextStyleLight = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: RegularTextSize,
  color: RadianceTextLightThemeColor,
);

const TitleTextStyleDark = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: BigTextSize,
  color: RadianceTextDarkThemeColor,
);

const TitleTextStyleLight = TextStyle(
  fontFamily: FontName,
  fontWeight: FontWeight.w300,
  fontSize: BigTextSize,
  color: RadianceTextLightThemeColor,
);

const RadianceCardTheme = CardTheme(
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)
        )
      )
    );

const RadianceAppBarThemeDark =
    AppBarTheme(textTheme: TextTheme(title: AppBarTextStyleDark));

const RadianceAppBarThemeLight =
    AppBarTheme(textTheme: TextTheme(title: AppBarTextStyleLight));


TextStyle radianceGetTitleTextStyle(bool _darkThem) {
  if (_darkThem) {
    return TitleTextStyleDark;
  }
  return TitleTextStyleLight;
}

TextStyle radianceGetBodyTextStyle(bool _darkThem) {
  if (_darkThem) {
    return BodyTextStyleDark;
  }
  return BodyTextStyleLight;
}

Color radianceGetBackgroundColor(bool _darkTheme) {
  if (_darkTheme) {
    return Colors.black;
  }
  return Colors.white;
}

Card radianceGetCardWidget(bool _darkTheme, Widget _child)
{
  if(!_darkTheme) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 4.0,
      margin: EdgeInsets.fromLTRB(ConstPadL, ConstPadT, ConstPadR, ConstPadB),
      child: _child,
    );
  }
  else {
    return Card(
      color: Colors.black,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 4.0,
      margin: EdgeInsets.fromLTRB(ConstPadL, ConstPadT, ConstPadR, ConstPadB),
      child: _child,
    );
  }
}