import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:radiance_flutter/constants.dart';
import 'package:radiance_flutter/radiance_helper.dart';
import 'package:radiance_flutter/style.dart';

import '../constants.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final RadianceHelper radianceHelper = RadianceHelper(context);
    return Scaffold(
      appBar: AppBar(
        title: ConstSettignsAppBarTitle,
        centerTitle: true,
        leading: IconButton(
          icon: Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
          iconSize: 28.0,
          onPressed: () => Navigator.of(context).pop(),
          color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          radianceGetCardWidget(radianceHelper.isDarkModeActive(),
            Container(
              padding: EdgeInsets.fromLTRB(ConstPadL/2, ConstPadT, ConstPadR/2, ConstPadB),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:ConstPadT*1.5, bottom: ConstPadB, right: ConstPadR/2),
                    child: radianceGetSettingTextfield(
                      ic: Icons.cloud_queue,
                      radianceHelper: radianceHelper,
                      initText: "XXX.XXX.XXX.XXX",
                      labelString: constBlynkServerIpHint,
                      functionName: settingsStoreIp,
                      context: context
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:ConstPadT, bottom: ConstPadB, right: ConstPadR/2),
                    child: radianceGetSettingTextfield(
                      ic: Icons.security,
                      radianceHelper: radianceHelper,
                      initText: "",
                      labelString: constBlynkServerAuthTokenHint,
                      functionName: settingsStoreAuthToken,
                      context: context
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  TextField radianceGetSettingTextfield({RadianceHelper radianceHelper, IconData ic, String labelString, 
  String initText, Function functionName, BuildContext context}) {
    return TextField(
      decoration: InputDecoration(
        icon: Icon(
          ic,
          size: 36.0,
          color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
        ),
        labelText: labelString,
        labelStyle: radianceGetBodyTextStyle(radianceHelper.isDarkModeActive()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
            width: 2.0
          )
        ),
      ),
      cursorColor: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
      style: radianceGetBodyTextStyle(radianceHelper.isDarkModeActive()),
      keyboardAppearance: radianceHelper.isDarkModeActive() ? Brightness.dark : Brightness.light,
      controller: TextEditingController()..text = initText,
      onSubmitted: (val) {
        functionName(val, radianceHelper);
        Flushbar(
          messageText: 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline, size: 30.0, color: Colors.black),
                onPressed: (){},
              ),
              Text(
                "Changes Saved!",
                style: TextStyle(
                  fontFamily: FontName,
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0,
                  color: RadianceTextLightThemeColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          shouldIconPulse: false,
          backgroundColor: RadianceTextDarkThemeColor,
          duration: Duration(seconds: 5),
        )..show(context);
      },
    );
  }

  void settingsStoreIp(String ip, RadianceHelper radianceHelper) {
    radianceHelper.storeSharedPref(
      key: ConstSPBlynkIPKey,
      stringVal: ip
    );
  }

  void settingsStoreAuthToken(String token, RadianceHelper radianceHelper) {
    radianceHelper.storeSharedPref(
      key: ConstSPBlynkAuthTokenKey,
      stringVal: token
    );
  }
}