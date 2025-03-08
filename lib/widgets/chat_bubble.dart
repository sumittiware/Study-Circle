// Chat Bubble widget
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:study_circle/models/chat.dart';
import 'package:study_circle/ui/custom_text_highlight.dart';
import 'package:markdown/markdown.dart' as md;

class ChatWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onStartQuiz;
  const ChatWidget({
    super.key,
    required this.message,
    required this.onStartQuiz,
  });

  int getTimeDifferenceInMinutes(int startTime, int endTime) {
    // Calculate the difference in milliseconds
    int differenceInMillis = endTime - startTime;

    // Convert milliseconds to minutes
    int differenceInMinutes = (differenceInMillis / 60000).round();

    return differenceInMinutes;
  }

  @override
  Widget build(BuildContext context) {
    bool isSentByMe = message.message.isOwnMessage;
    bool isSentByAllie = message.message.isAllieMessage;
    final mediaQuery = MediaQuery.of(context);

    final text = message.message.text;

    if (message.messageType == "LEADERBOARD") {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff2E3357),
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assest/images/leaderboard.png"),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment:
          (isSentByMe) ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isSentByAllie)
          Image.asset("assest/images/allie.png", height: 45, width: 45),
        if (!isSentByAllie && !isSentByMe)
          RandomAvatar(message.message.senderId, height: 45, width: 45),
        Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: mediaQuery.size.width - 100),
            decoration: BoxDecoration(
              color:
                  isSentByMe
                      ? Color(0xff0266DA)
                      : isSentByAllie
                      ? Color(0xff2E3357)
                      : Color(0xff383838),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft:
                    isSentByMe ? Radius.circular(24) : Radius.circular(4),
                bottomRight:
                    isSentByMe ? Radius.circular(4) : Radius.circular(24),
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              children: [
                if (isSentByAllie &&
                    message.message.parentTextMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color(0xff212121),
                    ),
                    child: MarkdownBody(
                      data: message.message.parentTextMessage,
                      builders: {"p": CustomTextHighlight()},
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isSentByMe ? Colors.white : Color(0xffBCBDBD),
                          fontSize: 16,
                        ),
                        listBullet: TextStyle(
                          color: isSentByMe ? Colors.white : Color(0xffBCBDBD),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (isSentByAllie &&
                    message.message.parentTextMessage.isNotEmpty)
                  SizedBox(height: 8),

                if (message.messageType == "QUIZ" && message.ctaDetails != null)
                  Container(
                    height: 180,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assest/images/quiz.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: Color(0xff212121),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.ctaDetails!.subject,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "QUESTIONS",
                                  style: TextStyle(
                                    color: Color(0xffbcbcbc),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${message.ctaDetails!.questionCount}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "TIME",
                                  style: TextStyle(
                                    color: Color(0xffbcbcbc),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${message.ctaDetails!.duration} mins",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                message.ctaDetails!.isEnabled
                                    ? () =>
                                        onStartQuiz(message.ctaDetails!.refId)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0266DA),
                            ),
                            child: Text(
                              message.ctaDetails!.ctaText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                MarkdownBody(
                  data: text,
                  builders: {"p": CustomTextHighlight()},
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    <md.InlineSyntax>[
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                    ],
                  ),
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: isSentByMe ? Colors.white : Color(0xffBCBDBD),
                      fontSize: 16,
                    ),
                    listBullet: TextStyle(
                      color: isSentByMe ? Colors.white : Color(0xffBCBDBD),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
