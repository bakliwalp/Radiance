import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:radiance_flutter/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isDarkModeActive() ? Colors.orange : Colors.transparent,
              width: 2.0
            )
          ),
          title: Text(title, style: radianceGetTitleTextStyle(isDarkModeActive(),22.0)),
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

    await put(
      url,
      headers: {"Content-type":"application/json"},
      body: json
    );
  }

  Future<Response> makeGetRequest(String ip, String authToken, String vPin) async {
    String url = "http://" + ip + "/" + authToken + "/get/" + vPin;
    return(await get(url));
  }

  void storeSharedPref({String key, double doubleVal, int intVal, String stringVal, bool boolVal}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(doubleVal != null) {
      await sp.setDouble(key, doubleVal);
    }
    else if(intVal != null) {
      await sp.setInt(key, intVal);
    }
    else if(stringVal != null) {
      await sp.setString(key, stringVal);
    }
    else if(boolVal != null) {
      await sp.setBool(key, boolVal);
    }
  }

  Future<dynamic> fetchSharedPref({String key}) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get(key);
  }
  
}