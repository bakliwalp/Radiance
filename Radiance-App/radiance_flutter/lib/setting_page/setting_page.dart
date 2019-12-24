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

  String _blynkIp = "";
  String _blynkToken = "";
  RadianceSharedPref radianceSharedPref = RadianceSharedPref();

  @override
  void initState() {
    radianceSharedPref.fetchSharedPref(key: ConstSPBlynkIPKey).then((val) {
      setState(() {
        _blynkIp = val;
      });
    });
    radianceSharedPref.fetchSharedPref(key: ConstSPBlynkAuthTokenKey).then((val) {
      setState(() {
        _blynkToken = val;
      });
    });
    // Dirty workound to stop continous triggering of build method after 1st install
    // sleep(Duration(milliseconds: 10));
    super.initState();
  }

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
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                      initText: _blynkIp,
                      labelString: constBlynkServerIpHint,
                      functionName: settingsStoreIp,
                      context: context,
                      key: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:ConstPadT, bottom: ConstPadB, right: ConstPadR/2),
                    child: radianceGetSettingTextfield(
                      ic: Icons.security,
                      radianceHelper: radianceHelper,
                      initText: _blynkToken,
                      labelString: constBlynkServerAuthTokenHint,
                      functionName: settingsStoreAuthToken,
                      context: context,
                      key: 2,
                    ),
                  ),
                  RaisedButton(
                    color: radianceHelper.isDarkModeActive() ? Colors.black : Colors.white,
                    highlightElevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
                        width: 2.0
                      )
                    ),
                    onPressed: () {
                      settingsStoreIp(_blynkIp, radianceSharedPref);
                      settingsStoreAuthToken(_blynkToken, radianceSharedPref);
                      Flushbar(
                        messageText: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.info_outline, size: 24.0, color: Colors.black),
                              onPressed: (){},
                            ),
                            Text(
                              "Changes Saved!",
                              style: RadianceFlushbarStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        shouldIconPulse: false,
                        backgroundColor: RadianceTextDarkThemeColor,
                        duration: Duration(seconds: 5),
                      )..show(context);
                    },
                    child: radianceGetTextLabel(
                      textAlignment: TextAlign.center,
                      textToDisplay: constSaveButtonText,
                      radHelper: radianceHelper
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
  String initText, Function functionName, BuildContext context, int key}) {
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
      autofocus: true,
      controller: TextEditingController()..text = initText,
      onChanged: (val) {
        if(key == 1) {
          _blynkIp = val;
        }
        else {
          _blynkToken = val;
        }
      },
    );
  }

  @protected
  @mustCallSuper
  void deactivate(){
    settingsStoreIp(_blynkIp, radianceSharedPref);
    settingsStoreAuthToken(_blynkToken, radianceSharedPref);
  }

  void settingsStoreIp(String ip, RadianceSharedPref radianceSharedPref) {
    print(ip);
    radianceSharedPref.storeSharedPref(
      key: ConstSPBlynkIPKey,
      stringVal: ip
    );
  }

  void settingsStoreAuthToken(String token, RadianceSharedPref radianceSharedPref) {
    print(token);
    radianceSharedPref.storeSharedPref(
      key: ConstSPBlynkAuthTokenKey,
      stringVal: token
    );
  }
}