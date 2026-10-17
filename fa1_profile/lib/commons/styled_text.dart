import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, this.fontSize, this.fontColor, this.fontFamily, this.specialFontStyle, {super.key});

  final String text;
  final double? fontSize;
  final dynamic fontColor;
  final String fontFamily;
  final FontStyle specialFontStyle;

  @override
  Widget build(context) {
    // return Text(
    //           text,
    //           style: TextStyle(color: fontColor, fontSize: fontSize),
    //           textAlign: TextAlign.center,
    //         );
    return Text(
      text,
      style: GoogleFonts.getFont(
        fontFamily, 
        fontSize: fontSize,
        color: fontColor, 
        fontStyle: specialFontStyle,
      ),
      textAlign: TextAlign.center,
    );
  }
}