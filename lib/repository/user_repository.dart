import 'package:study_circle/global/global_variables.dart';
import 'package:study_circle/http/http_client.dart';

class UserRepository {
  static Future<String> fetchUser(String userNumber) async {
    try {
      print("called");
      final response = await HttpService().get(
        "$serverHost/v1/user_mapping/$userNumber",
      );

      // Explicitly cast to List<ChatMessage>

      return response;
    } catch (err) {
      print("Error getting response");
      rethrow;
    }
  }
}
