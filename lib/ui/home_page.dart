import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/applocal.dart';
import '../components/shared_pref_helper.dart';
import '../controller/settings_controller.dart';
import '../controller/timer.dart';
import '../model/score.dart';
import '../constants/globals.dart' as globals;
import 'package:cast/cast.dart';

import 'cast_screen.dart';


class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<CountdownTimerState> countdownTimer =
      GlobalKey<CountdownTimerState>();
  GlobalKey<CountdownTimer2State> countdownMatch =
      GlobalKey<CountdownTimer2State>();

  bool isTimerRunning = false;
  bool isMatchRunning = false;
  bool resetAll = false;

  bool isFirstTap = true;
  int timeMinutes = 0;
  @override
  void initState() {
    super.initState();
    getValueFromSharedPreferences();
    isFirstTap = true;
    isTimerRunning = false;
  }

  Future<int> getStoredData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedData =
        prefs.getInt(key) ?? 0; // Default value is 0 if the key doesn't exist
    return storedData;
  }

  Future<void> getValueFromSharedPreferences() async {
    if (globals.resetMatchTime) {
      timeMinutes = await getStoredData(DataType.MATCH_TIME.name);
      setState(() {});
      print(timeMinutes);
      globals.resetMatchTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Image.asset('assets/logo.jpg'), // Replace 'logo_photo.png' with your actual image file
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CastScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed("Settings");
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 65.0,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onDoubleTap: isFirstTap
                        ? () {
                            countdownTimer.currentState?.updateTimerValue();
                            setState(() {
                              isFirstTap = false;
                            });
                          }
                        : null,
                    child: Center(
                      child: Text(
                        "${getLang(context, "extention")}",
                        style: TextStyle(
                            fontSize: 30,
                            color: isFirstTap ? Colors.blue : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FutureBuilder<String?>(
                  future: SharedPreferencesHelper.getPlayer1Name(),
                  builder: (context, snapshot) {
                    String player1Name = snapshot.data ?? 'Player 1';
                    return Text(
                      "$player1Name  ${context.watch<Score>().player1Score ?? 0}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
                const Spacer(),
                FutureBuilder<String?>(
                  future: SharedPreferencesHelper.getPlayer2Name(),
                  builder: (context, snapshot) {
                    String player2Name = snapshot.data ?? 'Player 2';
                    return Text(
                      "$player2Name  ${context.watch<Score>().player2Score ?? 0}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isTimerRunning) {
                    isTimerRunning = false;
                    countdownTimer.currentState?.stopTimer();
                  } else {
                    isTimerRunning = true;
                    countdownTimer.currentState?.startTimer();
                  }
                  if (isMatchRunning == false) {
                    countdownMatch.currentState?.startTimer();
                    isMatchRunning = true;
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  isFirstTap = true;
                  isTimerRunning = false;
                  countdownTimer.currentState?.resetTimer();
                });
              },
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${getLang(context, "match_time")}: ",
                            style: const TextStyle(color: Colors.white)),
                        CountdownTimer2(key: countdownMatch),
                      ],
                    ),
                    CountdownTimer(
                        key: countdownTimer, isRunning: isTimerRunning),
                  ],
                ),
              ),
            ),
          ),
          // SharedPreferencesHelper
          FutureBuilder<String?>(
            future: SharedPreferencesHelper.getImg(),
            builder: (context, snapshot) {
              String imgUrl = snapshot.data ??"";
              return imgUrl != "" ?Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                imgUrl ,
                  height: 150.0,
                ),
              ) : Container(
                color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: Text(""));
            },
          ),
        ],
      ),
    );
  }
}
