import 'package:flutter/material.dart';
import 'package:fa2_quiz/commons/styled_text.dart';
import 'package:fa2_quiz/home.dart';

const buttonHorizontalPadding = 40.0;
const buttonVerticalPadding = 10.0;
const answerTextButtonSize = 20.0;
const answerButtonBorderRadius = 10.0;

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: buttonHorizontalPadding,
          vertical: buttonVerticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(answerButtonBorderRadius),
        ),
      ),
      child: StyledText(text, answerTextButtonSize, color: answerTextColor),
    );
  }
}
