import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:radiance_flutter/constants.dart';
import 'package:radiance_flutter/radiance_helper.dart';
import 'package:radiance_flutter/style.dart';

import '../constants.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {

  double _sliderValue = 30;
  bool _sliderSwitch = false;
  Timer _timer;

  bool _manuallyChanged = false;

  @override
  Widget build(BuildContext context) {

    final RadianceHelper radianceHelper = RadianceHelper(context);

    // Check network
    Future<List> networkState = radianceHelper.isNetworkConnected();
    networkState.then((value) {
      if(value[0] == false) {
        radianceHelper.showAlert(ConstNoNetworkAlertTitle, ConstNoNetworkAlertBody);
      }
      else {
        // execute only if slider is not moved manually
        if(!_manuallyChanged) {
          radianceHelper.makeGetRequest(ConstBlynkServerIP, ConstBlynkAuthToken, ConstBlynkSliderVpin)
          .then((resp) {
            print(_sliderValue);
            setState(() {
              _sliderValue = double.parse(jsonDecode(resp.body)[0]);
              if (_sliderValue > 0) {
                _sliderSwitch = true;
              }
            });
          });
        }
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        title: ConstAppBarTitle,
        centerTitle: true,
        leading: IconButton(
          icon: Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
          iconSize: 28.0,
          onPressed: () => Navigator.of(context).pop(),
          color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Platform.isIOS ? Icon(Icons.menu) : Icon(Icons.menu),
            iconSize: 28.0,
            onPressed: () => {
              //TODO - Implement config page here
            },
            color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ImageCard
          radianceGetCardWidget(radianceHelper.isDarkModeActive(),
             Image.network(
              ConstImageURL,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
            )
          ),
          // 2nd widget
          radianceGetCardWidget(radianceHelper.isDarkModeActive(), 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Add Row for Master on/off label & switch for the lamp 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Add Master on/off label for the lamp
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 16.0, left: ConstPadL),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(right: ConstPadR/2),
                                icon: Icon(Icons.power_settings_new),
                                color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
                                onPressed: () => {},
                              ),
                              radianceGetTextLabel(
                                textToDisplay: constSliderSwitch,
                                textAlignment: TextAlign.start,
                                radHelper: radianceHelper
                              ),
                            ],  
                          ),
                        ),
                      ],
                    ),
                    // Add Master on/off switch for the lamp
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 16.0, right: ConstPadR),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Switch.adaptive(
                                value: _sliderSwitch,
                                activeColor: RadianceTextDarkThemeColor,
                                inactiveThumbColor: radianceHelper.isDarkModeActive() == true ? Colors.orange[100] : Colors.grey[50],
                                onChanged: (value) {
                                  _manuallyChanged = true;
                                  setState(() => _sliderSwitch = value);
                                  if(value) {
                                    // sent last saved slider value to blynk server
                                    radianceHelper.fetchSharedPref(key: ConstSPSliderKey).then((value) {
                                      radianceHelper.makePutRequest(
                                        ConstBlynkServerIP, ConstBlynkAuthToken,
                                        ConstBlynkSliderVpin, value.toString());
                                      }
                                    );
                                  }
                                  else {
                                    // sent 0 to blynk server to turn off the lamp
                                    radianceHelper.makePutRequest(
                                      ConstBlynkServerIP, ConstBlynkAuthToken,
                                      ConstBlynkSliderVpin, "0");
                                  }                                    
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Add lamp brightness text label
                Container(
                  padding: EdgeInsets.only(left: ConstPadL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.only(right: ConstPadR/2),
                        icon: Icon(Icons.lightbulb_outline),
                        color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
                        onPressed: () => {},
                      ),
                      radianceGetTextLabel(
                        textToDisplay: constSliderLabel,
                        textAlignment: TextAlign.center,
                        radHelper: radianceHelper
                      )
                    ],
                  ),
                ),
                // Add slider Row
                Container(
                  padding: EdgeInsets.only(left: ConstPadL, top: ConstPadT),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Slider.adaptive(
                          value: _sliderValue,
                          min: 0.0,
                          max: 100.0,
                          divisions: 100,
                          inactiveColor: Colors.orange[100],
                          activeColor: Colors.orange,
                          onChanged: !_sliderSwitch ? null :(value) {
                            _manuallyChanged = true;
                            setState(() => _sliderValue = value);
                            try {
                              if(_timer.isActive) {
                                _timer.cancel();
                              }
                            }
                            catch (err) { print(err); }
                            _timer = Timer(Duration(milliseconds: ConstSliderTimeout), (){
                              radianceHelper.makePutRequest(
                                ConstBlynkServerIP, ConstBlynkAuthToken,
                                ConstBlynkSliderVpin, value.round().toString()
                              );
                              radianceHelper.storeSharedPref(
                                key: ConstSPSliderKey,
                                doubleVal: value
                              );                              
                            });
                          },
                        )
                      ),
                      Container(
                        width: 50.0,
                        alignment: Alignment.centerLeft,
                        //padding: EdgeInsets.only(right: 20.0),
                        child: Text('${_sliderValue.toInt()}',
                          style: radianceGetBodyTextStyle(radianceHelper.isDarkModeActive()),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ConstPadL, ConstPadT, ConstPadR, ConstPadB),
          )
        ],
      ),
    );
  }
}

