import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      appScreen: AppScreen.main,
      child: Center(
          child: Text(
        "메인",
        style: TextStyle(fontSize: 40),
      )),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정")
      // ]),
    );
  }
}
