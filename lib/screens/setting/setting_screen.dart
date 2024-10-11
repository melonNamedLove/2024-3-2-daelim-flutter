import 'dart:convert';

import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  final int _selectedIndex = 0;

  // NOTE: 유저 정보 불러오기
  Future<Map<String, dynamic>> fetchUserData() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.accessToken;

    final response = await http.get(Uri.parse(getUserDataUrl),
        headers: {'Authorization': '$tokenType $token'});

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      throw Exception(body);
    }
    return jsonDecode(body);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.setting,
      child: Column(children: [
        FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Center(child: CircularProgressIndicator()));
              }
              final error = snapshot.error;
              final userData = snapshot.data;

              String name = '';
              String studentNumber = '';
              String profileImageUrl = '';

              if (error != null) {
                name = '';
                studentNumber = '';
              } else {
                name = userData!['name'];
                studentNumber = userData['student_number'];
                profileImageUrl = userData['profile_image'];
              }

              Log.green(userData);

              return ListTile(
                  leading: CircleAvatar(
                    // backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  title: Text(name),
                  subtitle: Text(studentNumber));
            })
      ]),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정")
      // ]),
    );
  }
}
