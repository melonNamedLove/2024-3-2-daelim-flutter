import 'package:flutter/material.dart';

enum AppScreen { login, main, setting }

extension AppScreenExtension on AppScreen {
  String get toPath {
    switch (this) {
      case AppScreen.login:
        return "/login";
      case AppScreen.main:
        return "/main";
      case AppScreen.setting:
        return "/setting";
    }
  }

  IconData get getIcon {
    switch (this) {
      case AppScreen.login:
        return Icons.face;
      case AppScreen.main:
        return Icons.home;
      case AppScreen.setting:
        return Icons.settings;
      default:
        return Icons.face;
    }
  }

//없어도 됨
  // String get toName {
  //   switch (this) {
  //     case AppScreen.login:
  //       return "LOGIN";
  //     case AppScreen.main:
  //       return "MAIN";
  //   }
  // }
}
