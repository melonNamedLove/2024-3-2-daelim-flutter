import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationRail extends StatelessWidget {
  final AppScreen appScreen;

  const AppNavigationRail({super.key, required this.appScreen});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        onDestinationSelected: (value) {
          // Log.green("onDestinationSelected: $value");
          final screen = AppScreen.values[value + 1];
          context.goNamed(screen.name);
        },
        selectedIndex: appScreen.index - 1,
        destinations:
            AppScreen.values.filter((e) => e != AppScreen.login).map((e) {
          return NavigationRailDestination(
              icon: Icon(e.getIcon), label: Text(e.name));
        }).toList());
  }
}
