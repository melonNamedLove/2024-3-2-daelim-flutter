import 'dart:convert';
import 'dart:io';

import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/setting/dialog/change_password_dialog.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? _name;
  String? _studentNumber;
  String? _profileImageUrl;

  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // NOTE: 유저 정보 불러오기
  Future<void> _fetchUserData() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.accessToken;

    final response = await http.get(Uri.parse(Config.api.getUserData),
        headers: {'Authorization': '$tokenType $token'});

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

// NOTE 에러 발생
    if (statusCode != 200) {
      // throw Exception(body);
      setState(() {
        _name = '데이터를 불러올 수 없습니다.';
        _studentNumber = body;
        _profileImageUrl = '';
      });
      return;
    }
    final userData = jsonDecode(body);

    setState(() {
      _name = userData!['name'];
      _studentNumber = userData['student_number'];
      _profileImageUrl = userData['profile_image'];
    });
  }

//NOTE 프로필 이미지 없로드
  Future<void> _uploadProfileImage() async {
    if (_profileImageUrl == null || _profileImageUrl?.isEmpty == true) {
      return;
    }
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;

    final imageFile = result.files.single;
    final imageBytes = imageFile.bytes;
    final imageName = imageFile.name;
    final imagePath = imageFile.path;
    final imageMime = lookupMimeType(imageName) ?? "image/jpeg"; //   image/jpeg

// NOTE Mime 타입 자르기
    final mimeSplit = imageMime.split('/');
    final mimeType = mimeSplit.first;
    final mimeSubType = mimeSplit.last;

    Log.green('프로필 이미지 업로드 imageName:$imageName imageMime:$imageMime');

    if (imagePath == null) return;

    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.accessToken;

    final uploadRequest = http.MultipartRequest(
        'POST', Uri.parse(Config.api.setProfileImage))
      ..headers.addAll({HttpHeaders.authorizationHeader: '$tokenType $token'})
      ..files.add(await http.MultipartFile.fromPath('image', imagePath,
          contentType: MediaType(mimeType, mimeSubType)));

    Log.green('이미지 업로드');
    final response = await uploadRequest.send();
    final uploadResult = await http.Response.fromStream(response);

    if (uploadResult.statusCode != 200) {
      Log.red('프로필 이미지 업로드 실패 ${uploadResult.statusCode}');
      return;
    }
    Log.green('프로필 이미지 업로드 완료 ${uploadResult.statusCode}');

    _fetchUserData();

//     var uri = Uri.https('example.com', 'create');
// var request = http.MultipartRequest('POST', uri)
//   ..fields['user'] = 'nweiz@google.com'
//   ..files.add(await http.MultipartFile.fromPath(
//       'package', 'build/package.tar.gz',
//       contentType: MediaType('application', 'x-tar')));
// var response = await request.send();
// if (response.statusCode == 200) print('Uploaded!');
  }

  Future<void> _changePasswordDialog() async {
    showDialog(
        context: context, builder: (context) => const ChangePasswordDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.setting,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14.0),
        child: Column(
          children: [
            //NOTE 유저 정보 표시(프로필 사진, 이름, 학번)
            ListTile(
              leading: InkWell(
                onTap: _uploadProfileImage,
                child: CircleAvatar(
                  // backgroundColor: Colors.grey,
                  backgroundImage: _profileImageUrl != null
                      ? _profileImageUrl!.isNotEmpty
                          ? NetworkImage(_profileImageUrl!)
                          : null
                      : null,
                  child: _profileImageUrl != null
                      ? _profileImageUrl!.isEmpty
                          ? const Icon(Icons.cancel)
                          : null
                      : const CircularProgressIndicator(),
                ),
              ),
              title: Text(_name ?? '데이터 로딩중..'),
              subtitle: _studentNumber != null
                  ? Text(_studentNumber!,
                      maxLines: 1, overflow: TextOverflow.ellipsis)
                  : null,
            ),
            //NOTE 비밀번호 변경 버튼
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('비밀번호 변경'),
              ElevatedButton(
                  onPressed: _changePasswordDialog, child: const Text('변경하기'))
            ])
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정")
      // ]),
    );
  }
}
