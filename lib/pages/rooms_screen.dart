import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_circle/models/chat.dart';
import 'package:study_circle/models/room.dart';
import 'package:study_circle/pages/quiz_screen.dart';
import 'package:study_circle/repository/chat_repository.dart';
import 'package:study_circle/repository/quiz_repo.dart';
import 'package:study_circle/widgets/chat_bubble.dart';
import 'package:study_circle/widgets/textbox.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  Timer? _timer;

  @override
  void initState() {
    Future.delayed(Duration.zero, () => fetchChat(true));
    //Refresh / poll in each 2 sec
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      fetchChat(false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchChat(bool? shouldScroll) async {
    try {
      final chatMessages = await ChatRepository.fetchMessages(
        widget.room.roomId,
      );

      setState(() {
        _messages.clear();
        _messages.addAll(chatMessages);
      });

      // Ensure scrolling happens after UI updates
      if (shouldScroll != null && shouldScroll) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
      setState(() {});
    } catch (err) {
      Fluttertoast.showToast(msg: "Error fetching messages");
    }
  }

  Future<void> submitMessage() async {
    String message = _controller.text;
    bool sendToAllie = message.contains("@Allie");

    // Add this so that we can have this as condition in regex
    message = message.replaceFirst("@Allie", "!!@Allie!!");

    final chatMessage = SubmitMessageRequest(
      groupId: widget.room.roomId,
      text: message,
      sendToAllie: sendToAllie,
    );

    try {
      await ChatRepository.submitMessage(chatMessage);
      Fluttertoast.showToast(msg: "Message sent");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    } catch (err) {
      Fluttertoast.showToast(msg: "Error submitting message!");
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.room.roomName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff2e2e2e),
        actions: [
          IconButton(icon: Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatListWidget(
              scrollController: _scrollController,
              messages: _messages,
              refreshChat: () {
                fetchChat(true);
              },
            ),
          ),

          TypeWidget(
            textEditingController: _controller,
            room: widget.room,
            refreshChat: () async {
              await submitMessage();
              await fetchChat(true);
            },
          ),
        ],
      ),
    );
  }
}

// Chat List widget
class ChatListWidget extends StatefulWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final Function() refreshChat;

  const ChatListWidget({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.refreshChat,
  });

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  Future<void> onStartQuiz(MessageDetails message, String quizID) async {
    try {
      final test = await QuizRepository.fetchTest(quizID);
      if (!context.mounted) return;

      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) {
                return QuizScreen(groupId: message.groupId, test: test);
              },
            ),
          )
          .then((_) => widget.refreshChat());
    } catch (err) {
      Fluttertoast.showToast(msg: "Error getting quiz");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 8),
            children: List.generate(
              widget.messages.length,
              (i) => ChatWidget(
                message: widget.messages[i],
                onStartQuiz:
                    (String quizId) =>
                        onStartQuiz(widget.messages[i].message, quizId),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
