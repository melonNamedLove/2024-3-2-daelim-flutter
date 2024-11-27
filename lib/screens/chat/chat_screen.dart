import 'package:daelim/helper/api_helper.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _primaryColor = const Color(0xff4e80ee);
  final _secondaryColor = Colors.white;
  final _backgroundColor = const Color(0xfff3f4f6);

  var _dummyChatList = List<Map<String, dynamic>>.generate(6, (index) {
    return {
      'sender_id': index % 2 == 0 ? 'b' : 'a',
      'message': '안녕하세요! 눈이 많이 내리네요',
      'created_at': DateTime.now().add(-index.toMinute)
    };
  });

  @override
  void initState() {
    super.initState();

    _dummyChatList = _dummyChatList.sortedBy((e) => e['created_at']);
  }

  void _onSendMessage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(title: const Text('챗봇')),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _dummyChatList.length,
                separatorBuilder: (context, index) {
                  return 10.heightBox;
                },
                itemBuilder: (context, index) {
                  final dummy = _dummyChatList[index];
                  final senderId = dummy['sender_id'];
                  final message = dummy['message'];
                  final DateTime createdAt = dummy['created_at'];

                  final isMy = senderId == 'a';
                  return Row(
                    mainAxisAlignment: isMy //
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                          constraints: const BoxConstraints(
                              maxWidth: 200, minHeight: 60),
                          color: dummy['sender_id'] == 'a' //
                              ? _primaryColor
                              : _secondaryColor,
                          child: ListTile(
                            title: Text(message),
                            subtitle: Text(createdAt.toFormat('HH:mm')),
                          )),
                    ],
                  );
                },
              ),
            ),
            // NOTE :메시지 전송 영역
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: _secondaryColor,
                  border: Border(top: BorderSide(color: Colors.grey[300]!))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        filled: false,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                  10.widthBox,
                  ElevatedButton(
                      onPressed: _onSendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                      ),
                      child: const Text(
                        '전송',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
