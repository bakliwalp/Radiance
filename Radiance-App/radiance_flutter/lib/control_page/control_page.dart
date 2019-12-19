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
  bool _motionControl = true;
  Timer _timer;
  int _motionTimeoutValue = 0;
  List _motionTimeoutList = [1,2,3,5,10,15,30];
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
          // fetch V2 from blynk server
          radianceHelper.makeGetRequest(ConstBlynkServerIP, ConstBlynkAuthToken, ConstBlynkSliderVpin)
          .then((resp) {
            print(_sliderValue);
            setState(() {
              _sliderValue = double.parse(jsonDecode(resp.body)[0]);
              if (_sliderValue > 0) {
                _sliderSwitch = true;
              }
              else {
                radianceHelper.fetchSharedPref(key: ConstSPSliderKey).then((val) {
                  _sliderValue = val;
                  _sliderSwitch = false;
                });
              }
            });
          });
          // fetch v3 from blynk server
          radianceHelper.makeGetRequest(ConstBlynkServerIP, ConstBlynkAuthToken, ConstBlynkMotionVpin)
          .then((resp) {
            int _fetchedValue = int.parse(jsonDecode(resp.body)[0]);
            setState(() {
              _fetchedValue = _motionTimeoutList.indexOf(_fetchedValue);
              if(_fetchedValue > -1) {
                _motionTimeoutValue = _fetchedValue;
              }
              else {
                radianceHelper.fetchSharedPref(key: ConstSPTimeoutKey).then((val) {
                  _motionTimeoutValue = val;
                });
              }
            });
          });
          // fetch v1 from blynk server
          radianceHelper.makeGetRequest(ConstBlynkServerIP, ConstBlynkAuthToken, ConstBlynkMotionControlVpin)
          .then((resp) {
            int _fetchedValue = int.parse(jsonDecode(resp.body)[0]);
            setState(() {
              if(_fetchedValue == 1) {
                _motionControl = true;
              }
              else if (_fetchedValue == 2) {
                _motionControl = false;
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
      body: 
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1st ImageCard
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
                      padding: EdgeInsets.only(left: ConstPadL, top: ConstPadT/2),
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
                    // Add timer row
                    Container(
                      padding: EdgeInsets.only(left: ConstPadL, right: ConstPadR, top: ConstPadT/2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Motion Timeout Icon & label
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(right: ConstPadR/2),
                                    icon: Icon(Icons.timer),
                                    color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
                                    onPressed: () => {},
                                  ),
                                  radianceGetTextLabel(
                                    textToDisplay: constTimerLabel,
                                    textAlignment: TextAlign.center,
                                    radHelper: radianceHelper
                                  )
                                ],
                              ),
                            ],
                          ),
                          // Motion timeout button and labels
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(right: ConstPadR/2),
                                    icon: Icon(Icons.remove_circle_outline),
                                    color: radianceHelper.isDarkModeActive() ? (_motionTimeoutValue > 0 ? RadianceTextDarkThemeColor : Colors.grey[300]) : (_motionTimeoutValue > 0 ? RadianceTextLightThemeColor : Colors.grey[300]),
                                    onPressed: () => onTimeoutMinus(radianceHelper),
                                    tooltip: "Reduce Timeout",
                                  ),
                                  radianceGetTextLabel(
                                    textToDisplay: _motionTimeoutList[_motionTimeoutValue].toString() + " Mins",
                                    textAlignment: TextAlign.center,
                                    radHelper: radianceHelper
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(left: ConstPadL, right: ConstPadR/2),
                                    icon: Icon(Icons.add_circle_outline),
                                    color: radianceHelper.isDarkModeActive() ? (_motionTimeoutValue < _motionTimeoutList.length-1 ? RadianceTextDarkThemeColor : Colors.grey[300]) : (_motionTimeoutValue < _motionTimeoutList.length-1 ? RadianceTextLightThemeColor : Colors.grey[300]),
                                    onPressed: () => onTimeoutPlus(radianceHelper),
                                    tooltip: "Increase Timeout",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add motion control row
                    Container(
                      padding: EdgeInsets.only(left: ConstPadL, right: ConstPadR),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(right: ConstPadR/2),
                                    icon: Icon(Icons.directions_walk),
                                    color: radianceHelper.isDarkModeActive() ? RadianceTextDarkThemeColor : RadianceTextLightThemeColor,
                                    onPressed: () => {},
                                  ),
                                  radianceGetTextLabel(
                                    textToDisplay: constMotionLabel,
                                    textAlignment: TextAlign.center,
                                    radHelper: radianceHelper
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Add motion checkbox
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Checkbox(
                                value: _motionControl,
                                onChanged: (val) {
                                  setState(() => _motionControl = val);
                                  radianceHelper.makePutRequest(ConstBlynkServerIP, ConstBlynkAuthToken,
                                    ConstBlynkMotionControlVpin, _motionControl ? "1" : "2");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onTimeoutPlus(RadianceHelper radianceHelper) {
    if(_motionTimeoutValue < _motionTimeoutList.length-1) {
      _manuallyChanged = true;
      setState(() {
        _motionTimeoutValue++;
      });
      radianceHelper.makePutRequest(ConstBlynkServerIP, ConstBlynkAuthToken,
        ConstBlynkMotionVpin, _motionTimeoutList[_motionTimeoutValue].toString());
      radianceHelper.storeSharedPref(
        key: ConstSPTimeoutKey,
        intVal: _motionTimeoutValue
      );
    }
  }

  void onTimeoutMinus(RadianceHelper radianceHelper) {
    if(_motionTimeoutValue > 0) {
      _manuallyChanged = true;
      setState(() {
        _motionTimeoutValue--;
      });
      radianceHelper.makePutRequest(ConstBlynkServerIP, ConstBlynkAuthToken,
        ConstBlynkMotionVpin, _motionTimeoutList[_motionTimeoutValue].toString());
      radianceHelper.storeSharedPref(
        key: ConstSPTimeoutKey,
        intVal: _motionTimeoutValue
      );
    }
  }
}

