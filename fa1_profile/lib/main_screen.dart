import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  const ScreenContainer(
    this.text, {
    super.key,
    // required this.startAlignment,
    // required this.endAlignment,
    required this.screenColor
  });

  final String text;
  // final Alignment startAlignment;
  // final Alignment endAlignment;
  final Color screenColor;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenColor,
    );
  }
}
