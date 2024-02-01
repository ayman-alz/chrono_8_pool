import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'settings_controller.dart';

class CountdownTimer extends StatefulWidget {
  final bool isRunning;

  CountdownTimer({Key? key, required this.isRunning}) : super(key: key);

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  int countdownValue = 30;
  Timer? _timer;
  late int valueSHarOrange = 0;
  late int valueSHarRed = 0;
  late int valueSHarLast = 0;
  late int valueSHarExtan = 0;

  @override
  void initState() {
    super.initState();
    getValueFromSharedPreferences();
    getValueFromSharedPreferences2();
    getValueFromSharedPreferences3();
    getValueFromSharedPreferences4();
  }

  Future<void> getValueFromSharedPreferences() async {
    valueSHarOrange = await getStoredData(DataType.ORANGE_ALARM.name);
    print(valueSHarOrange);
  }

  Future<void> getValueFromSharedPreferences2() async {
    valueSHarRed = await getStoredData(DataType.RED_ALARM.name);
    print(valueSHarRed);
  }

  Future<void> getValueFromSharedPreferences3() async {
    valueSHarExtan = await getStoredData(DataType.EXTENTION.name);
  }

  Future<void> getValueFromSharedPreferences4() async {
    valueSHarLast = await getStoredData(DataType.LAST_ALARM.name);
    print(valueSHarLast);
    if (valueSHarLast != 0) {
      setState(() {
        countdownValue = valueSHarLast;
      });
    }
  }

  Future<int> getStoredData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedData =
        prefs.getInt(key) ?? 0; // Default value is 0 if the key doesn't exist
    return storedData;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownValue > 0) {
        setState(() {
          countdownValue--;
        });
        if (countdownValue == valueSHarRed) {
          _vibrate();
          _vibrate();
          _vibrate();
        }
           if (countdownValue == valueSHarOrange) {
          _vibrateOrang();
        
        }
     
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      countdownValue = valueSHarLast;
    });
  }

  void updateTimerValue() {
    setState(() {
      countdownValue += valueSHarExtan;
    });
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 300);
    }
  }
  Future<void> _vibrateOrang() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 600);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$countdownValue",
        style: TextStyle(
          fontSize: 150,
          color: countdownValue < valueSHarRed
              ? Colors.red
              : countdownValue < valueSHarOrange
                  ? Colors.orange
                  : Colors.white,
        ),
      ),
    );
  }
}

class CountdownTimer2 extends StatefulWidget {

  CountdownTimer2({Key? key}) : super(key: key);

  @override
  CountdownTimer2State createState() => CountdownTimer2State();
}

class CountdownTimer2State extends State<CountdownTimer2> {
  late Timer _timer;
  int countdownValue = 2 * 60; // seconds
  late int valueSHarMInu;
  StreamController<int> _controller = StreamController<int>();

  @override
  void initState() {
    super.initState();
    getValueFromSharedPreferences4();
  }

  Future<void> getValueFromSharedPreferences4() async {
    valueSHarMInu = await getStoredData(DataType.MATCH_TIME.name);

    if (valueSHarMInu != 0) {
      setState(() {
        countdownValue = valueSHarMInu * 60; // convert minutes to seconds
        print(countdownValue);
      });
    }
  }

  Future<int> getStoredData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedData = prefs.getInt(key) ?? 0;
    return storedData;
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.close();
    super.dispose();
  }

  void stopTimer() {
    _timer.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if ((countdownValue) > 0) {
        setState(() {
          countdownValue--;
          _controller.add(countdownValue);
        });
      } else {
        timer.cancel();
      }
    });
  }

  /*void resetTimer() {
    setState(() {
      countdownValue = 0;
      _controller.add(countdownValue);
    });
  }*/

  String formatCountdown(int value) {
    int minutes = value ~/ 60;
    int seconds = value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<int>(
        stream: _controller.stream,
        initialData: countdownValue,
        builder: (context, snapshot) {
          return Text(
            formatCountdown(snapshot.data ?? 0),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
