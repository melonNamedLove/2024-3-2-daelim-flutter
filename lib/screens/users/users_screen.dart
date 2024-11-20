import 'package:daelim/api_error.dart';
import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helper/api_helper.dart';
import 'package:daelim/models/user_data.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_sceen.dart';
import 'package:daelim/screens/users/widgets/user_item.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  // final List<UserData> _dummyDataList = List.generate(
  //   20,
  //   (i) {
  //     final index = i + 1;
  //     return UserData(
  //       id: '$index',
  //       name: "유저 $index",
  //       email: "$index@daelim.ac.kr",
  //       studentNumber: "$index",
  //       profileImageUrl: Config.image.defaultProfile,
  //     );
  //   },
  // );
  List<UserData> _users = [];
  List<UserData> _searchedUsers = [];

  final _defaultInputBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFE4E4E7),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)));

// NOTE: 유저 목록 가져오기
  Future<void> _fetchUserList() async {
    _users = await ApiHelper.fetchUserList();
    Log.green('유저 목록 : ${_users.length}');
    setState(() {
      _searchedUsers = _users;
    });
  }

  //NOTE: 유저검색
  void _onSearch(String value) {
    setState(() {
      _searchedUsers = _users
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  //NOTE: 채팅방 개설
  void _onCreateRoom(UserData user) async {
    Log.green('채팅방 개설 : ${user.name}');
    final (code, error) = await ApiHelper.createChatRoom(user.id);
    Log.green(code);
    Log.green(error);
    if (code == ApiError.createChatRoom.success) {
      //채팅방 개설 완료
    } else if (code == ApiError.createChatRoom.requiredUserId) {
      //상대방 ID 는 필수입니다
    } else if (code == ApiError.createChatRoom.cannotMySelf) {
      //자기 자신과 대화할 수 없습니다.
    } else if (code == ApiError.createChatRoom.notFound) {
      //상대방을 찾을 수 없습니다.
    } else if (code == ApiError.createChatRoom.onlyCanChatbot) {
      //챗봇 계정만 대화할 수 있습니다.
    } else if (code == ApiError.createChatRoom.alreadyRoom) {
      //이미 생성된 채팅방이 있습니다.
    }
    // //채팅방 개설 실패
    // if (code != 200) {
    //   Log.red('채팅방 개설 실패 : $error');
    // }

    // //NOTE 채팅방 개설 성공
    // context.showSnackBar("ee");
    // Log.green(error);
  }

  @override
  Widget build(BuildContext context) {
    final userCount = _searchedUsers.length;
    return AppScaffold(
      appScreen: AppScreen.users,
      appBar: AppBar(
          leadingWidth: 0,
          titleSpacing: 0,
          leading: const SizedBox.shrink(),
          title: Text(
            "유저 목록 ($userCount)",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            // style: context.thene.textTheme.titleLarge
          ),
          actions: const []),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ///유저 목록 ㅌ이틀
            // Text("유저 목록 ($userCount)",
            //     style:
            //         const TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
            15.heightBox,

            // NOTE :검색바
            TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                filled: false,
                enabledBorder: _defaultInputBorder,
                focusedBorder: _defaultInputBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(LucideIcons.search),
                hintText: "유저 검색...",
              ),
            ),
          ]),
        ),
        const Divider(),

        if (_searchedUsers.isEmpty)
          // NOTE: 검색결과 없음
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: const Text("검색 결과가 없습니다.", style: TextStyle(fontSize: 20)),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: _searchedUsers.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final user = _searchedUsers[index];
                return UserItem(user: user, onTap: () => _onCreateRoom(user));
              },
            ),
          ),

        // NOTE: 유저 리스트뷰
      ]),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정")
      // ]),
    );
  }
}
