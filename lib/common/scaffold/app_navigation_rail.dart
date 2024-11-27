import 'package:daelim/common/extensions/context_extension.dart';
import 'package:daelim/helper/api_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationRail extends StatelessWidget {
  final AppScreen appScreen;

  const AppNavigationRail({super.key, required this.appScreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            backgroundColor: context.thene.scaffoldBackgroundColor,
            onDestinationSelected: (value) {
              // Log.green("onDestinationSelected: $value");
              final screen = AppScreen.values[value + 2];
              context.goNamed(screen.name);
            },
            selectedIndex: appScreen.index - 2,
            destinations: AppScreen.values
                .filter((e) => e != AppScreen.login && e != AppScreen.chat)
                .map((e) {
              return NavigationRailDestination(
                  icon: Icon(e.getIcon), label: Text(e.name));
            }).toList(),
          ),
        ),
        10.heightBox,
        IconButton(
            onPressed: () => ApiHelper.signOut(context),
            icon: const Icon(Icons.logout)),
        10.heightBox
      ],
    );
  }
}
