

import 'package:flutter/material.dart';
import 'package:twiter_clone/themes/dark_mode.dart';
import 'package:twiter_clone/themes/light_mode.dart';

/**
 Theme provide:


 this help us to chnage app from loght mode to dark modee

 */


class ThemeProvider with ChangeNotifier{
  //initally set as light mode

  ThemeData _themeData=lightMode;

  //get the curent theme 
  ThemeData get themeData=>_themeData;

  //is it dark mode currently?

  bool get isDarkMode=>_themeData==darkMode;

  //set the theme 
  set themeData(ThemeData themeData){
    _themeData=themeData;
    //update the ui
    notifyListeners();
  }

  //toggle between the light and dark mode
  void toggleTheme(){
    if(_themeData==darkMode){
      themeData=lightMode;

    }else{
      themeData=darkMode;
    }
  }
}