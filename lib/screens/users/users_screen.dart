import 'package:daelim/common/scaffold/app_scaffold.dart';
import 'package:daelim/config.dart';
import 'package:daelim/models/user_data.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<UserData> _dummyDataList = List.generate(
    20,
    (i) {
      final index = i + 1;
      return UserData(
        id: '$index',
        name: "유저 $index",
        email: "$index@daelim.ac.kr",
        studentNumber: "$index",
        profileImageUrl: defaultProfileImageUrl,
      );
    },
  );
  List<UserData> _searchedDataList = [];

  final _defaultInputBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFE4E4E7),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  void _initState() {
    super.initState();
    _searchedDataList = _dummyDataList;
  }

  //NOTE: 유저검색
  void _onSearch(String value) {
    setState(() {
      _searchedDataList = _dummyDataList
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.users,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ///유저 목록 ㅌ이틀
            const Text("유저 목록",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
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

        if (_searchedDataList.isEmpty)
          // NOTE: 검색결과 없음
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: const Text("검색 결과가 없습니다.", style: TextStyle(fontSize: 20)),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: _searchedDataList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final dummy = _searchedDataList[index];
                return ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(dummy.profileImageUrl),
                  ),
                  title: Text(dummy.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(dummy.studentNumber),
                );
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
