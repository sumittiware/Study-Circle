class TestModel {
  final String id;
  final String groupId;
  final String subject;
  final int startTime;
  final int endTime;
  final List<Question> questions;

  TestModel({
    required this.id,
    required this.groupId,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.questions,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      groupId: json['group_id'],
      subject: json['subject'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'subject': subject,
      'start_time': startTime,
      'end_time': endTime,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final String id;
  final String text;
  final List<Option> options;

  Question({required this.id, required this.text, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options:
          (json['options'] as List).map((opt) => Option.fromJson(opt)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options.map((opt) => opt.toJson()).toList(),
    };
  }
}

class Option {
  final String id;
  final String text;

  Option({required this.id, required this.text});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(id: json['id'], text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class QuizAnswer {
  final String quizId;
  final String questionId;
  final String optionId;
  final int answerTime;

  QuizAnswer({
    required this.quizId,
    required this.questionId,
    required this.optionId,
    required this.answerTime,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      quizId: json['quiz_id'],
      questionId: json['question_id'],
      optionId: json['option_id'],
      answerTime: json['answer_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'question_id': questionId,
      'option_id': optionId,
      'answer_time': answerTime,
    };
  }
}
