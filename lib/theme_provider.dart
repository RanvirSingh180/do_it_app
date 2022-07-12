import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/utils/fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    primaryColor: Colors.white,
    fontFamily: comfortaa,
    primaryColorLight: Colors.white54,
    primaryColorDark: Colors.redAccent,
    textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white)),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
    ),
    dividerTheme: const DividerThemeData(color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      backgroundColor: Colors.white,
      primaryColorLight: Colors.black26,
      fontFamily: comfortaa,
      brightness: Brightness.light,
      primaryColor: Colors.black,
      primaryColorDark: Colors.red,
      textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black)),
      dividerTheme: const DividerThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.grey.shade500));
}
