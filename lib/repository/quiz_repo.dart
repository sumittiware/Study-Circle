import 'package:study_circle/global/global_variables.dart';
import 'package:study_circle/models/quiz.dart';

class QuizRepository {
  static Future<TestModel> fetchTest(String quizId) async {
    try {
      final response = await httpService.get("$serverHost/v1/quiz/$quizId");

      // Explicitly cast to List<ChatMessage>
      TestModel test = TestModel.fromJson(response);

      return test;
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> submitAnswer(QuizAnswer request) async {
    try {
      await httpService.post("$serverHost/v1/quiz/answer", body: request);
    } catch (err) {
      rethrow;
    }
  }
}
