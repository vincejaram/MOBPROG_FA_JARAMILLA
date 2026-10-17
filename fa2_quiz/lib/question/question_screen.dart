import 'package:flutter/material.dart';
import 'package:fa2_quiz/commons/styled_button.dart';
import 'package:fa2_quiz/commons/styled_text.dart';
import 'package:fa2_quiz/data/question_data.dart';
import 'package:fa2_quiz/home.dart';
import 'package:fa2_quiz/model/question.dart';

const questionScreenMargin = 20.0;
const questionTextSize = 30.0;
const answerTextSize = 20.0;
const answerSpacing = 15.0;
const scoreTextSize = 20.0;
const sizedBoxHeight = 50.0;

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(this.switchScreen, {super.key});

  final void Function(String) switchScreen;

  void outlinedButtonPressed() {
    switchScreen('home-screen');
  }

  void updateScore(int questionNum, String questionText, buttonText, answerText){
    finalResult += '${questionNum + 1}. Your Answer: $buttonText;\t\t\tCorrect Answer: $answerText\n';
    if (buttonText == answerText) { //if correct
      finalScore++;
    }
    if(questionNum == questionData.length - 1){
      finalResult += 'SCORE: $finalScore';
    }
  }

  void finalButtonPressed(int questionNum, String questionText, buttonText, answerText){
    switchScreen('result-screen');
    updateScore(questionNum, questionText, buttonText, answerText);
  }

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var questionIndex = 0;

  void infoClick(int questionNum, String questionText, buttonText, answerText) {
    setState(() {
      questionIndex = (questionIndex + 1);
    });
    widget.updateScore(questionNum, questionText, buttonText, answerText);
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = questionData[questionIndex];

    return Center(
      child: Container(
        margin: EdgeInsets.all(questionScreenMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: answerSpacing,
          children: [
            StyledText(currentQuestion.question, questionTextSize, color: textColor),
            StyledText('Current Score: $finalScore', scoreTextSize, color: textColor),
            ...currentQuestion.getShuffledList().map(
              (choice) => StyledButton(
                text: choice,
                onPressed: questionIndex < questionData.length - 1
                ? () => infoClick(questionIndex, currentQuestion.question, choice, currentQuestion.choice[0])
                : () => widget.finalButtonPressed(questionIndex, currentQuestion.question, choice, currentQuestion.choice[0]),
              ),
            ),

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
