//import 'package:fa1_profile/main.dart';
import 'package:flutter/material.dart';
import 'package:fa1_profile/commons/styled_text.dart';


class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.shadowColor,
    required this.elevationValue,
    required this.gradientColors,
    required this.gradientBegin,
    required this.gradientEnd,
    required this.imageLink,
    required this.profileName,
    required this.profileProgram,
    required this.profileBio,
    required this.profileTextColor,
    required this.profileFontFamily,
    required this.profileTextSpacing,
    required this.cardBorderRadius,
    required this.profileNameSize,
    required this.profileNameColor,
    required this.profileProgramColor,
    required this.profileBioColor,
  });

  final double cardWidth;
  final double cardHeight;
  final Color shadowColor;
  final double elevationValue;
  final List<Color> gradientColors;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final String imageLink;
  final String profileName;
  final String profileProgram;
  final String profileBio;
  final Color profileTextColor;
  final String profileFontFamily;
  final double profileTextSpacing;
  final double cardBorderRadius;
  final double profileNameSize;
  final Color profileNameColor;
  final Color profileProgramColor;
  final Color profileBioColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        elevation: elevationValue,
        shadowColor: shadowColor,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius), 
        ),
        child: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: gradientBegin,
              end: gradientEnd,
            )
          ),
          child: Column(
            spacing: profileTextSpacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageLink, 
                height: 250,
              ),
              StyledText(profileName, profileNameSize, profileNameColor, profileFontFamily, FontStyle.normal),
              StyledText(profileProgram, profileNameSize*0.75, profileProgramColor, profileFontFamily, FontStyle.normal),
              StyledText(profileBio, profileNameSize*0.50, profileBioColor, profileFontFamily, FontStyle.italic),
            ],
          ),
        )
      ),
    );
  }
}