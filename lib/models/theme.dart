// theme model
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/data.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    getCurrentTheme();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Get the current theme's primary color
  Color get primaryColor =>
      _isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.lightPrimaryColor;

  // Get the current theme's accent color
  // Color get accentColor => _isDarkMode ? AppTheme.darkAccentColor : AppTheme.lightAccentColor;

  // Get the current theme's background color
  Color get backgroundColor => _isDarkMode
      ? AppTheme.darkBackgroundColor
      : AppTheme.lightBackgroundColor;

  // Get the current theme's text color
  Color get textColor =>
      _isDarkMode ? AppTheme.darkTextColor : AppTheme.lightTextColor;

  Color get cardColor =>
      _isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor;

  Color get cardTextColor =>
      _isDarkMode ? AppTheme.darkCardTextColor : AppTheme.lightCardTextColor;

  Color get submitButtonColor => _isDarkMode
      ? AppTheme.darkSubmitButtonColor
      : AppTheme.lightSubmitButtonColor;

  Color get disabledColor =>
      _isDarkMode ? AppTheme.darkDisabledColor : AppTheme.lightDisabledColor;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkMode);
  }

  // set dark theme method
  void setDarkTheme() async {
    _isDarkMode = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkMode);
  }

  // set light theme method
  void setLightTheme() async {
    _isDarkMode = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkMode);
  }

  // get current theme from shared preferences
  void getCurrentTheme() async {
    bool? value = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getBool('isDarkTheme'));
    if (value != null) {
      if (value == true) {
        _isDarkMode = true;
        notifyListeners();
      } else {
        _isDarkMode = false;
        notifyListeners();
      }
    }

    // void setLocalTheme()async{
    //   // bool value = await AppPreferences.getBoolValue('isDarkTheme');
    //   // if(value != null){
    //   //   if(value == true){
    //   //     _isDarkMode = true;
    //   //     notifyListeners();
    //   //   }else{
    //   //     _isDarkMode = false;
    //   //     notifyListeners();
    //   //   }
    //   // }else{
    //   //   _isDarkMode = false;
    //   //   notifyListeners();
    //   // }
    // }
  }
}
