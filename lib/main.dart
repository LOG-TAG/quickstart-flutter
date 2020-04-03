import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hypertrack_plugin/hypertrack.dart';

void main() => runApp(HyperTrackQuickStart());

class HyperTrackQuickStart extends StatefulWidget {
  @override
  _HyperTrackQuickStartState createState() => _HyperTrackQuickStartState();
}

class _HyperTrackQuickStartState extends State<HyperTrackQuickStart> {
  static const key =
      'FgqJ1Lhcxiuhm_2IDFokRVOGYNhohERo2jGFUZ9q5EdmKr2OhlcxJh7XIR3HknWVzNmCxJ2FYGYK9rlCTfHWpw';
  //static const key = '<PUBLISHABLE_KEY GOES HERE>';
  String _result = 'Not initialized';
  String _deviceId = '';
  HyperTrack sdk;
  String buttonLabel = 'Start Tracking';
  Color buttonColor = Colors.green;
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<String> test() async {
    Duration t = Duration(seconds: 10);
    sleep(t);
    return "Test";
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initializeSdk() async {
    HyperTrack.enableDebugLogging();
    // Initializer is just a helper class to get the actual sdk instance
    String result = 'failure';
    try {
      sdk = await HyperTrack.initialize(key);
      result = 'initialized';
      sdk.setDeviceName("Flutter Elvis");
      sdk.setDeviceMetadata({"source": "flutter sdk"});
      sdk.onTrackingStateChanged.listen((TrackingStateChange event) {
        if (mounted) {
          setState(() {
            _result = '$event';
          });
        }
      });
    } catch (e) {
      print(e);
    }

    final deviceId = (sdk == null) ? "unknown" : await sdk.getDeviceId();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
      _deviceId = deviceId;
    });
  }

  void start() => sdk.start();

  void stop() => sdk.stop();

  void syncDeviceSettings() => sdk.syncDeviceSettings();

  Text getDeviceIdText() {
    return Text(
      _deviceId,
      style: TextStyle(fontSize: 16.0),
    );
  }

  Text displayButton() {
    return (Text(
      this.buttonLabel,
      style: TextStyle(color: Colors.white),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(
              'Quickstart',
              style: TextStyle(),
            )),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Center(
                  child: getDeviceIdText(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(20.0),
                  color: buttonColor,
                  onPressed: () {
                    if (this.buttonLabel == "Stop Tracking") {
                      stop();
                    } else {
                      start();
                    }
                    setState(() {
                      if (this.buttonLabel == "Start Tracking") {
                        this.buttonLabel = "Stop Tracking";
                        this.buttonColor = Colors.red;
                      } else {
                        this.buttonLabel = "Start Tracking";
                        this.buttonColor = Colors.green;
                      }
                    });
                  },
                  child: displayButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
