import 'package:flutter/material.dart';
import 'package:radiance_flutter/constants.dart';
import 'package:radiance_flutter/radiance_helper.dart';
import 'package:radiance_flutter/style.dart';

class ControlPage extends StatelessWidget {

  double _sliderValue = 30;

  @override
  Widget build(BuildContext context) {

    final RadianceHelper radianceHelper = RadianceHelper(context);

    // Check network
    Future<List> networkState = radianceHelper.isNetworkConnected();
    networkState.then((value) {
      if(value[0] == false) {
        radianceHelper.showAlert(ConstNoNetworkAlertTitle, ConstNoNetworkAlertBody);
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        title: ConstAppBarTitle,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1st Widget
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            decoration: BoxDecoration(color: Colors.grey),
            child: Image.network(
              ConstImageURL,
              fit: BoxFit.cover,
            ),
          ),
          // 2nd widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  value: _sliderValue,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    _sliderValue = value;
                  },
                )
              ),
              Container(
                width: 40.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20.0),
                child: Text('${_sliderValue.toInt()}',
                  style: radianceGetBodyTextStyle(radianceHelper.isDarkModeActive()),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ConstPadL, ConstPadT, ConstPadR, ConstPadB),
          )
        ],
      ),
    );
  }
}
