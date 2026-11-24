import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/widget/home_screen.dart';
import 'package:flutter/material.dart';

Color defaultColor = defaultSeedColor;
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
var kColorScheme = ColorScheme.fromSeed(
  seedColor: defaultColor,
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: defaultColor,
);

void main() {
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: kColorScheme,
            scaffoldBackgroundColor: kColorScheme.primaryContainer,
            appBarTheme: AppBarTheme().copyWith(
              backgroundColor: Colors.transparent,
              foregroundColor: kColorScheme.onPrimaryContainer,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kColorScheme.onPrimaryContainer,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            cardTheme: CardThemeData().copyWith(
              color: kColorScheme.primaryContainer,
              margin: EdgeInsets.symmetric(
                vertical: (MediaQuery.sizeOf(context).height)*0.015,
              ),
            ),
            inputDecorationTheme: InputDecorationThemeData(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kColorScheme.onPrimaryContainer, width: 2.0),
              ),
            ),
            textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 40,
                height: 1.4,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 12,
              )
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: kDarkColorScheme,
            scaffoldBackgroundColor: kDarkColorScheme.primaryContainer,
            appBarTheme: AppBarTheme().copyWith(
              backgroundColor: Colors.transparent,
              foregroundColor: kDarkColorScheme.onPrimaryContainer,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kDarkColorScheme.onPrimaryContainer,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.onPrimaryContainer,
                foregroundColor: kDarkColorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            cardTheme: CardThemeData().copyWith(
              color: kDarkColorScheme.primaryContainer,
              margin: EdgeInsets.symmetric(
                vertical: (MediaQuery.sizeOf(context).height)*0.015,
              ),
            ),
            inputDecorationTheme: InputDecorationThemeData(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kDarkColorScheme.onPrimaryContainer, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kDarkColorScheme.onPrimaryContainer, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kDarkColorScheme.onPrimaryContainer, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kDarkColorScheme.onPrimaryContainer, width: 2.0),
              ),
            ),
            textTheme: ThemeData.dark().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 40,
                height: 1.4,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 12,
              )
            ),
          ),
          themeMode: currentThemeMode,
          home: HomeScreen(),
        );
      }
    ),
  );
}