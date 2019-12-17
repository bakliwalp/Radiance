import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiance_flutter/style.dart';

class RadianceHelper{

  BuildContext _context;
  bool connectivityState = false;
  var connectivityResult;

  RadianceHelper(this._context) ; // positional constructor

  bool _getDarkThemeState() {
    var brightness = MediaQuery.of(_context).platformBrightness;
    if(brightness == Brightness.dark) {
      return true;
    }
    else {
      return false;
    }
  }

  bool _getDarkModeState() {
    final ThemeData theme = Theme.of(_context);
    if(theme.brightness == ThemeData.dark().brightness) {
      return true;
    }
    else {
      return false;
    }
  }

  bool isDarkModeActive() {
    if(_getDarkModeState() || _getDarkThemeState()) {
      return true;
    }
    return false;
  }

  Future<List> isNetworkConnected() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
        return [true, connectivityResult];
    } else if (connectivityResult == ConnectivityResult.wifi) {
        return [true, connectivityResult];
    } else {
        return [false, connectivityResult];
    }
  }

  void showAlert(String title, String body) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: radianceGetBackgroundColor(isDarkModeActive()),
          title: Text(title, style: radianceGetTitleTextStyle(isDarkModeActive())),
          content: Text(body, style: radianceGetBodyTextStyle(isDarkModeActive())),
          actions: <Widget>[
            FlatButton(
              child: Text("Exit"),
              onPressed: (){
                SystemNavigator.pop();
              },
            ),
            FlatButton(
              child: Text("Retry"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  
}