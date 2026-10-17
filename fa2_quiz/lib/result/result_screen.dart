import 'package:flutter/material.dart';
import 'package:fa2_quiz/commons/styled_text.dart';
import 'package:fa2_quiz/data/question_data.dart';
import 'package:fa2_quiz/home.dart';

const resultTextSize = 20.0;
const sizedBoxHeight = 50.0;
const resultScreenMargin = 20.0;

class ResultScreen extends StatefulWidget {
  const ResultScreen(this.switchScreen, {super.key});

  final void Function(String) switchScreen;

  void outlinedButtonPressed() {
    switchScreen('home-screen');
  }

  @override
  State<ResultScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ResultScreen> {

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        margin: EdgeInsets.all(resultScreenMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StyledText(finalResult, resultTextSize, color: textColor),

            SizedBox(
              height: sizedBoxHeight,
            ),

            OutlinedButton.icon(
                onPressed: widget.outlinedButtonPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: homeButtonBorderColor),
                  backgroundColor: startButtonColor,
                  foregroundColor: textColor,
                ),
                icon: const Icon(Icons.home),
                label: StyledText(homeButtonText, homeButtonTextSize, color: textColor),
              ),
          ],
        ),
      ),
    );
  }
}
