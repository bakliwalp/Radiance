import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
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

  void showAlert(String title, String body, [bool _dismissable]) {
    showDialog(
      context: _context,
      barrierDismissible: _dismissable == null ? true : _dismissable,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: radianceGetBackgroundColor(isDarkModeActive()),
          title: Text(title, style: radianceGetTitleTextStyle(isDarkModeActive())),
          content: Text(body, style: radianceGetBodyTextStyle(isDarkModeActive())),
          actions: <Widget>[
            FlatButton(
              child: Text("Exit", style: radianceGetBodyTextStyle(isDarkModeActive())),
              onPressed: (){
                SystemNavigator.pop();
              },
            ),
            FlatButton(
              child: Text("Retry", style: radianceGetBodyTextStyle(isDarkModeActive())),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void makePutRequest(String ip, String authToken, String vPin, String value) async {
    String url = "http://" + ip + "/" + authToken + "/update/" + vPin;
    String json = "[\"" + value + "\"]";

    Response resp = await put(
      url,
      headers: {"Content-type":"application/json"},
      body: json
    );
  }

  Future<Response> makeGetRequest(String ip, String authToken, String vPin) async {
    String url = "http://" + ip + "/" + authToken + "/get/" + vPin;
    return(await get(url));
  }
  
}