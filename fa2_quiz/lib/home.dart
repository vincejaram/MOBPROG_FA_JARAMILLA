import 'package:flutter/material.dart';
import 'package:fa2_quiz/home_screen.dart';
import 'package:fa2_quiz/question/question_screen.dart';
import 'package:fa2_quiz/result/result_screen.dart';
import 'package:fa2_quiz/data/question_data.dart';

const bgColor = Colors.grey;
const textColor = Colors.white;
const answerButtonColor = Colors.white;
const answerTextColor = Colors.black;
const startButtonColor = Colors.black;
const homeButtonTextSize = 15.0;
const homeButtonBorderColor = Colors.white;
const homeButtonText = 'Home';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var activeScreen = 'home-screen';

  void switchScreen(String newScreen) {
    setState(() {
      activeScreen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = HomeScreen(switchScreen);

    if (activeScreen == 'profile-screen') {
      currentScreen = QuestionScreen(switchScreen);
      finalResult = "RESULTS\n";
      finalScore = 0;
    } else if (activeScreen == 'result-screen') {
      currentScreen = ResultScreen(switchScreen);
    }

    return MaterialApp(
      title: 'Formattive Assessment 2',
      home: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: currentScreen,
        ),
      ),
    );
  }
}
