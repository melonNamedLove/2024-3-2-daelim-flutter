import 'dart:async';

import 'package:daelim/helper/api_helper.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _client = Supabase.instance.client;
  StreamSubscription<List<Map<String, dynamic>>>? _messageStream;

  String get _roomId => widget.roomId;
  final _textController = TextEditingController();

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
    _startMessageStream();
  }

  @override
  void dispose() {
    _textController.dispose();
    _stopMessageStram();
    super.dispose();
  }

//NOTE 메세지 스트림
  void _startMessageStream() {
    final client = Supabase.instance.client;

    _messageStream = client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', _roomId)
        .listen((data) {
          Log.green(data);
        }, onError: (e, stack) {
          Log.red('$e $stack');
        });
  }

//flutter에만있는 dispose개념 supa docs에는 안적혀있음
  void _stopMessageStram() {
    _messageStream?.cancel();
    _messageStream = null;
  }

//NOTE 메세지 전송하기
  Future<void> _onSendMessage() async {
    final message = _textController.text;
    final senderId = StorageHelper.authData!.userId;
    if (message.isEmpty || message.trim().isEmpty) {
      return;
    }

    _client //
        .from('chat_messages')
        .insert({'room_id': _roomId, 'sender_id': senderId, 'message': message})
        .then((value) => {true, ''})
        .catchError((e, stack) => (false, e.toString()));

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(title: const Text('챗봇')),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<dynamic>>(
                    stream: _client
                        .from('chat_messages')
                        .stream(primaryKey: ['id']).eq('room_id', _roomId),
                    builder: (context, snapshot) {
                      // Handle loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Handle errors
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // Ensure data is not null
                      final data = snapshot.data ?? [];

                      // Handle empty data
                      if (data.isEmpty) {
                        return const Center(
                          child:
                              Text('메세지를 전송하세요'), // "Send a message" in Korean
                        );
                      }

                      // Display the list of messages
                      return ListView.separated(
                        itemCount: _dummyChatList.length,
                        separatorBuilder: (context, index) {
                          return 15.heightBox;
                        },
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                                  decoration: BoxDecoration(
                                      color: dummy['sender_id'] == 'a' //
                                          ? _primaryColor
                                          : _secondaryColor,
                                      // borderRadius: BorderRadius.circular(10),
                                      borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(!isMy ? 0 : 10),
                                          topRight:
                                              Radius.circular(isMy ? 0 : 10),
                                          bottomLeft: const Radius.circular(10),
                                          bottomRight:
                                              const Radius.circular(10)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 2),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ]),
                                  child: ListTile(
                                    title: Text(
                                      message,
                                      style: TextStyle(
                                          color: isMy
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    subtitle: Text(
                                      createdAt.toFormat('HH:mm'),
                                      style: TextStyle(
                                          color: isMy
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  )),
                            ],
                          );
                        },
                      );
                    })),
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
                      controller: _textController,
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
