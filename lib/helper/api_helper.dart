import 'dart:convert';
import 'dart:io';

import 'package:daelim/config.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/models/auth_data.dart';
import 'package:daelim/models/user_data.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  /// - 로그인 api
  /// - [email]: 이메일
  /// - [password]: 비밀번호
  /// - return: AuthData
  static Future<AuthData?> signIn(
      {required String email, required String password}) async {
    final loginData = {
      "email": email,
      "password": password,
    };

    final response = await http.post(Uri.parse(Config.api.getToken),
        body: jsonEncode(loginData));

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      return null;
    }

    final bodyJson = jsonDecode(body) as Map<String, dynamic>;
    bodyJson.addAll({'email': email});

    try {
      return AuthData.fromMap(bodyJson);
    } catch (e, stack) {
      Log.red('유저 정보 파싱 에러: $e, $stack');
      return null;
    }
  }

  /// - 비밀번호 변경 api
  /// - [newPassword]: 새로운 비밀번호
  /// - return: (bool success, String error)
  static Future<(bool success, String error)> changePassword(
      String newPassword) async {
    final authData = StorageHelper.authData;
    final response = await http.post(
      Uri.parse(Config.api.changePassword),
      headers: {
        HttpHeaders.authorizationHeader:
            '${authData!.tokenType} ${authData.accessToken}'
      },
      body: jsonEncode({'password': newPassword}),
    );
    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      return (false, body);
    }

    return (true, '');
  }

  /// - 유저 목록 가져오는 api
  static Future<List<UserData>> fetchUserList() async {
    final authData = StorageHelper.authData;
    final response =
        await http.get(Uri.parse(Config.api.getUserList), headers: {
      HttpHeaders.authorizationHeader:
          '${authData!.tokenType} ${authData.accessToken}'
    });
    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      return [];
    }
    final bodyJson = jsonDecode(body);
    final List<dynamic> data = bodyJson['data'] ?? [];

    return data.map((e) => UserData.fromMap(e)).toList();
  }
}
