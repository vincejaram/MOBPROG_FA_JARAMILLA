//import 'package:fa1_profile/commons/styled_text.dart';
import 'package:fa1_profile/app_bar.dart';
import 'package:fa1_profile/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:fa1_profile/main_screen.dart';

const startAlignment = Alignment.bottomCenter;
const endAlignment = Alignment.topCenter;
const bgColor1 = Colors.green;
const bgColor2 = Colors.greenAccent;
const shadowColor = Colors.black;
const cardWidth = 390.0;
const cardHeight = 520.0;
const elevationValue = 5.0;
const gradientColors = [Colors.green, Colors.lightGreenAccent, Colors.green];
const gradientBegin = Alignment.topCenter;
const gradientEnd = Alignment.bottomCenter;
const imageLink = 'assets/img/profile_pic.jpg';
const profileName = 'Vince Matthew R. Jaramilla';
const profileProgram = 'BS Applied Mathematics \n(Information Technology Track)';
const profileBio = 'Math Major. Programmer. Journalist. Musician.';
const profileTextColor = Colors.black;
const profileFontFamily = 'Anton';
const barTextColor = Colors.black;
const barFontFamily = 'Montserrat';
const profileTextSpacing = 25.0;
const cardBorderRadius = 20.0;
const profileNameSize = 24.0;
const profileNameColor = Colors.black;
const profileProgramColor = Colors.black;
const profileBioColor = Colors.black;

void main() {
  runApp(
    MaterialApp(
      title: 'Profile',
      home: Scaffold(
        appBar: MainAppBar(
          'Profile',
          elevationValue: elevationValue,
          shadowColor: shadowColor,
          barColor: bgColor1,
          barTextColor: barTextColor,
          barFontFamily: barFontFamily,
        ),
        body: Stack(
          children: [
            ScreenContainer(
            '',
            // startAlignment: startAlignment,
            // endAlignment: endAlignment,
            screenColor: bgColor2,
            ),
            const Center(
              child: ProfileCard(
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                shadowColor: shadowColor,
                elevationValue: elevationValue,
                gradientColors: gradientColors,
                gradientBegin: gradientBegin,
                gradientEnd: gradientEnd,
                imageLink: imageLink,
                profileName: profileName,
                profileProgram: profileProgram,
                profileBio: profileBio,
                profileTextColor: profileTextColor,
                profileFontFamily: profileFontFamily,
                profileTextSpacing: profileTextSpacing,
                cardBorderRadius: cardBorderRadius,
                profileNameSize: profileNameSize,
                profileNameColor: profileNameColor,
                profileProgramColor: profileProgramColor,
                profileBioColor: profileBioColor,
              )
            ),
          ],
        ),
      ),
    ),
  );
}
