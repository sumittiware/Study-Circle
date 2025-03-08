import 'package:study_circle/global/global_variables.dart';
import 'package:study_circle/models/chat.dart';

class ChatRepository {
  static Future<List<ChatMessage>> fetchMessages(String groupId) async {
    try {
      final response = await httpService.get(
        "$serverHost/v1/circle/feed/$groupId",
      );

      print("Got messages");

      // Explicitly cast to List<ChatMessage>
      List<ChatMessage> messages =
          (response["messages"] as List)
              .map((json) => ChatMessage.fromJson(json))
              .toList();

      return messages;
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> submitMessage(SubmitMessageRequest request) async {
    try {
      await httpService.post("$serverHost/v1/circle/message", body: request);
    } catch (err) {
      rethrow;
    }
  }
}
