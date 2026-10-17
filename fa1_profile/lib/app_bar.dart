import 'package:fa1_profile/commons/styled_text.dart';
import 'package:fa1_profile/main.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MainAppBar(
    this.text, {
    super.key,
    required this.elevationValue,
    required this.shadowColor,
    required this.barColor,
    required this.barTextColor,
    required this.barFontFamily,
  });

  final String text;
  final double elevationValue;
  final Color shadowColor;
  final Color barColor;
  final Color barTextColor;
  final String barFontFamily;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: StyledText(text, 30, barTextColor, barFontFamily, FontStyle.normal),
      elevation: elevationValue,
      shadowColor: shadowColor,
      backgroundColor: bgColor1,
    );
  }
}
