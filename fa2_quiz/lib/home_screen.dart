import 'package:flutter/material.dart';
import 'package:fa2_quiz/commons/styled_text.dart';
import 'package:fa2_quiz/home.dart';

const homeTextSize = 30.0;
const homeImage = 'assets/greek_myth_logo.png';
const homeImageHeight = 300.0;
const homeImageWidth = 300.0;
const homeSizedBoxSizeHeight = 10.0;
const homeScreenSpacing = 10.0;
const quizName = 'Greek Mythology Quiz';
const startButtonText = 'Start';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.switchScreen, {super.key});

  final void Function(String) switchScreen;

  void outlinedButtonPressed() {
    switchScreen('profile-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: homeScreenSpacing,
            children: [
              Image.asset(
                  homeImage,
                  width: homeImageHeight,
                  height: homeImageWidth,
                ),

              SizedBox(height: homeSizedBoxSizeHeight),

              StyledText(quizName, homeTextSize, color: textColor),

              // Main page button
              OutlinedButton.icon(
                onPressed: outlinedButtonPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: homeButtonBorderColor),
                  backgroundColor: startButtonColor,
                  foregroundColor: textColor,
                ),
                icon: const Icon(Icons.check),
                label: StyledText(startButtonText, homeButtonTextSize, color: textColor),
              ),
            ],
          );
  }
}