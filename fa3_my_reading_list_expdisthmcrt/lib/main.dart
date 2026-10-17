import 'package:fa3_my_reading_list_expdisthmcrt/books/books_screen.dart';
import 'package:flutter/material.dart';

Color defaultColor = Colors.redAccent;
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
          theme: ThemeData().copyWith(
            colorScheme: kColorScheme,
            appBarTheme: AppBarTheme().copyWith(
              backgroundColor: kColorScheme.primaryContainer,
              foregroundColor: kColorScheme.onPrimaryContainer,
            ),
            cardTheme: CardThemeData().copyWith(
              color: kColorScheme.secondaryContainer,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
                foregroundColor: kColorScheme.onPrimaryContainer,
              ),
            ),
            textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 22,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 14,
              )
            ),
          ),
          darkTheme: ThemeData().copyWith(
            colorScheme: kDarkColorScheme,
            appBarTheme: AppBarTheme().copyWith(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer,
            ),
            cardTheme: CardThemeData().copyWith(
              color: kDarkColorScheme.secondaryContainer,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.primaryContainer,
                foregroundColor: kDarkColorScheme.onPrimaryContainer,
              ),
            ),
            textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 22,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: kDarkColorScheme.onSecondaryContainer,
                fontSize: 14,
              )
            ),
          ),
          //------------------------------------------------------------------------
          themeMode: currentThemeMode,
          home: BooksScreen(),
        );
      }
    ),
  );
}
