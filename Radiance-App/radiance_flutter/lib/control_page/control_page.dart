import 'package:flutter/material.dart';

import 'package:radiance_flutter/constants.dart';

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: EdgeInsets.fromLTRB(ConstPadL, ConstPadT, ConstPadR, ConstPadB),
            child: Slider(
              value: 50.0,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              activeColor: Colors.orange,
              onChanged: (value) {
                
              },
            ),
          )
        ],
      ),
    );
  }
}
